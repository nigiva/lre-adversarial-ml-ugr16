#!/bin/bash
#
# Count all label in calibration dataset
#
#$ -S /bin/bash
#$ -N MLSECU_count_calibration
#$ -wd ~/
#$ -j y
#$ -pe mpi 8
#$ -o /media/silver/corentin/mlsecu/std
#$ -t 1-17
SGE_TASK_ID=1
echo "Task id : $SGE_TASK_ID"
declare -i id=$SGE_TASK_ID-1
echo "Id : $id"

month_list=(
	march
	march
	march
	april
	april
	april
	april
	may
	may
	may
	may
	may
	may
	june
	june
	june
	june
)

week_list=(
	week3
	week4
	week5
	week2
	week3
	week4
	week5
	week1
	week2
	week3
	week4
	week5
	week6
	week1
	week2
	week3
	week4
)

base_link_list="https://nesg.ugr.es/nesg-ugr16/download/normal"

# Creer le dossier temporaire
mkdir /tmp/mlsecu

week=${week_list[$id]}
month=${month_list[$id]}
url="$base_link_list/$month/$week/$month"_"$week"_"csv.tar.gz"

wget -O /tmp/mlsecu/mlsecu_data.tar.gz $url
pv /tmp/mlsecu/mlsecu_data.tar.gz | tar xz -C /tmp/mlsecu

data_path="/tmp/mlsecu/uniq/$month.$week.csv.uniqblacklistremoved"
export_path="/media/silver/corentin/mlsecu/count/calibration-$month.$week.json"

/media/gold/corentin/mlsecu/venv/bin/python /media/gold/corentin/mlsecu/count.py --data $data_path --export $export_path

rm -rf /tmp/mlsecu