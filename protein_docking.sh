#!/usr/bin/env bash

#USAGE: $ Docking.sh [processed_ligand_file] [dir_of_receptor_files] [mod_num]
#Docking.sh should be in the same folder with z-dock and z-rank assembly
#mod_num: number of models to be generated (from highest z-dock score to lowest)

ligand=$1
pdbs=$2

script_path=$(pwd)
touch z_score.txt
echo "organism,Z_Dock_Score">>z_score.txt

for file in $(ls ${pdbs});
do
    start_time=$(date)
    echo "processing ${file} at ${start_time}"
    organism=$(basename ${file} .pdb) 
    mkdir ${organism}
    mv ${pdbs}/${file} ${organism}
    mark_sur ${organism}/${organism}.pdb ${organism}/${organism}_m.pdb
    zdock -R ${organism}/${organism}_m.pdb -L ${ligand} -o ${organism}/${organism}.out
    #zdock -R ${receptor} -L ${organism}/${organism}_m.pdb -o ${organism}/${organism}.out
#Docking
    cat ${organism}/${organism}.out|sed -n '6p'>first_line.txt
    Z_score=$(awk '{print $NF}' first_line.txt)
    echo "${organism},${Z_score}">>z_score.txt
    rm first_line.txt
    end_time=$(date)
    echo "done processing ${file} at ${end_time}"
done

