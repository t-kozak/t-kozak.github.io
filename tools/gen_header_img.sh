#!/bin/zsh

IMG_SRC=$1
TARGET_DIR=$2

IMG_DIR=$(dirname "$IMG_SRC")
MOBILE_TMP_IMG="/tmp/mobile_header_tmp.webp"
DESKTOP_TMP_IMG="/tmp/header_tmp.webp"

mkdir -p "${TARGET_DIR}" || true # ignore if dir exist

echo "Cropping for known AR on desktop"
convert "${IMG_SRC}" -gravity center -crop 2:1 -quality 99 -define webp:lossless=true "${DESKTOP_TMP_IMG}"
echo "Scaling for desktop 1x"
convert  "${DESKTOP_TMP_IMG}" -resize 1080x540\> "${TARGET_DIR}/desktop.webp"
echo "Scaling for desktop 2x"
convert  "${DESKTOP_TMP_IMG}" -resize 2000x1000\> "${TARGET_DIR}/desktop@2.webp"

# Mobile stuffs
echo "Cropping for known AR on mobile"
convert "${IMG_SRC}" -gravity center -crop 1:1 -quality 99 -define webp:lossless=true "${MOBILE_TMP_IMG}"
echo "Scaling for mobile 3x"
convert "${MOBILE_TMP_IMG}" -gravity center -resize 1024x1024\>  "${TARGET_DIR}/mobile@3.webp"
echo "Scaling for mobile 2x"
convert "${MOBILE_TMP_IMG}" -gravity center -resize 820x820\>  "${TARGET_DIR}/mobile@2.webp"
echo "Scaling for mobile 1x"
convert "${MOBILE_TMP_IMG}" -gravity center -resize 410x410\>  "${TARGET_DIR}/mobile.webp"


