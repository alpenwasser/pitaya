#!/bin/sh
gource                      \
    -1920x1080              \
    -r 60                   \
    --time-scale 4          \
    --title "IK" \
    --key                   \
    -o - |                  \
ffmpeg                      \
    -y                      \
    -r 60                   \
    -f image2pipe           \
    -c:v ppm                \
    -i -                    \
    -c:v libx264            \
    -preset medium          \
    -pix_fmt yuv420p        \
    -crf 1                  \
    -threads 0              \
    -bf 0                   \
    output.mkv
