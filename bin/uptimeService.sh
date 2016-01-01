#!/bin/bash

# Print a message to stderr and exit the script with an error
# 
exitWithError() {
    echo "$*; giving up" >&2
    exit 1
}

export UPTIME_HOME=/root/monitor/uptime
export NODE_PATH=$NODE_PATH:${UPTIME_HOME}/node_modules
CUR_PATH=`pwd`
cd ${UPTIME_HOME}
targetEnvironment="$1"

case "$targetEnvironment" in
    start)
	NODE_ENV=production node app > ${UPTIME_HOME}/bin/pid.log &
	echo "start uptime in process, please check status of process and id" 
        #exec forever --sourceDir=${UPTIME_HOME} -p ${UPTIME_HOME}/runtime app.js
        #sleep 30s
	#NODE_PID=`cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID |  awk '{print $3}'`
	#echo `cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID `
	;;

    stop)
        NODE_PID=`cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID |  awk '{print $3}'`
	echo "stop running uptime in process > ${NODE_PID}" 
	kill ${NODE_PID}
	rm -f "${UPTIME_HOME}/bin/pid.log"
        ;;
    status)
        if [[ -f "${UPTIME_HOME}/bin/pid.log" ]]; then
         NODE_PID=`cat ${UPTIME_HOME}/bin/pid.log | grep DEAMON_PROCESS_ID |  awk '{print $3}'`
         echo "uptime exits in process - ${NODE_PID}"
        else
	 echo "uptime process not started yet, please use #service uptime start"
	fi
        ;;
    *) 
        exitWithError "Unexpected target environment '$targetEnvironment' specified; run $0 -h for help"
        ;;
esac

cd ${CUR_PATH}
