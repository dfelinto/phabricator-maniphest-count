#!/bin/bash

# This script counts the result of different queries (json)
# in phabricator.
#
# Usage: $./manifest-query query.json [query2.json] 2>/dev/null
#
# Query example:
# {
#   "constraints": {
#     "projects": [
#       "bf_blender"
#     ]
#   }
# }
#
# It has the following hardcoded values:
# LIMIT=50000
# SERVER="https://developer.blender.org"
# CONDUIT_URL="/home/dfelinto/.conduit-dev.b.o"


if [ "$#" -lt 1 ]; then
	echo "Illegal number of parameters"
	echo "usage: ./manifest-query query.json [query2.json]"
	exit
fi

# Hardcoded values (XXX to parse them from command-line)
LIMIT=50000
SERVER="https://developer.blender.org"
CONDUIT_URL="/home/dfelinto/.conduit-dev.b.o"

# Page handling
# Phabricator has a hardcoded limit of 100 results per page
FULL_PAGES=`echo "$LIMIT / 100" | bc`
PAGES_LEFTOVER=`echo "$LIMIT % 100" | bc`
PARTIAL_PAGES=1
if [[ $PAGES_LEFTOVER -eq 0 ]]; then PARTIAL_PAGES=0; fi

# Util function and parameters
echoerr() { echo "$@" 1>&2; }
CONDUIT_TOKEN=`cat $CONDUIT_URL`

count=0
for query in "$@"; do
  echoerr "json: $query"
  after=""
  for i in $(seq 1 $(($FULL_PAGES + $PARTIAL_PAGES))); do
    LIMIT_PARTIAL=$PAGES_LEFTOVER
	if [[ $PARTIAL_PAGES -eq 0 ]]; then LIMIT_PARTIAL=100; fi
	if [[ i -le $FULL_PAGES ]]; then LIMIT_PARTIAL=100; fi

	CURSOR=`echo ". + {\"limit\": $LIMIT_PARTIAL, \"after\": $after }"`
	if [[ i -eq 1 ]]; then CURSOR=`echo ". + {\"limit\": $LIMIT_PARTIAL }"`; fi

    query_with_cursor=`cat $query | jq "$CURSOR"`;

    result=`echo $query_with_cursor | \
    arc call-conduit --conduit-uri $SERVER \
    --conduit-token \
    $CONDUIT_TOKEN \
    maniphest.search`

    after=`echo $result | jq '.response.cursor.after'`
    partial_count=`echo $result | jq '.response.data | length'`
    count=`echo "$count + $partial_count" | bc`

	echoerr "partial: $count"
	if [ "$after" == "null" ] ; then break; fi
  done
done

echo $count