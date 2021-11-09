#usr/env/bash

input_dir=$1
loc=$2
output_dir=$3

#"loc" is a text file with each loci on a row

for file in $(ls ${input_dir}*.fa)
do
    acc=$(basename ${file} .fa)
    touch ${output_dir}${acc}_extract_rbd.fa
    #cat ${file}|seqkit subseq -r 1:1>>${output_dir}${acc}_extract_rbd.fa
    seq=$(cat ${file}|seqkit subseq -r 1:1)
    for i in $(cat ${loc})
    do
        nuc=$(cat ${file}|seqkit subseq -r ${i}:${i}|tail -n 1)
        seq=${seq}${nuc}
    done
    echo ${seq}>>${output_dir}${acc}_extract_rbd.fa
    sed -i 's/ /\n/g ' ${output_dir}${acc}_extract_rbd.fa
done
