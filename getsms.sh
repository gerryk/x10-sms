DATE=`date`
gnokii --getsms SM 0 >sms
cat sms | awk 'NR==3 {print $2;exit}' >lastnumber
MESSAGE=`cat sms | tail -1` 
echo $DATE Message received: $MESSAGE >>/home/gerryk/x10-sms/x10-sms.log
cat sms | tail -1 | x10-sms.pl
