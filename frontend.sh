#!/bin/bash
source ./common.sh

check_root
app_name=frontend
app_setup

dnf module disable nginx -y 
dnf module enable nginx:1.24 -y &>>$LOGS_FILE
dnf install nginx -y  &>>$LOGS_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "enable and start nginx"

rm -rf /usr/share/nginx/html/* 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "remove data and download"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzip frontend data"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf  &>>$LOGS_FILE
VALIDATE $? "copying nginx configure data"

systemctl restart nginx  &>>$LOGS_FILE
VALIDATE $? "restarting nginx"

print_total_time
