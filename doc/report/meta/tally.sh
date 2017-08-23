#!/usr/bin/env sh

DOCUMENT="$1"
META_DIR="$2"

cat "${META_DIR}/${DOCUMENT}".ctr.* |\
    grep -P '^[0-9]*$' |\
    tr '\n' ' ' |\
    sed 's/\s$/\n'/ |\
    sed 's/\s/+/g' |\
    bc > "${META_DIR}/${DOCUMENT}.global.ctr"

find "${META_DIR}" -name "${DOCUMENT}"'.ctr.*' |\
    wc -l >> "${META_DIR}/${DOCUMENT}.global.ctr"
