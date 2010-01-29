#!/usr/bin/perl

# Takes SMS text from gnokii and parses out commands to allow on/off
# control of 4 X10 devices and status reporting.

# U: upstairs
# D: downstairs
# K: kitchen (underfloor)
# C: central heating
#
# We are expecting the commands in the form X Y, where X is the zone 
# and Y is the command. This implies that there should always be an even
# number of elements in the SMS string, unless it is a '?' which queries
# the system status.
# So, let's first split out all the elements and count them...

@elements = @ARGV;

if (@elements % 2)	{
	# check if '?'
} else	{
	$NumberCommands = @elements/2;
	for($i=0;$i<@elements;$i+=2)	{
		# validate commands
		if (index("UDKC",uc @elements[$i]))	{
			if (index("ONOFF",uc @elements[$i+1]))	{
				$commands{uc @elements[$i]}=uc @elements[$i+1];
			}	else	{
				$InvalidCommand = 1;
			}
		}	else	{
			$InvalidSection = 1;
		}
	}
	if ($InvalidSection == 0 && $InvalidCommand == 0)	{
		# process commands
		for my $key ( keys %commands ) {
        		my $value = $commands{$key};
	        	print "$key => $value\n";
		}
		# generate SMS reply
	}
}

