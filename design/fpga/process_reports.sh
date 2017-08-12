#!/usr/bin/env bash

coe_dir="../filter/coefData/decFIR"
tmp_file='usageReport.tmp'
summary_file='usageReport.csv'


for file in reports/*.rpt;do
    dsp_count=$(grep 'DSPs' "$file" | awk '{print $4}')
    coe_file="${file/reports\/decFIR--/}"
    coe_file="$coe_dir/${coe_file/rpt/coe}"
    if [ -f "$coe_file" ];then
        line_count=$(wc -l "$coe_file" | awk '{print $1}')
        coef_count=$(( line_count-2 ))
        echo "${coef_count},${dsp_count}" >> "$tmp_file"
        #rm "$coe_file"
    fi
done
echo 'filterSize,DSPCount' > "$summary_file"
cat "$tmp_file" | sort -n | uniq >> "$summary_file"
rm "$tmp_file"
