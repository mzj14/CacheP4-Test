#! /bin/bash

cd $1

p4c-bmv2 simple_nat.p4 --json config.json
