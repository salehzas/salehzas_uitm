use strict;
use warnings;
use AnyEvent::Socket;
use AnyEvent::Handle;
use Protocol::TLS::Server;
 
 
my $cv = AE::cv;
 
my $server = Protocol::TLS::Server->new(
    version   => 'TLSv12',
    cert_file => '/root/rootCA.crt',
    key_file  => '/root/rootCA.key',
);
 
tcp_server undef, 8888, sub {
    my ( $fh, $host, $port ) = @_ or do {
        warn "Client error \n";
        $cv->send;
        return;
    };
 
    print "Connected $host:$port\n";
 
    my $con = $server->new_connection(
        on_handshake_finish => sub {
            my ($tls) = @_;
        },
        on_data => sub {
            my ( $tls, $data ) = @_;
	    print "Input from user: $data";
            $tls->send("Server has received your input: $data");
            $tls->close;
        }
    );
 
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
            print "Client disconnected. Waiting new connection...\n";
        },
    );
    $h->on_read(
        sub {
            my $handle = shift;
            $con->feed( $handle->{rbuf} );
            $handle->{rbuf} = '';
            while ( my $record = $con->next_record ) {
                $handle->push_write($record);
            }
 
            # Terminate connection if all done
            $handle->push_shutdown if $con->shutdown;
            ();
        }
    );
    ();
};
$cv->recv;
