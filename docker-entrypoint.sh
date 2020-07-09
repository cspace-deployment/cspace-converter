#!/bin/bash

BUILD_VERSION=`git symbolic-ref -q --short HEAD || git describe --tags --match v*`
BUILD_VERSION=${BUILD_VERSION#"heads/"}
PROCESSES=${PROCESSES:-`grep -c ^processor /proc/cpuinfo`}
echo "export BUILD_VERSION=$BUILD_VERSION" >> /set_env
source /set_env
./bin/rails runner 'Delayed::Backend::Mongoid::Job.create_indexes'
./bin/delayed_job start -n $PROCESSES
./bin/rake assets:precompile
exec "$@"
