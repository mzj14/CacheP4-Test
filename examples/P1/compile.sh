#! /bin/bash

cd $1

p4c-bmv2 simple_router.p4 --json config.json
