#!/bin/sh
# Rebuilds the free guide's PDF, and the cover image the website shows, from index.html.
# Run on the Mac from this folder's root: sh site-modern/guide/build.sh
# Needs Google Chrome, uv, and the network (fonts, and PyMuPDF the first time).
set -e
D=$(cd "$(dirname "$0")" && pwd)

"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --no-pdf-header-footer \
  --virtual-time-budget=15000 --print-to-pdf="$D/5-ways-chatgpt-id-firms.pdf" "file://$D/index.html"

uv run --quiet --with pymupdf python - "$D" <<'PY'
import sys
import fitz

d = sys.argv[1]
doc = fitz.open(f"{d}/5-ways-chatgpt-id-firms.pdf")
print(f"{doc.page_count} pages")
# The site shows the cover at about 150 px wide, so this is enough for sharp phone screens.
doc[0].get_pixmap(dpi=54).save(f"{d}/cover.png")
PY
