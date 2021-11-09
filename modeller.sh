#!/usr/bin/env bash

#parse args
input_dir=$1
#param=$2

touch modelling_total.log
touch align_score_total.txt
echo "Acc.,Species,Alignment Score">>align_score_total.txt
mkdir 1st_mod
for file in $(ls *.ali);
do
    start_time=$(date)
    echo "Modelling ${file} at ${start_time}"
    #Formatting the PIR
    sed -i 's/XX/P1/' ${file}
    infor=$(cat ${file}|sed -n 2p) 
    species=$(echo ${infor}|grep -o  '\[.*\]')
    species=$(echo ${species}|sed -e 's/ /_/g')
    acc=$(echo ${infor}|awk -F ' -' '{print $1}')
    #new_line2='"sequence"":"'$acc'":"'$species'":::::::"'
    new_line2='sequence:'$acc':'$species':::::::'
    sed -i '2d' ${file}
    sed -i '2 i '$new_line2'' ${file}
    #Scripts modfication
    mkdir ${acc}
    cp align2.py ${acc}/align_rm.py
    cp model_single.py ${acc}/align_modelling.py
    mv ${file} ${acc}/
    cp 6acg.pdb ${acc}/
    #cp ${mepy} ${acc}/align_mod_eval.py
    cd ${acc}
    sed -i 's/TvLDH/'$acc'/g' align_rm.py
    sed -i 's/TvLDH/'$acc'/g' align_modelling.py
    #sed 's/TvLDH/'$acc'' align_mod_eval.py
    mod10.1 align_rm.py
    align_score=$(tail -n -2 align_rm.log|head -n -1)
    echo "'$acc','$species','$align_score'">>../align_score_total.txt
    mod10.1 align_modelling.py
    #mod10.1 align_mod_eval.py
    SUM1=$(tail -n -7 align_modelling.log|head -n -5)
    #SUM=$(head -n 5 ${SUM1})
    echo "'$acc','$species'">>../modelling_total.log
    echo "'$SUM1'">>../modelling_total.log
    #1st=$(echo ${SUM1}|awk -F ' ' '{print $1}')
    cp ${acc}.B99990001.pdb ../1st_mod
    cd ${input_dir}
    end_time=$(date)
    echo "done modelling ${file} at ${end_time}"   
done
