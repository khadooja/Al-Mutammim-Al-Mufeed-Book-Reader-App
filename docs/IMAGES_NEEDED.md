# Images Needed — المتمم المفيد

Status as of the multi-book library milestone.

The extracted images for *المتمم المفيد* are now bundled at
`lib/assets_data/books/al_mutammim_al_mufeed/images/`. The book's JSON
references **63** images; **62** are present and rendering.

*المدخل إلى علم التجويد* contains no images, so nothing is needed for it.

## Outstanding

| Referenced path | Status |
|---|---|
| `images/img-011-002.jpg` | **Missing** — referenced by chapter 2 (مبادئ علم التجويد), no file delivered |

Dropping a file with that exact name into the images folder is all that's
needed; no code or JSON change is required. Until then, that one block
renders the reader's "الصورة غير متوفرة بعد" fallback rather than a broken
image (covered by a test in `test/real_images_test.dart`).

## Note on filenames

The delivered image files each carried a ` (1)` suffix (e.g.
`img-033-003 (1).jpg`) from the download, which did not match the `path`
values in `book.json`. They were renamed to strip that suffix so the paths
resolve. Any future batch of images should use the plain names exactly as
they appear in `book.json`.
