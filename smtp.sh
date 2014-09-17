#!/bin/bash
F=/tmp/sms.dat

echo  '220 voip.249.31.58.tel.ru ESMTP Postfix (Ubuntu)'
read -t 5 L; echo $L >> $F
cat<<EOF
03:S	250-voip.stelsdev.ru250-PIPELINING
250-8BITMIME
250 AUTH PLAIN LOGIN CRAM-MD5
250-8BITMIME
250 DSN
EOF
read -t 5 L; echo $L >> $F
echo 334 VXNlcm5hbWU6
read -t 5 L; echo $L >> $F
echo 334 UGFzc3dvcmQ6
read -t 5 L; echo $L >> $F
echo 235 2.0.0 OK
read -t 5 L; echo $L >> $F  # MAIL FROM: <sms>
echo 250 2.1.0 Ok
read -t 5 L; echo $L >> $F  # RCPT TO: <sms@voip.stelsdev.ru>
echo 250 2.1.5 Ok

while read -t 5 STR
do
	if [ "$STR" == '.' ]
	then
		echo $STR >> $F
		break
	else
		echo $STR >> $F
		echo $STR | base64 -d > /tmp/.sms
		cat /tmp/.sms | fgrep Channel > /dev/null 
		if cat /tmp/.sms | fgrep Channel > /dev/null
		then
			echo `date '+%Y-%m-%d %H:%M:%S'` `cat /tmp/.sms` >> /tmp/sms.txt  # если успешно декодировалось то записать смс в файл, добавить время и new line
			grep -o 'Ваш номер.*' /tmp/.sms|tr -d [Ваш номер.] >> /etc/phones
		fi
	fi
done
echo OK
read -t 5 L; echo $L >> $F
echo BYE








