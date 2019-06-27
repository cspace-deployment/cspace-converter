#!/bin/bash

export FILE=${1:-ppsobjectsdata.csv}
export BATCH=${2:-ppsobjects1}
export MODULE=${3:-PastPerfect}
export PROFILE=${4:-ppsobjectsdata}

./bin/rake \
  import:procedures[${FILE},$BATCH,$MODULE,$PROFILE]
