use strict;
use warnings;
use Dancer;
use Net::Telnet;

# Global params
set 'warning' 		=> 1;
set 'startup_info'  => 1;
set 'show_errors' 	=> 1;
set 'logger' 		=> 'console';
set 'log' 			=> 'debug';

sub get_conn {
	my $conn = new Net::Telnet;
	$conn->open(
		Host => "localhost",
		Port => 6600
	);
	return $conn;
}

sub send_command {
	my ($command) = @_;
	my $conn = get_conn;
	$conn->print($command);
	my $result = $conn->getline;
	$conn->close;
	return $result;
}

sub change_volume {
	my ($command) = @_;

	my $conn = get_conn;
	$conn->print('status');

	# first line is useless
	$conn->getline;

	# second contain current volume
	my $current_volume = $conn->getline;
	# empty the buffer
	$conn->buffer_empty;

	# Increment the volume
	$current_volume =~ s/volume:\s(\d+)/$1/;
	$current_volume += 3 if $command eq "+";
	$current_volume -= 3 if $command eq "-";

	# correct if $current_volume > 100 or < 0
	$current_volume = 0 if $current_volume < 0;
	$current_volume = 100 if $current_volume > 100;

	my $command = "setvol ".$current_volume;
	$conn->print($command);
	my $result = $conn->getline;
	return $result;
}

# play/pause/stop
get "/play"		=> sub { return send_command('play');	  };
get "/pause"	=> sub { return send_command('pause');	  };
get "/stop"		=> sub { return send_command('stop');	  };

# prev/next
get "/previous"	=> sub { return send_command('previous'); };
get "/next"		=> sub { return send_command('next');	  };

get "/volinc" 	=> sub { return change_volume('+'); };
get "/voldec" 	=> sub { return change_volume('-'); };

dance;
