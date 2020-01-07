#!/bin/python3

import csv
import json
import sys
import os
from datetime import datetime


def main(filename):
    bugs = []
    steps = []
    with open(filename) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=';')
        for bug,step in csv_reader:
            bugs.append(bug)
            timestamp = int(step)
            humandate = datetime.fromtimestamp(timestamp)
            steps.append(str(humandate))

    data = {}
    data['bugs'] = bugs
    data['step'] = steps
    print(json.dumps(data))


def parse_args():
    if len(sys.argv) != 2:
        print("Expect ./data-converter.py data.csv")
        sys.exit(1)

    filename = sys.argv[1]
    if not (os.path.exists(filename) and os.path.isfile(filename)):
        print ("File: \"{filename}\" is not a valid file".format(filename=filename))
        sys.exit(2)

    return filename


if __name__ == "__main__":
    filename = parse_args()
    main(filename)

