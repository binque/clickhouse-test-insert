#!/bin/bash

CH_HOST="192.168.74.224"
FILE="ontime2000.txt"

cat $FILE | clickhouse-client -h$CH_HOST --query="INSERT INTO airline.ontime FORMAT CSV"

