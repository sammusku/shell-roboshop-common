#!/bin/bash
 USER_ID=$(id -u)

 LOGS_FOLDER="/var/log/shell-roboshop-common"
 LOGS_FILE="$LOGS_FOLDER/$0.log"
 R="\e[31m"
 G="\e[32m"
 Y="\e[33m"
 N="\e[0m"
START_TIME=$(date +%s)
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.dev88s.online"

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
       echo -e "$(date "+%y-%m-%d %H:%M:%S") | $Y $2 $N----- $R failure $N" | tee -a $LOGS_FILE
       exit 1
    else
       echo -e "$(date "+%y-%m-%d %H:%M:%S") | $Y $2 $N------$G success $N" | tee -a $LOGS_FILE
    fi
}
app_setup(){
id roboshop &>>$LOGS_FILE
if [ $? -ne 0 ]; then
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
   VALIDATE $? "Creating system user"
   echo " $G Created the roboshop user $N "
else
   echo -e " roboshop user already exist in the system..$Y skipping $N "
fi

mkdir -p /app
VALIDATE $? "creating app directory"


curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOGS_FILE
VALIDATE $? "Downloading $app_name data"

cd /app
VALIDATE $? "moving to app directory"

rm -rf /app/*
VALIDATE $? "removing already existed data from app"

unzip /tmp/$app_name.zip &>>$LOGS_FILE
VALIDATE $? "unzip $app_name data from temp directory to app directory"

}

nodejs_setup(){
    dnf module list nodejs -y &>>$LOGS_FILE
    VALIDATE $? "List of avaialble nodejs versions"

    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disable nodejs default  version"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "enable nodejs:20 version"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "installing Nodejs 20"
    npm install  &>>$LOGS_FILE
    VALIDATE $? "installing the nodejs dependencies"
}
systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOGS_FILE
    VALIDATE $? "copying the system services"

    systemctl daemon-reload
    VALIDATE $? "reloading the changes"

    systemctl enable $app_name &>>$LOGS_FILE
    VALIDATE $? "enable $app_name"

    systemctl start $app_name &>>$LOGS_FILE
    VALIDATE $? "start $app_name server"
}

app_restart(){
    systemctl restart catalogue &>>$LOGS_FILE
    VALIDATE $? "restarting the catalogue"
}
print_total_time(){
     END_TIME=$(date +%s)
     TOTAL_TIME=$(( $END_TIME - $START_TIME ))
     echo -e "$(date "+%y-%m-%d %H:%M:%S") | script executed in :$G $TOTAL_TIME in seconds $N" | tee -a $LOGS_FILE
}

