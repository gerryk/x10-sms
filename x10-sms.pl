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

#@elements = @ARGV;
$args =<STDIN>;
chop $args;
@elements = split(/ /,$args);
$errormsg = "";
%devices = ( 	'U' => 'A1',
		'D' => 'A2',
		'K' => 'A3',
		'T' => 'A4'	);
%circuits = (  	'U' => 'Upstairs',
		'D' => 'Downstairs',
		'K' => 'Kitchen',
		'T' => 'Tank' );
 

open(FILE, "./lastnumber");
my @lines =<FILE>;
$phonenum = @lines[0];
if (@elements % 2)	{
	if (@elements[0] eq '?')	{
		# do a status SMS
		print 'status';
	} else	{
		$elements = join (" ",@elements);
		$cmd = "echo \"'$elements' Not a valid command\" | gnokii --sendsms $phonenum";
		$result = system($cmd);
	}
} else	{
	for($i=0;$i<@elements;$i+=2)	{
		# validate commands
		if (index('UDKT',uc @elements[$i])!=-1)	{
			if (index('ON,OFF',uc @elements[$i+1])!=-1)	{
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
		$reply = "";
		while (($circuit, $command) = each %commands ) {
        		$cmd = 'heyu '.lc $command.' '.$devices{$circuit};
			$reply .= $circuits{$circuit}.' switched '.$command."\n";
			$result = system($cmd);
		}
		$cmd = "echo \"$reply\" | gnokii --sendsms $phonenum";
		$result = system($cmd);
	} else	{
		$cmd = "echo \"$errormsg\" | gnokii --sendsms $phonenum";
		$result = system($cmd);
	}
}

