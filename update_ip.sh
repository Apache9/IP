#!/bin/sh

OLD_IP=`cat ip`
IP=`ifconfig | grep "inet addr:" | grep -v ":192." | grep -v ":169." | grep -v ":127." | awk '{print $2}' | awk -F: '{print $2}'`
if [ -z $IP ]; then
  echo "can not get ip, quit"
  exit 1
fi
echo "old ip is $OLD_IP, new ip is $IP"
if [ "$OLD_IP" == "$IP" ]; then
  echo "ip does not change, quit"
  exit 1
fi
SHA=`curl -s -k github.pem -u Apache9:<token> https://api.github.com/repos/Apache9/IP/contents/R6300V2 | grep '"sha":' | awk '{print $2}' | awk -F\" '{print $2}'`
if [ ${#SHA} != 40 ]; then
  echo "can not get sha of the file, quit"
  exit 1
fi
BASE64_IP=`echo $IP | openssl enc -base64`
DATE=`LC_ALL=en_US.utf8 date`
sed "s/{date}/$DATE/g; s/{content}/$BASE64_IP/g; s/{sha}/$SHA/g;" template.json > request.json
SC=`curl -s -k github.pem -u Apache9:<token> -X PUT -H "Content-Type: application/json" -d '@request.json' -w "%{http_code}" "https://api.github.com/repos/Apache9/IP/contents/R630
echo $SC
LEN=`echo ${#SC}`
let START=LEN-3
SC=`echo ${SC:$START:3}`
if [ "$SC" != "200" ]; then
  echo "failed to update ip to github, quit"
  exit 1
fi
echo $IP > i
