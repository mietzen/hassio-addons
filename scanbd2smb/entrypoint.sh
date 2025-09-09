#!/usr/bin/env bash
set -e

# Read options.json into env vars
export SMB_SHARE=$(jq -r '.smb_share' /data/options.json)
export SMB_USER=$(jq -r '.smb_user' /data/options.json)
export SMB_PASSWORD=$(jq -r '.smb_password' /data/options.json)
export OCR_LANGUAGE=$(jq -r '.ocr_language' /data/options.json)
export SCAN_RESOLUTION=$(jq -r '.scan_resolution' /data/options.json)
export SCAN_MODE=$(jq -r '.scan_mode' /data/options.json)

if ! dpkg -l | grep -q "tesseract-ocr-${OCR_LANGUAGE}"; then
    echo "OCR Language: $OCR_LANGUAGE not installed! Installing:"
    apt-get update
    apt-get install --yes "tesseract-ocr-${OCR_LANGUAGE}"
fi

echo "ScanBD starting with:"
echo "  SMB_SHARE=$SMB_SHARE"
echo "  SMB_USER=$SMB_USER"
echo "  OCR_LANGUAGE=$OCR_LANGUAGE"
echo "  SCAN_RESOLUTION=$SCAN_RESOLUTION"
echo "  SCAN_MODE=$SCAN_MODE"

exec /usr/sbin/scanbd -f
