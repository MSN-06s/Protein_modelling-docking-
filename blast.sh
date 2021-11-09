#!/usr/bin/env bash

#parse args
#input_dir=$1
template_file=$1
template=$(cat ${template_file})
mkdir sawed
for file in $(ls *.ali);
do
    sample=$(basename ${file} .ali)
    touch sawed/${sample}_1.txt
    tail -n +3 ${file}>>sawed/${sample}_1.txt
    sed -i ':a;N;$!ba;s/\n//g' sawed/${sample}_1.txt #remove \r in the target file
    sed -i 's/*//g' sawed/${sample}_1.txt
    seq=$(cat sawed/${sample}_1.txt)
    python extract_alignment.py ${template} ${seq}>sawed/${sample}_blast.txt
    sort -n -k 2 -r -t $'\t' sawed/${sample}_blast.txt>sawed/${sample}_blast_1.txt
    touch sawed/${sample}.ali
    head -n 2 ${file}>>sawed/${sample}.ali
    seq_fin=$(cat sawed/${sample}_blast_1.txt|awk '{print $1}' |head -n 1)
    seq_fin=''$seq_fin'*'
    echo ${seq_fin}>>sawed/${sample}.ali
done
