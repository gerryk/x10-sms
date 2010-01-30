DATE=`date`
gnokii --getsms SM 0 -d >sms
cat sms | awk 'NR==3 {print $2;exit}' >lastnumber
MESSAGE=`cat sms | tail -1` 
SMSSIZE=`stat -c %s sms` 
if [ "$SMSSIZE" -gt 0 ] ; then
	echo $DATE Message received: $MESSAGE >>/home/gerryk/x10-sms/x10-sms.log
	cat sms | tail -1 | /home/gerryk/x10-sms/x10-sms.pl
else
	echo $DATE No messages received >>/home/gerryk/x10-sms/x10-sms.log
fi
	
