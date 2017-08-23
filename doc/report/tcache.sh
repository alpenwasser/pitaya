#!/usr/bin/env bash

# Builds the TikZ cache until all images exist.
CORE_COUNT=$1
OUT_DIR=$2
DOCUMENT=$3

if [ -z $CORE_COUNT ] || [ -z $OUT_DIR ] || [ -z $DOCUMENT ];then
    exit 1
fi

# https://stackoverflow.com/a/27761760
while
    make -j"${CORE_COUNT}" -C "${OUT_DIR}" -f "${DOCUMENT}.makefile"
    ! [ $? -eq 0 ]
do
    make -j"${CORE_COUNT}" -C "${OUT_DIR}" -f "${DOCUMENT}.makefile"
done
exit 0
