#!/bin/zsh

IMG_SRC=$1
TARGET_SIZE=$2

TARGET_W=${TARGET_SIZE%x*}
TARGET_H=${TARGET_SIZE##*x}
TARGET_DIR=${IMG_SRC%\.*}


mkdir -p "${TARGET_DIR}" || true # ignore if dir exist

((w = $TARGET_W))
((h = $TARGET_H))
echo "Scaling for 1x"
echo "convert  "${IMG_SRC}" -resize ${w}x${h}\> \"${TARGET_DIR}/img.webp\""
convert  "${IMG_SRC}" -resize ${w}x${h}\> "${TARGET_DIR}/img.webp"

echo "Scaling for 2x"
((w = $TARGET_W * 2))
((h = $TARGET_H * 2))
echo "convert  "${IMG_SRC}" -resize ${w}x${h}\> \"${TARGET_DIR}/img@2.webp\""
convert  "${IMG_SRC}" -resize ${w}x${h}\> "${TARGET_DIR}/img@2.webp"

echo "Scaling for 3x"
((w = $TARGET_W * 3))
((h = $TARGET_H * 3))
echo "convert  "${IMG_SRC}" -resize ${w}x${h}\> \"${TARGET_DIR}/img@3.webp\""
convert  "${IMG_SRC}" -resize ${w}x${h}\> "${TARGET_DIR}/img@3.webp"

