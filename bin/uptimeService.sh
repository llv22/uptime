#!/bin/bash

# Print a message to stderr and exit the script with an error
# 
exitWithError() {
    echo "$*; giving up" >&2
    exit 1
}

export UPTIME_HOME=/root/monitor/uptime
CUR_PATH=`pwd`
cd ${UPTIME_HOME}
targetEnvironment="$1"

case "$targetEnvironment" in
    start)
	NODE_ENV=production node app > ${UPTIME_HOME}/bin/pid.log &
        NODE_PID=`cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID |  awk '{print $3}'`
	echo "start uptime in process > ${NODE_PID}" 
        ;;

    stop)
        NODE_PID=`cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID |  awk '{print $3}'`
	echo "stop running uptime in process > ${NODE_PID}" 
	kill ${NODE_PID}
        ;;
    status)
        if [[ -f "${UPTIME_HOME}/bin/pid.log" ]]; then
         NODE_PID=`cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID |  awk '{print $3}'`
         echo "uptime exits in process ${NODE_PID}"
        fi
        ;;
    *) 
        exitWithError "Unexpected target environment '$targetEnvironment' specified; run $0 -h for help"
        ;;
esac

cd ${CUR_PATH}
