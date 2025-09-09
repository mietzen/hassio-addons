#!/bin/bash
set -euo pipefail

TMP_DIR=$(mktemp -d)
FILE_NAME="scan_$(date +%Y-%m-%d-%H%M%S)"

echo 'Scanning...'
scanimage --resolution "$SCAN_RESOLUTION" \
          --batch="$TMP_DIR/scan_%03d.pnm" \
          --format=pnm \
          --mode "$SCAN_MODE" \
          --source "ADF Front"

echo "Output saved in $TMP_DIR/scan*.pnm"
cd "$TMP_DIR"

# Convert to TIFF
for i in scan_*.pnm; do
    echo "Converting $i"
    convert "$i" "$i.tif"
done

# OCR
echo 'Performing OCR...'
for i in scan_*.tif; do
    echo "Processing $i"
    tesseract "$i" "$i" -l "$OCR_LANGUAGE" hocr
    hocr2pdf -i "$i" -s -o "$i.pdf" < "$i.hocr"
done

# Merge PDFs
echo 'Merging PDFs...'
pdftk *.tif.pdf cat output compiled.pdf

# Compress final PDF
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
   -dNOPAUSE -dQUIET -dBATCH \
   -sOutputFile="$FILE_NAME.pdf" compiled.pdf

# Upload via Samba
smbclient "$SMB_SHARE" -U "$SMB_USER"%"$SMB_PASSWORD" -c "put $FILE_NAME.pdf"

# Cleanup
rm -rf "$TMP_DIR"
