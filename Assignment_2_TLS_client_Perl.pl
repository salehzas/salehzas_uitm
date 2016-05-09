use strict;
use warnings;
use AnyEvent::Socket;
use AnyEvent::Handle;
use Protocol::TLS::Client;
 
 
my $client = Protocol::TLS::Client->new( version => 'TLSv12', @ARGV );
 
my $cv = AE::cv;
 
tcp_connect '127.0.0.1', 8888, sub {
    my $fh = shift or do {
        warn "error: $!\n";
        $cv->send;
        return;
    };
    my $h;
    $h = AnyEvent::Handle->new(
        fh       => $fh,
        on_error => sub {
            $_[0]->destroy;
            warn "connection error\n";
            $cv->send;
        },
        on_eof => sub {
            $h->destroy;
            print "Closed connection\n";
            $cv->send;
        },
    );
 
    my $con = $client->new_connection(
        '127.0.0.1',
       on_handshake_finish => sub {
            my ($tls) = @_;
	    print "This test is to establish TLS between Server and client. Please input any word :\n";
            my$uinput = <STDIN>;
            $tls->send($uinput);
        },
        on_data => sub {
           my ( $tls, $data ) = @_;
            print "Connection accepted\n" if $data =~ /win/;
	    print "$data";
            $tls->close;
        }
    );
 
    while ( my $record = $con->next_record ) {
        $h->push_write($record);
    }
 
    $h->on_read(
        sub {
            my $handle = shift;
            $con->feed( $handle->{rbuf} );
            $handle->{rbuf} = '';
            while ( my $record = $con->next_record ) {
                $handle->push_write($record);
            }
 
            $handle->push_shutdown if $con->shutdown;
            ();
        }
    );
    ();
};
 
$cv->recv;
