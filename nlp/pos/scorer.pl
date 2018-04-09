use strict;
use warnings;
use Data::Dumper;

## p(tag|word) = freq(tag,word)/freq(word)

die "Error:Wrong number of arguments\nUsage : perl scorer.pl
     <POS Tagged file> <POS Key File> " if ($#ARGV<1);

my $testwtagsfile = $ARGV[0]; # training file name
my $testkeyfile = $ARGV[1]; # test file name

our $totalWords=0; # total number of words in the file
our $trueTagCount=0; # total number of correctly tagged words 

our %confusionTbl; # confusion table as double hash in "actual => {predictd}" format




#generates frequency tables from training file

open(my $testWtagsFn, $testwtagsfile)
    or die "Could not open file '$testwtagsfile' $!";
open(my $keyFn, $testkeyfile)
    or die "Could not open file '$testkeyfile' $!";

while (my $testLine = <$testWtagsFn>){
    my $keyLine = <$keyFn>;
    chomp $testLine;
    chomp $keyLine;


    
    #tokenize
    my %testTokens;
    %testTokens = ($testLine =~ /([\w.!)?&(,'\$%-]+|'+|`+|\w+\\\/\w+)\/([\w,.!():\$]+|'+|`+)/mg ); # crate hash of Word => Tag from test file
    
    my %keyTokens;
    %keyTokens = ($keyLine =~ /([\w.!)?&(,'\$%-]+|'+|`+|\w+\\\/\w+)\/([\w,.!():\$]+|'+|`+)/mg ); # crate hash of Word => Tag  from key file
    
    keys %testTokens; 
    while (my($word, $tag) = each %testTokens ){
        # key is the  word and value is the tag 
        $totalWords++;
        if ($tag eq $keyTokens{$word}) #if predicted is equal to actual tag
        {
            $trueTagCount++;
        }  

        $confusionTbl{$keyTokens{$word}}{$tag}++;
    }
    
}

print "Total Words : $totalWords\nCorrectly Tagged Words: $trueTagCount \nAccuracy :".($trueTagCount/$totalWords)."\n\n"; 

my $falseTagCount = $totalWords-$trueTagCount;


# print confusion matrix
my $count;
#print column header
print  "\t\t\t";
foreach my $predicted (sort (keys %confusionTbl)){
       print  "$predicted \t";
}
print "\n";
foreach my $actual (sort (keys %confusionTbl)){

    print "$actual \t\t";
    foreach my $predicted (sort (keys %confusionTbl)){
        if ($actual eq $predicted || !(exists ($confusionTbl{$actual}{$predicted}))){
            printf ("%0.3f\t",0);
            
        }
        else {
            printf ("%0.3f\t", 100*$confusionTbl{$actual}{$predicted}/$falseTagCount );
        }
    }
    print "\n";  
    
}

print "\n";
foreach my $actual (sort (keys %confusionTbl)){

    print "<$actual> \t";
    foreach my $predicted (keys %{$confusionTbl{$actual}}){
        if ($actual eq $predicted ){
            printf ("<$predicted --> \t");
            
        }
        else {
            printf ("<$predicted %0.2f>\t", 100*$confusionTbl{$actual}{$predicted}/$falseTagCount );
        }
    }
    print "\n";  
    
}

# print Dumper(\%confusionTbl);