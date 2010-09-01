#!/usr/bin/perl
use strict;

my $account='lala@lalalala.com';
my $log_path=' /var/log/httpd/combined_log';


use IO::Socket;
my $sock = IO::Socket::INET->new(PeerPort  => 8888,
                                 PeerAddr  => "127.0.0.1",
                                 Proto     => "udp",    
                                 LocalAddr => 'localhost'
                                 ) 
                             or die "Can't bind : $@\n";



open(LOG,"ssh $account tail -f $log_path |");

while(<LOG>) {
   chomp;
   if(/HTTP\/\d.\d\"\s200/) {
        print "OK:$_\n";
        $sock->send("MACRO_GREEN");
   } elsif (/HTTP\/\d.\d\"\s404/) {
        print "NOTFOUND:$_\n";
        $sock->send("MACRO_RED");
   } elsif (/HTTP\/\d.\d\"\s403/) {
        print "FORBIDDEN:$_\n";
        $sock->send("MACRO_RED");
   } elsif(/HTTP\/\d.\d\"\s500/) {
        print "ERROR:$_\n";
        $sock->send("MACRO_BEAT");
   } else {
       print "RECVD:$_\n";
   }
}
