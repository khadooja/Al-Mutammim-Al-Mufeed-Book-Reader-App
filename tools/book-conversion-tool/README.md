# Book content pipeline

`convert_book.py` turns an updated book file (PDF or Word doc) from the author
into this project's `book.json` format — the same conversion that was
previously done by hand each time.

## One-time setup (per machine)

```bash
# Linux (adjust for your OS)
sudo apt install poppler-utils tesseract-ocr pandoc libreoffice

# Arabic OCR language pack (needed for PDF input)
mkdir -p ~/tessdata
curl -L -o ~/tessdata/ara.traineddata \
  https://raw.githubusercontent.com/tesseract-ocr/tessdata_best/main/ara.traineddata
export TESSDATA_PREFIX=~/tessdata   # add this to your shell profile
```

## Every time the author sends a revision

1. Open the file once yourself and skim its table of contents to note chapter
   titles and page numbers (PDF) or exact heading text (Word).
2. Copy `chapters.example.pdf.json` or `chapters.example.docx.json`, fill in
   the real chapter list for this book (5–10 minutes).
3. Run:

```bash
python convert_book.py \
  --input "/path/to/updated_book.pdf" \
  --config chapters.my_book.json \
  --output book.json \
  --images-out ./images        # PDFs only, omit if the book has no images
```

4. Copy `book.json` (and `images/`, if any) into the app's
   `assets_data/books/<book_id>/` folder.
5. Skim a chapter or two in the output before shipping — this is still an
   automated first pass, not a substitute for the author's proofread.

See the top of `convert_book.py` for full details on the config format and
why PDFs go through OCR instead of direct text extraction.
