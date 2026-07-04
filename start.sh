#!/bin/bash
source /app/config.sh

service ssh start
service nginx start

ngrok authtoken "$NGROK_TOKEN"
echo "start ngrok service"
ngrok tcp 22 --log=stdout > ngrok.log
