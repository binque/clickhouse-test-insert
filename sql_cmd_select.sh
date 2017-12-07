#!/bin/bash

CH_HOST="192.168.74.224"

clickhouse-client -h$CH_HOST --query="SELECT COUNT() FROM airline.ontime"

