#! /bin/bash

cd $1

p4c-bmv2 feature_chain.p4 --json config.json
