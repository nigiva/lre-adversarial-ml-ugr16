import argparse
from collections import Counter
import csv
import json

from tqdm import tqdm

# CONSTANTES
NBR_COLUMN = 13

# FILE ARGS
parser = argparse.ArgumentParser()
parser.add_argument("--data", help="The path of the file to be read", required=True)
parser.add_argument("--index", help="The path of the random index file", required=True)
parser.add_argument("--dataset_name", help="The dataset name such as `calibration-june.week4`", required=True)
parser.add_argument("--export", help="The path of the file where the results will be exported", required=True)
args = parser.parse_args()

data_file_path = args.data
index_file_path = args.index
dataset_name = args.dataset_name
export_file_path = args.export

print("data_file_path :", data_file_path)
print("index_file_path :", index_file_path)
print("dataset_name :", dataset_name)
print("export_file_path :", export_file_path)

# FILE TO OPEN
data_file = open(data_file_path, "r")
export_file = open(export_file_path, "w")

print("Reading index file...")
with open(index_file_path, "r") as index_file:
    # Dictionnaire pour chaque dataset contenant un dictionnaire 
    # pour chaque label la liste des index
    index_dict = json.loads(index_file.read())

label_index_dict = index_dict[dataset_name]

# Counter
label_counter = Counter([])

# CSV reader & writer
reader = csv.reader(data_file)
writer = csv.writer(export_file)

print("Extracting data...")
for row in tqdm(reader):
    if len(row) == NBR_COLUMN:
        target = row[-1]
        target_index = label_counter.get(target, 0)
        # increment counter
        label_counter.update([target])
        if target_index in label_index_dict.get(target, []):
            writer.writerow(row)

data_file.close()
export_file.close()
print("DONE.")