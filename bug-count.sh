#!/bin/bash

# Bugs: Status: Confirmed, Subtype: Bug, WITHOUT #tracker_curfew


maniphest_count="/home/dfelinto/src/tools/dailies/maniphest-count.sh"
open_bugs="/home/dfelinto/src/tools/dailies/samples/open-bugs.json"
tracker_curfew="/home/dfelinto/src/tools/dailies/samples/tracker-curfew.json"


$maniphest_count $open_bugs $tracker_curfew 2>/dev/null