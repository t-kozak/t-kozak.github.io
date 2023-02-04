#!/bin/zsh

IMG_SRC=$1
TARGET_DIR=$2



mkdir -p "${TARGET_DIR}" || true # ignore if dir exist

ANDR_SIZES="36 48 72 96 144 192"
APPLE_SIZES="57 60 72 76 114 120 144 152 180"
FAVICON_SIZES="16 32 96"
MS_SIZES="70 144 150 310"

ANDR_PFX="android-icon"
APPL_PFX="apple-icon"


for size in 36 48 72 96 144 192 ; do
	convert "${IMG_SRC}" -resize "${size}x${size}" "${TARGET_DIR}/android-icon-${size}x$size.png"
done

for size in 57 60 72 76 114 120 144 152 180 ; do
	convert "${IMG_SRC}" -resize "${size}x${size}" "${TARGET_DIR}/apple-icon-${size}x$size.png"
done

for size in 70 144 150 310 ; do
	convert "${IMG_SRC}" -resize "${size}x${size}" "${TARGET_DIR}/ms-icon-${size}x$size.png"
done

size=192
convert "${IMG_SRC}" -resize "${size}x${size}" "${TARGET_DIR}/apple-icon-precomposed.png"
cp "${TARGET_DIR}/apple-icon-precomposed.png" "${TARGET_DIR}/apple-icon.png"

for size in 16 32 96 ; do
	convert "${IMG_SRC}" -resize "${size}x${size}" "${TARGET_DIR}/favicon-${size}x$size.png"
done

size=16
convert "${IMG_SRC}" -resize "${size}x${size}" "${TARGET_DIR}/favicon.ico"