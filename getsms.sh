#!/bin/bash

# getsms - Part of the x10-sms toolset
# Takes SMS text from gnokii and parses out commands to allow on/off
# control of 4 X10 devices and status reporting.

# Copyright (C) 2010  Gerry Kavanagh

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
	
