#!/usr/bin/perl

# Takes SMS text from gnokii and parses out commands to allow on/off
# control of 4 X10 devices and status reporting.

# U: upstairs
# D: downstairs
# K: kitchen (underfloor)
# C: central heating
#
# Commands: [ON|OFF]
#
# We are expecting the commands in the form X Y, where X is the zone 
# and Y is the command. This implies that there should always be an even
# number of elements in the SMS string, unless it is a '?' which queries
# the system status.
# So, let's first split out all the elements and count them...

@elements = @ARGV;
$errormsg = "";
%devices = ( 	'U' => 'A1',
		'D' => 'A2',
		'K' => 'A3',
		'C' => 'A4'	);

if (@elements % 2)	{
	if (@elements[0] == '?')	{
		# do a status SMS
	} else	{
		$cmd = "echo \"Not a clue, mate...\" | gnokii --sendsms 0877996336";
		$result = system($cmd);
	}
} else	{
	for($i=0;$i<@elements;$i+=2)	{
		# validate commands
		if (index('UDKC',uc @elements[$i])!=-1)	{
			if (index('ONOFF',uc @elements[$i+1])!=-1)	{
				$commands{uc @elements[$i]}=uc @elements[$i+1];
			}	else	{
				$InvalidCommand = 1;
				$errormsg .= "'".@elements[$i+1]."'"." incorrect command\n";
			}
		}	else	{
			$InvalidSection = 1;
			$errormsg .= "'".@elements[$i]."'"." incorrect circuit\n";
		}
	}
	if ($InvalidSection == 0 && $InvalidCommand == 0)	{
		# process commands
		while (($circuit, $command) = each %commands ) {
        		$cmd = 'heyu '.$command.' '.$devices{$circuit};
			$result = system($cmd);
		}
		# generate SMS reply
	} else	{
		$cmd = "echo \"$errormsg\n" | gnokii --sendsms 0877996336";
		$result = system($cmd);
	}
}

