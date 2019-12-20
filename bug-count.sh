#!/bin/bash

maniphest_count="$HOME/src/phabricator-maniphest-count/maniphest-count.sh"
SAMPLES="$HOME/src/phabricator-maniphest-count/samples"

open_bugs="$SAMPLES/open-bugs.json"
tracker_curfew="$SAMPLES/tracker-curfew.json"
old_open_confirmed_bugs="$SAMPLES/old-open-confirmed-bugs.json"

# old approach
#$maniphest_count "$old_open_confirmed_bugs" 2>/dev/null
$maniphest_count "$SAMPLES/test.json"

# new approach
#$maniphest_count "$open_bugs" "$tracker_curfew" 2>/dev/null
