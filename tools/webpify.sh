#!/bin/zsh

for f in * ; do
    dst="${f%%.*}".webp
    convert "$f" "$dst"
done