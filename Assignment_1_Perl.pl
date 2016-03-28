
use strict;
use warnings;


my $txt_file = "Yourname.txt";
open(my $FX, '>', $txt_file);


print "Your name?\n ";
my $name = <STDIN>;
print "Where do you live?\n ";
my $address = <STDIN>;

print $FX "Name: $name";
print $FX "Address: $address";
close $FX;

#------------------------------------------------------------------------------


my $bin_file = "Yourname.bin";

open(my $DX, '<', $txt_file);
open(my $BX, '>', $bin_file);
my $txt_val;
while (my $Line = <$DX>){
	chomp $Line; 
	$txt_val = unpack('B*',$Line);
	print $BX "$txt_val\n";
}
close $DX;
close $BX;


#-------------------------------------------------------------------------------

open(my $BF, '<', $bin_file);
open(my $CX, '>', "last.txt");
my $bin_value;

while (my $Line_binary = <$BF>){
	chomp $Line_binary;
	$bin_value = pack('B*', $Line_binary);
	print $CX "$bin_value\n";
}
close $BF;
close $CX
