#!/bin/bash
 USER_ID=$(id -u)

 LOGS_FOLDER="/var/log/shell-roboshop-common"
 LOGS_FILE="$LOGS_FOLDER/$0.log"
 R="\e[31m"
 G="\e[32m"
 Y="\e[33m"
 N="\e[0m"
START_TIME=$(date +%s)

mkdir -p $LOGS_FOLDER

 echo "$(date "+%y-%m-%d %H:%M:%S") | script started executing at:$(date)" | tee -a $LOGS_FILE


check_root(){
        if [ $USER_ID -ne 0 ]; then
        echo -e "$R please use root user to run the script $N" | tee -a $LOGS_FILE
        exit 1
        fi
        }

VALIDATE() {
      if [ $1 -ne 0 ]; then
       echo -e $(date "+%y-%m-%d %H:%M:%S") | "$Y $2 $N----- $R failure $N" | tee -a $LOGS_FILE
       exit 1
    else
       echo -e $(date "+%y-%m-%d %H:%M:%S") | "$Y $2 $N------$G success $N" | tee -a $LOGS_FILE
    fi
}

print_total_time(){
     END_TIME=$(date +%s)
     TOTAL_TIME=$(( $END_TIME - $START_TIME ))
     echo -e $(date "+%y-%m-%d %H:%M:%S") | script executed in :$G $TOTAL_TIME in seconds $N | tee -a $LOGS_FILE
}

