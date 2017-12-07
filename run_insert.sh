#!/bin/bash

CMD="./sql_cmd_insert.sh"
LOGFILE="log_insert.log"
RUNS_PER_SEC=10
SECONDS_TO_RUN=1000000

START_TIMESTAMP=$(date +"%s")
ONE_RUN_DURATION_LIMIT=$(bc <<< "scale=5; 1/$RUNS_PER_SEC")
echo "ONE_RUN_DIRATION_LIMIT=$ONE_RUN_DURATION_LIMIT"

while :; do
	EXEC_TIME=$(TIME="%e" time --quiet $CMD 2>&1)
	EXIT_CODE=$?
	NOW=$(date +"%s")

	STR="$NOW	$EXIT_CODE	$EXEC_TIME"
	echo -n $STR
	echo $STR>>$LOGFILE
	
	re='^[0-9]+\.[0-9][0-9]+$'
	if [[ $EXEC_TIME =~ $re ]]; then
		if [ $(bc <<< "$EXEC_TIME < $ONE_RUN_DURATION_LIMIT") -eq 1 ]; then
			TIME_TO_SLEEP=$(bc <<< "scale=5; $ONE_RUN_DURATION_LIMIT - $EXEC_TIME")
			echo -n " SLEEP $TIME_TO_SLEEP"
			sleep $TIME_TO_SLEEP
		fi
	fi
	
	echo 

	if [ $(bc <<< "$NOW >= ($START_TIMESTAMP + $SECONDS_TO_RUN)") -eq 1 ]; then
		echo "time to quit"
		exit 0
	fi

done

