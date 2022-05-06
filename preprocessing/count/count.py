import argparse
from collections import Counter
import csv
import json

from tqdm import tqdm

NBR_COLUMN = 13
INVALID_LENGTH_TOKEN = "<INVALID_LENGTH>"

parser = argparse.ArgumentParser()
parser.add_argument("--data", help="The path of the file to be read", required=True)
parser.add_argument("--export", help="The path of the file where the results will be exported", required=True)

args = parser.parse_args()

data_file_path = args.data
export_file_path = args.export

print("data_file_path :", data_file_path)
print("export_file_path :", export_file_path)

label_counter = Counter([])
print("Reading data...")
with open(data_file_path, "r") as data_file:
    reader = csv.reader(data_file)
    for row in tqdm(reader):
        if len(row) == NBR_COLUMN:
            target = row[-1]
            label_counter.update([target])
        else:
            label_counter.update([INVALID_LENGTH_TOKEN])

print("Exporting result...")
with open(export_file_path, "w") as export_file:
    result = json.dumps(label_counter)
    export_file.write(result)

print("DONE.")