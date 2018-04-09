# Adel Shahrezaei

# This program is a simple tool to measure the accuracy of word sense disambiguation (WSD) model and generate a confusion matrix based on predicted senses and gold standard key. 
# The accuracy is measured by ratio of correctly tagged words over total number of words. To find out the number of 
# correctly senses, the predicted senses  is compared with a gold standard senses. The confusion matrix is generated based on 
# percentage of the overall tagging error. The confusion matrix is printed out in both tabular and list format. in tabular format columns indicate predicted tags
# and rows indicate actual tags. 


# note that predicted senses  file and key file should have same number of lines and be in the same format that is 
# "<answer instance="instance-ID" senseid="senseID"/>"

# usage : perl scorer.pl <predicted-sense-file> <key-sense-file> 
 
# example :$ perl scorer.pl my-line-answers.txt line-key.txt 

# output: 

## Total Instances : 126
## Correctly Tagged Words: 106
## Accuracy :84.1269841269841%

## Confusion Matrix (columns are predicted and rows are actual tags, values are overall error %)

##                 phone   product
## phone           0.00%   50.00%
## product         50.00%  0.00%


## Confusion Matrix in list format ( <actual> == > <predicted error%>


## <phone> ==>     <phone -- >     <product 50.00% >
## <product> ==>   <phone 50.00% > <product -- >

use strict;
use warnings;
use Data::Dumper;


die "Error:Wrong number of arguments\nUsage : perl scorer.pl
     <POS Tagged file> <POS Key File> " if ($#ARGV<1);

my $testAnswerfile = $ARGV[0]; # training file name
my $testKeyfile = $ARGV[1]; # test file name

our $totalInstances=0; # total number of words in the file
our $trueCount=0; # total number of correctly WSD instances 

our %confusionTbl; # confusion table as double hash in "actual => {predictd}" format




#generates frequency tables from training file

open(my $testAnswerFn, $testAnswerfile)
    or die "Could not open file '$testAnswerfile' $!";
open(my $keyFn, $testKeyfile)
    or die "Could not open file '$testKeyfile' $!";

while (my $testLine = <$testAnswerFn>){
    $totalInstances++;
    my $keyLine = <$keyFn>;
    chomp $testLine;
    chomp $keyLine;


    
    #tokenize
    
    $testLine =~ /senseid="([^"]*)"/mg; 
    my $myAnswer = $1; 

    $keyLine =~ /senseid="([^"]*)/mg ; # crate hash of Word => Tag  from key file
    my $key = $1; 

    $confusionTbl{$key}{$myAnswer}++;
    if ($myAnswer eq $key){
        $trueCount++;
    }
    
}

print "Total Instances : $totalInstances\nCorrectly Tagged Words: $trueCount \nAccuracy :".(($trueCount/$totalInstances)*100)."%\n\n"; 

my $falseCount = $totalInstances-$trueCount;


# print confusion matrix in tabular format
print "Confusion Matrix (columns are predicted and rows are actual tags, values are overall error %)\n\n";
my $count;
#print column header
print  "\t\t";
foreach my $predicted (sort (keys %confusionTbl)){
       print  "$predicted \t";
}
print "\n";
foreach my $actual (sort (keys %confusionTbl)){

    print "$actual\t\t";
    foreach my $predicted (sort (keys %confusionTbl)){
        if ($actual eq $predicted || !(exists ($confusionTbl{$actual}{$predicted}))){
            printf ("%0.2f%%\t",0);
            
        }
        else {
            printf ("%0.2f%%\t", 100*$confusionTbl{$actual}{$predicted}/$falseCount );
        }
    }
    print "\n";  
    
}


print "\n\nConfusion Matrix in list format ( <actual> == > <predicted error%> \n\n";

print "\n";
foreach my $actual (sort (keys %confusionTbl)){

    print "<$actual> ==>\t";
    foreach my $predicted (keys %{$confusionTbl{$actual}}){
        if ($actual eq $predicted ){
            printf ("<$predicted -- >\t");
            
        }
        else {
            printf ("<$predicted %0.2f%% >\t", 100*$confusionTbl{$actual}{$predicted}/$falseCount );
        }
    }
    print "\n";  
    
}

