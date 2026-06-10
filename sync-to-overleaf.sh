#!/usr/bin/env bash
# Copy package files from this repo into the Overleaf Dropbox sync folder.
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DST="${OVERLEAF_DST:-/home/tobi/Dropbox/Apps/Overleaf/acronyms_with_tooltip_test}"

if [[ ! -d "$DST" ]]; then
  echo "error: Overleaf project folder not found: $DST" >&2
  echo "Set OVERLEAF_DST to your synced Overleaf project path." >&2
  exit 1
fi

files=(
  acronymtooltips.sty
  acronymtooltips-pdfcomment.tex
  myacronyms.tex
  main.tex
  acronyms.tex
  pdfcomment-patched.tex
  integration-snippet.tex
)

for f in "${files[@]}"; do
  if [[ ! -f "$SRC/$f" ]]; then
    echo "error: missing $SRC/$f" >&2
    exit 1
  fi
  cp -v "$SRC/$f" "$DST/$f"
done

echo "Synced to $DST"
