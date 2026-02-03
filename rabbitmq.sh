#!/bin/bash

source ./common.sh

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE $? "copying rabbitmq repo"

dnf install rabbitmq-server -y &>>$LOGS_FILE
VALIDATE $? "installing rabbitmq"

systemctl enable rabbitmq-server
systemctl start  rabbitmq-server
VALIDATE $? "enable and start rabbitmq-server"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "user created and permissions given"

print_total_time
