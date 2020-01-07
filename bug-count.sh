#!/bin/bash

maniphest_count="$HOME/src/tools/dailies/maniphest-count.sh"
SAMPLES="$HOME/src/tools/dailies/samples"
DATA="$HOME/src/tools/dailies/data.csv"
DAILY_LOG="$HOME/src/tools/dailies/log-daily.txt"
CONVERT="$HOME/src/tools/dailies/convert-csv-json.py"
JSON="$HOME/src/tools/dailies/tracker-curfew.json"
REMOTE="download.blender.org:/data/www/vhosts/download.blender.org/institute/development/"

open_bugs="$SAMPLES/open-bugs.json"
tracker_curfew="$SAMPLES/tracker-curfew.json"
old_open_confirmed_bugs="$SAMPLES/old-open-confirmed-bugs.json"

# test sample
# count=$($maniphest_count $SAMPLES/test.json 2>>$DATA)

# old approach
# count=$($maniphest_count "$old_open_confirmed_bugs" 2>>$DATA)

# new approach
echo "Counting the bugs"
count=$($maniphest_count "$open_bugs" "$tracker_curfew" 2>>$DAILY_LOG)
echo $count";"`date "+%s"` 1>> $DATA 2>>$DAILY_LOG

# Update the json file
echo "Update the json file"
$CONVERT $DATA > $JSON

# Upload the file
echo "Uploading the new json file to: $REMOTE"
scp $JSON $REMOTE

# Backup the file
echo "Backing up the data"
cp $DATA /shared/users/dalai/backup/
cp $JSON /shared/users/dalai/backup/

echo "Done"
