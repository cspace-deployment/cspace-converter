#!/bin/bash

export CS_CONV_BATCH=${1:-ppsobjects1}
export CS_CONV_TYPE=${2:-PastPerfect}
export CS_CONV_PROFILE=${3:-ppsobjectsdata}

bundle exec rake \
  db:import:data[$CS_CONV_BATCH,$CS_CONV_TYPE,$CS_CONV_PROFILE,db/data/${CS_CONV_PROFILE}.csv]