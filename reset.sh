#!/bin/bash

./bin/rake db:nuke
./bin/rake db:mongoid:create_indexes
