#!/usr/bin/env python3
"""
convert_book.py — turn an updated book file (.doc/.docx/.pdf) into this
project's book.json format, without needing a full manual re-processing
pass every time the author sends a revision.

USAGE
-----
1. Open the source file yourself once and skim its table of contents.
2. Fill in a small "chapters config" JSON describing chapter titles and
   page/paragraph ranges (see chapters.example.json in this folder).
3. Run:

   python convert_book.py \
       --input "/path/to/book.pdf" \
       --config chapters.json \
       --output book.json \
       --images-out ./images        # optional, only relevant for PDFs with real images

WHY OCR (for PDFs)
-------------------
Many Arabic desktop-published PDFs (Word -> PDF export with custom fonts
like "Lotus Linotype", "Traditional Arabic", etc.) embed a *corrupted*
text layer: copying text out of them (or running pdftotext) gives
scrambled/ciphered Arabic, not the real words. This is a font
cmap/encoding issue, not something fixable by re-parsing — the only
reliable fix is OCR (reading the rendered page image), which is what
this script does for PDFs.

If your source is a modern .docx (or a legacy .doc you converted first),
the text layer is normally fine and OCR is not needed — see --input-type.

REQUIREMENTS (install once, locally)
-------------------------------------
- poppler-utils   (pdftoppm, pdftotext, pdfimages)  — `apt install poppler-utils` / `brew install poppler`
- tesseract-ocr with the Arabic language pack:
    apt install tesseract-ocr tesseract-ocr-ara
    (or download ara.traineddata from
     https://github.com/tesseract-ocr/tessdata_best and set TESSDATA_PREFIX)
- pandoc + LibreOffice (`soffice`)  — only needed for .doc/.docx input
    apt install pandoc libreoffice

CHAPTERS CONFIG FORMAT
-----------------------
See chapters.example.json. Key fields:
- "book": the book's own metadata (id, title, subtitle, author, description)
- "chapters": ordered list of {title, start_page, end_page, icon}
    * For PDFs, pages are 1-indexed PDF page numbers (i.e. what
      `pdftoppm`/`pdfimages` call pages — NOT the printed page number in
      the book, which is often offset by 1 or 2 because of an
      unnumbered cover/blank page). Open the source once, note the
      offset, and just add it to the printed TOC page numbers.
    * For DOCX input, use {"title": ..., "start_marker": "...", "end_marker": ...}
      instead (exact text of the heading line) — see the example file.
- "sub_headings": optional {"<page_or_marker>": "Sub-heading text"} for
  second-level headings inside a chapter (e.g. named articulation-point
  sections inside a "مخارج الحروف" chapter).
- "decorative_pages": PDF page numbers whose embedded images are cover
  art / back-cover decoration, not real content diagrams — skip them.

WHAT THIS SCRIPT DOES NOT AUTOMATE
------------------------------------
Chapter boundaries still need a human to skim the TOC once per revision
and note page numbers in the config — that's a 5-minute job, not hours.
Everything after that (OCR/extraction, decorative-noise filtering,
paragraph/heading/image structuring, JSON building) is automatic.

The output is still a first draft: skim a chapter or two after
converting, same as always, especially after the source content itself
changed (not just re-running on an unchanged file).
"""

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile


# ---------------------------------------------------------------------------
# Text cleaning — shared by every extraction path
# ---------------------------------------------------------------------------

COMMON_SHORT_WORDS = {
    'من', 'في', 'على', 'إلى', 'عن', 'مع', 'بن', 'ابن', 'أبو', 'أبي', 'أب',
    'ما', 'لا', 'لم', 'لن', 'إن', 'أن', 'إذ', 'إذا', 'كل', 'قد', 'ثم',
    'أو', 'او', 'يا', 'هو', 'هي', 'هم', 'أنت', 'انت', 'لك', 'له', 'لها',
    'به', 'بها', 'بهم', 'بكم', 'بي', 'بك', 'كما', 'كي', 'لو', 'لولا',
    'بل', 'حتى', 'إلا', 'الا', 'غير', 'سوى', 'عند', 'قبل', 'بعد', 'دون',
    'عليه', 'عليها', 'عليهم', 'منه', 'منها', 'منهم', 'فيه', 'فيها',
    'رب', 'الله', 'لله', 'بالله', 'والله', 'تعالى', 'وقال', 'قال', 'قالت',
    'روى', 'رواه', 'أخرجه', 'صلى', 'وسلم', 'رضي', 'عنه', 'عنها', 'عنهم',
    'الذي', 'التي', 'الذين', 'اللذان', 'وهو', 'وهي', 'وهم', 'وما', 'ولا',
}


def _bare(tok: str) -> str:
    return tok.strip('،.:؛؟()[]«»"\'-|')


def _is_list_marker_or_symbol(tok: str) -> bool:
    """Digits, list markers (-١, ٢-, )١(, ||, brackets) — structural, not
    words at all, so they must not count as 'noise' OR as 'real content'
    in the short-word ratio; a numbered list is legitimate even though
    every marker token is short."""
    bare = _bare(tok)
    if not bare:
        return True  # pure punctuation/marker token like "-", "||", ")"
    if re.fullmatch(r'[\d٠-٩]+', bare):
        return True
    return False


def _is_arabic_letter_token(tok: str) -> bool:
    bare = _bare(tok)
    return bool(bare) and all('\u0600' <= ch <= '\u06FF' for ch in bare)


CONTENT_SIGNATURE_PATTERNS = [
    re.compile(r'\[[^\]]+:\s*[\d٠-٩©؟]+\]'),  # Quran reference like [البقرة: 5]
    re.compile(r'نحو\s*:'),
    re.compile(r'رواه|أخرجه|متفق'),
    re.compile(r'أي\s*:'),
    re.compile(r'^\s*[-)]?\s*[\d٠-٩]'),  # leading list marker: "-١ " / "٢- " / ")١("
    # a run of hyphen/space-separated single Arabic letters in parens, e.g.
    # "(ح-ي-ط- ه- ر)" — contrasting written vs. spoken letter forms; this is
    # real content, not the comma-separated letter list handled separately below
    re.compile(r'[\u0621-\u064A]\s*-\s*[\u0621-\u064A](?:\s*-\s*[\u0621-\u064A]){1,}'),
]


def _is_noise_token(tok: str) -> bool:
    bare = _bare(tok)
    if not bare:
        return True
    if bare in COMMON_SHORT_WORDS:
        return False
    # stray symbols fused into a "word" (+, ", *, etc.) never occur in
    # clean Arabic text — only in mangled decorative-border OCR output
    if any(not ('\u0600' <= ch <= '\u06FF' or ch in '٠١٢٣٤٥٦٧٨٩0123456789') for ch in bare):
        return True
    # OCR-corruption signatures regardless of length: digits fused into
    # an otherwise-Arabic token — never occurs in clean text
    if re.search(r'\d', bare) and re.search(r'[\u0600-\u06FF]', bare):
        return True
    return len(bare) <= 3


def significant_title_words(title: str, subtitle: str = '') -> frozenset:
    """Extract the words from a book's own title/subtitle that are long
    enough to be meaningful fingerprints (skips function words like إلى)."""
    text = f"{title} {subtitle}"
    words = re.findall(r'[\u0600-\u06FF]+', text)
    return frozenset(w for w in words if len(w) >= 3 and w not in COMMON_SHORT_WORDS)


def clean_line(line: str, title_words: frozenset = frozenset()) -> str | None:
    """Clean a single OCR/extracted line. Returns None if the line should
    be dropped (decorative border noise, running headers, empty, etc.).

    Note on running page headers/footers (e.g. "المدخل إلى علم التجويد"
    repeated on every page, wrapped in decorative border-OCR noise):
    pass this book's own significant title/subtitle words as `title_words`
    (see significant_title_words()) and lines that are dominated by (a)
    two or more of those words plus (b) otherwise-noisy surrounding
    tokens get dropped as a leaked header — this is book-title-aware
    instead of a hardcoded substring, so it generalizes to any book, and
    it does NOT touch a real sentence that legitimately mentions the
    title/a companion book's title (e.g. Mutammim's own text referencing
    "المدخل إلى علم التجويد"), because those sentences have coherent real
    words around the title mention rather than noise.

    Three things keep this from over-deleting real content:
    1. List markers/digits (-١, ٢-, )١() are excluded from the noise
       ratio entirely — a numbered list is legitimate even though every
       marker token is short.
    2. A line matching a recognizable content signature (Quran reference,
       "نحو:", "رواه/أخرجه/متفق", "أي:", or a leading list marker) is kept
       regardless of the ratio checks.
    3. The single-char-token rule is skipped when the short tokens are
       Arabic letters separated by ،/- — that's the shape of a letter
       list or a waqf-sign list (م، لا، ج، صلى، قلى، س), not noise.
    """
    line = line.replace('\u200f', '').replace('\u200e', '').strip()
    if not line:
        return None

    arabic_chars = re.findall(r'[\u0600-\u06FF]', line)

    if len(arabic_chars) < 2 and len(line) < 15:
        return None
    if re.fullmatch(r'[.\s()»«:>ء-ي0-9٠-٩]+', line) and len(arabic_chars) < 3:
        return None

    # book-title-aware running-header detection (see docstring above) runs
    # BEFORE the content-signature hard-keep below, since a leaked header
    # can start with a stray OCR'd digit that would otherwise false-match
    # the "leading list marker" signature.
    if title_words:
        found_words = {w for w in title_words if w in line}
        if len(found_words) >= 2:
            stripped = line
            for w in found_words:
                stripped = stripped.replace(w, ' ')
            remaining = [t for t in stripped.split() if _bare(t)]
            if not remaining or sum(1 for t in remaining if _is_noise_token(t)) / len(remaining) >= 0.5:
                return None

    # hard-keep: recognizable content signature overrides the noise checks
    if any(p.search(line) for p in CONTENT_SIGNATURE_PATTERNS):
        line = line.replace('»', '،').replace('«', '')
        line = re.sub(r'،\s*،+', '،', line)
        return re.sub(r'\s+', ' ', line).strip() or None

    tokens = line.split()

    if tokens:
        # a letter/sign list (م، لا، ج، صلى، قلى، س) is short-token-heavy
        # by nature and must not be treated like noise
        # a real letter/sign list (م، لا، ج، صلى، قلى، س) is explicitly
        # comma-separated — that's what distinguishes it from run-together
        # decorative-border gibberish, which never has consistent commas
        comma_count = sum(1 for t in tokens if _bare(t) == '')
        non_sep_tokens = [t for t in tokens if _bare(t) != '']
        short_arabic = sum(1 for t in non_sep_tokens if _is_arabic_letter_token(t) and len(_bare(t)) <= 4)
        letter_list_shape = comma_count >= 2 and non_sep_tokens and short_arabic / len(non_sep_tokens) > 0.6

        substantive_tokens = [t for t in tokens if not _is_list_marker_or_symbol(t)]

        if not letter_list_shape and substantive_tokens:
            single_char_tokens = sum(1 for t in substantive_tokens if len(_bare(t)) <= 1)
            if len(substantive_tokens) >= 3 and single_char_tokens / len(substantive_tokens) > 0.4:
                return None
            noise_tokens = sum(1 for t in substantive_tokens if _is_noise_token(t))
            if len(substantive_tokens) >= 4 and noise_tokens / len(substantive_tokens) > 0.6:
                return None
        if substantive_tokens and len(substantive_tokens) <= 6 and \
                sum(len(_bare(t)) for t in substantive_tokens) / len(substantive_tokens) < 1.8:
            return None

    line = line.replace('»', '،').replace('«', '')
    line = re.sub(r'،\s*،+', '،', line)
    line = re.sub(r'\s+', ' ', line).strip()
    return line or None

def strip_docx_spans(text: str) -> str:
    """Strip pandoc's [text]{attr} span wrappers (from docx->markdown),
    handling nested spans, without touching literal escaped brackets
    (e.g. Quran citation notation like "[Surah: 29-30]")."""
    text = text.replace('\\[', '\x01LB\x01').replace('\\]', '\x01RB\x01').replace('\\*', '\x01AST\x01')
    prev = None
    while prev != text:
        prev = text
        text = re.sub(r'\]\{[^{}]*\}', '', text)
    prev = None
    while prev != text:
        prev = text
        text = re.sub(r'\*\*([^*]*)\*\*', r'\1', text)
    text = text.replace('[', '').replace(']', '')
    text = text.replace('\x01LB\x01', '[').replace('\x01RB\x01', ']').replace('\x01AST\x01', '*')
    text = re.sub(r'\\([_\-.\"])', r'\1', text)
    text = text.replace('\\', '')
    return re.sub(r'\s+', ' ', text).strip()


def dedupe_consecutive(blocks: list) -> list:
    out, prev_text = [], None
    for b in blocks:
        if b['type'] == 'text':
            norm = re.sub(r'\s+', '', b['text'])
            if norm == prev_text:
                continue
            prev_text = norm
        else:
            prev_text = None
        out.append(b)
    return out


# ---------------------------------------------------------------------------
# PDF extraction (OCR-based — see module docstring for why)
# ---------------------------------------------------------------------------

def ocr_pdf_pages(pdf_path: str, work_dir: str, dpi: int = 300) -> dict[int, str]:
    """Rasterize every page and OCR it. Returns {page_number: raw_text}."""
    pages_dir = os.path.join(work_dir, 'pages')
    os.makedirs(pages_dir, exist_ok=True)
    subprocess.run(['pdftoppm', '-png', '-r', str(dpi), pdf_path, os.path.join(pages_dir, 'page')], check=True)

    page_files = sorted(f for f in os.listdir(pages_dir) if f.endswith('.png'))
    texts = {}
    for fname in page_files:
        page_num = int(re.search(r'page-(\d+)', fname).group(1))
        img_path = os.path.join(pages_dir, fname)
        result = subprocess.run(
            ['tesseract', img_path, 'stdout', '-l', 'ara', '--psm', '6'],
            capture_output=True, text=True
        )
        texts[page_num] = result.stdout
    return texts


def extract_pdf_images(pdf_path: str, work_dir: str, decorative_pages: set[int]) -> dict[int, list[str]]:
    """Extract embedded raster images, skipping decorative pages.
    Returns {page_number: [filename, ...]} and writes files into
    work_dir/images/."""
    images_dir = os.path.join(work_dir, 'images')
    os.makedirs(images_dir, exist_ok=True)
    subprocess.run(['pdfimages', '-j', '-p', pdf_path, os.path.join(images_dir, 'img')], check=True)

    by_page: dict[int, list[str]] = {}
    for fname in sorted(os.listdir(images_dir)):
        m = re.match(r'img-(\d+)-(\d+)\.\w+', fname)
        if not m:
            continue
        page = int(m.group(1))
        if page in decorative_pages:
            os.remove(os.path.join(images_dir, fname))
            continue
        by_page.setdefault(page, []).append(fname)
    return by_page


# ---------------------------------------------------------------------------
# DOCX extraction (use when the text layer is NOT corrupted)
# ---------------------------------------------------------------------------

def extract_docx_paragraphs(docx_path: str, work_dir: str, title_words: frozenset = frozenset()) -> list[str]:
    """Convert via pandoc to markdown, strip span wrappers, return a flat
    list of cleaned paragraphs in document order."""
    md_path = os.path.join(work_dir, 'doc.md')
    subprocess.run(['pandoc', '-t', 'markdown', docx_path, '-o', md_path], check=True)
    raw = open(md_path, encoding='utf-8').read()
    paras = re.split(r'\n\s*\n', raw)
    out = []
    for p in paras:
        cleaned = strip_docx_spans(p)
        c = clean_line(cleaned, title_words)
        if c:
            out.append(c)
    return out


# ---------------------------------------------------------------------------
# Book building
# ---------------------------------------------------------------------------

def build_from_pdf(cfg: dict, pdf_path: str, images_out: str | None) -> dict:
    title_words = significant_title_words(cfg['book'].get('title', ''), cfg['book'].get('subtitle', ''))
    work_dir = tempfile.mkdtemp(prefix='convert_book_')
    print(f"[1/4] OCR'ing pages (this can take a while for long books)...", file=sys.stderr)
    page_texts = ocr_pdf_pages(pdf_path, work_dir)

    decorative_pages = set(cfg.get('decorative_pages', []))
    print(f"[2/4] Extracting embedded images...", file=sys.stderr)
    images_by_page = extract_pdf_images(pdf_path, work_dir, decorative_pages)

    sub_headings = {int(k): v for k, v in cfg.get('sub_headings', {}).items()}

    print(f"[3/4] Structuring chapters...", file=sys.stderr)
    chapters_out = []
    for idx, ch in enumerate(cfg['chapters'], start=1):
        blocks = [{"type": "heading", "level": 1, "text": ch['title']}]
        for p in range(ch['start_page'], ch['end_page'] + 1):
            if p in sub_headings:
                blocks.append({"type": "heading", "level": 2, "text": sub_headings[p]})
            raw = page_texts.get(p, '')
            for ln in raw.split('\n'):
                c = clean_line(ln, title_words)
                if not c:
                    continue
                if c.strip('《》: ').strip() == ch['title']:
                    continue
                blocks.append({"type": "text", "text": c})
            for imgfile in images_by_page.get(p, []):
                blocks.append({"type": "image", "path": f"images/{imgfile}", "caption": None})
        blocks = dedupe_consecutive(blocks)
        chapters_out.append({
            "id": f"ch{idx}", "number": idx, "title": ch['title'],
            "icon": ch.get('icon', 'book'), "sections": [{"blocks": blocks}]
        })

    if images_out and images_by_page:
        os.makedirs(images_out, exist_ok=True)
        src_dir = os.path.join(work_dir, 'images')
        for fname in os.listdir(src_dir):
            os.replace(os.path.join(src_dir, fname), os.path.join(images_out, fname))
        print(f"[4/4] {len(os.listdir(images_out))} images written to {images_out}", file=sys.stderr)

    book = dict(cfg['book'])
    book['chapters'] = chapters_out
    return book


def build_from_docx(cfg: dict, docx_path: str) -> dict:
    title_words = significant_title_words(cfg['book'].get('title', ''), cfg['book'].get('subtitle', ''))
    work_dir = tempfile.mkdtemp(prefix='convert_book_')
    print("[1/2] Extracting and cleaning paragraphs...", file=sys.stderr)
    paragraphs = extract_docx_paragraphs(docx_path, work_dir, title_words)

    print("[2/2] Structuring chapters by heading markers...", file=sys.stderr)
    chapters_cfg = cfg['chapters']
    # find the paragraph index of each chapter's start_marker
    bounds = []
    for ch in chapters_cfg:
        marker = ch['start_marker'].strip('《》: ').strip()
        idx = next((i for i, p in enumerate(paragraphs) if p.strip('《》: ').strip() == marker), None)
        if idx is None:
            print(f"WARNING: start_marker not found for chapter '{ch['title']}': {marker!r}", file=sys.stderr)
            idx = len(paragraphs)
        bounds.append(idx)
    bounds.append(len(paragraphs))

    sub_headings = cfg.get('sub_headings', {})  # {marker_text: heading_text}

    chapters_out = []
    for i, ch in enumerate(chapters_cfg):
        start, end = bounds[i], bounds[i + 1]
        blocks = [{"type": "heading", "level": 1, "text": ch['title']}]
        for p in paragraphs[start:end]:
            bare = p.strip('《》: ').strip()
            if bare == ch['title'].strip('《》: ').strip():
                continue
            if bare in sub_headings:
                blocks.append({"type": "heading", "level": 2, "text": sub_headings[bare]})
                continue
            blocks.append({"type": "text", "text": p})
        blocks = dedupe_consecutive(blocks)
        chapters_out.append({
            "id": f"ch{i+1}", "number": i + 1, "title": ch['title'],
            "icon": ch.get('icon', 'book'), "sections": [{"blocks": blocks}]
        })

    book = dict(cfg['book'])
    book['chapters'] = chapters_out
    return book


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--input', required=True, help='Path to the source .pdf, .docx, or .doc file')
    ap.add_argument('--config', required=True, help='Path to the chapters config JSON')
    ap.add_argument('--output', required=True, help='Path to write the resulting book.json')
    ap.add_argument('--images-out', default=None, help='Directory to write extracted images into (PDF only)')
    args = ap.parse_args()

    cfg = json.load(open(args.config, encoding='utf-8'))
    ext = os.path.splitext(args.input)[1].lower()

    if ext == '.pdf':
        book = build_from_pdf(cfg, args.input, args.images_out)
    elif ext in ('.docx', '.doc'):
        input_path = args.input
        if ext == '.doc':
            work_dir = tempfile.mkdtemp(prefix='convert_book_')
            subprocess.run(['soffice', '--headless', '--convert-to', 'docx', '--outdir', work_dir, args.input], check=True)
            input_path = os.path.join(work_dir, os.path.splitext(os.path.basename(args.input))[0] + '.docx')
        book = build_from_docx(cfg, input_path)
    else:
        sys.exit(f"Unsupported input type: {ext} (expected .pdf, .docx, or .doc)")

    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(book, f, ensure_ascii=False, indent=2)

    total_blocks = sum(len(s['blocks']) for c in book['chapters'] for s in c['sections'])
    print(f"\nDone. {len(book['chapters'])} chapters, {total_blocks} blocks -> {args.output}", file=sys.stderr)


if __name__ == '__main__':
    main()
