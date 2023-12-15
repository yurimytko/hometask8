#!/bin/bash

aws ec2 run-instances --image-id ami-053b0d53c279acc90 --count 1 --instance-type t2.micro --key-name key-first --security-group-ids sg-09129fe1c7ff5fc1b --user-data file://lab_8.sh
