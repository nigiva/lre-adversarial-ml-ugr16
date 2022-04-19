#!/bin/bash
#
# Extract label from test dataset
#
#$ -S /bin/bash
#$ -N MLSECU_extract_test
#$ -wd ~/
#$ -j y
#$ -pe mpi 8
#$ -o /media/silver/corentin/mlsecu/std
#$ -t 1-6
echo "Task id : $SGE_TASK_ID"
declare -i id=$SGE_TASK_ID-1
echo "Id : $id"

month_list=(
	july
	august
	august
	august
	august
	august
)

week_list=(
	week5
	week1
	week2
	week3
	week4
	week5
)
# download/attack/july/week5/july_week5_csv.tar.gz
base_link_list="https://nesg.ugr.es/nesg-ugr16/download/attack"

# Creer le dossier temporaire
mkdir /tmp/mlsecu

week=${week_list[$id]}
month=${month_list[$id]}
url="$base_link_list/$month/$week/$month"_"$week"_"csv.tar.gz"

wget -O /tmp/mlsecu/mlsecu_data.tar.gz $url
pv /tmp/mlsecu/mlsecu_data.tar.gz | tar xz -C /tmp/mlsecu

# Cas particulier
# Après décompression, le august.week1 ne setrouve pas dans un dossier "uniq"
if [ $month = "august" ] && [ $week = "week1" ]
then
	data_path="/tmp/mlsecu/$month.$week.csv"
else
	data_path="/tmp/mlsecu/uniq/$month.$week.csv.uniqblacklistremoved"
fi

dataset_name="test-$month.$week"
tmp_export_path="~/test-$month.$week.json"
export_dir_path="/media/silver/corentin/mlsecu/extract/"
index_path="/media/gold/corentin/mlsecu/dataset_label_index.json"

/media/gold/corentin/mlsecu/venv/bin/python /media/gold/corentin/mlsecu/extract.py --data $data_path --index $index_path --dataset_name $dataset_name --export $tmp_export_path

mv $tmp_export_path $export_dir_path
rm -rf /tmp/mlsecu