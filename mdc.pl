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

sub send_command {
	my ($command) = @_;
	my $conn = new Net::Telnet;
	$conn->open(
		Host => "localhost",
		Port => 6600
	);
	$conn->print($command);
	my $result = $conn->getline;
	$conn->close;
	return $result;
}

# play/pause/stop
get "/play"		=> sub { return send_command('play');	  };
get "/pause"	=> sub { return send_command('pause');	  };
get "/stop"		=> sub { return send_command('stop');	  };

# prev/next
get "/previous"	=> sub { return send_command('previous'); };
get "/next"		=> sub { return send_command('next');	  };

dance;
