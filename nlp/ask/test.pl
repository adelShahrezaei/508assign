use Data::Dumper
my @AoH;
$rec = {};
    
$rec->{'q'} = 'big';
push @AoH, $rec;


$rec ={ };
$rec->{'q'} = 'short';

push @AoH, $rec;

print Dumper(\@AoH);