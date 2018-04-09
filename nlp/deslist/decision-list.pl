#!/usr/bin/perl

# Adel Shahrezaei

# This program uses collocation features  to learn a decision list classifier in order to perform word sense
# disambiguation task of word "line" on the given test-data. In a decision list classifier, a sequence of tests is applied to each
# input. If a test succeeds, then the sense associated with that
# test is applied to the input and returned. If the test fails, then the next test
# in the sequence is applied. This continues until the end of the list, where a
# default test simply returns the majority sense ("phone"). 
# We have used Yarkowsky's method. set of tests are ordered based on their individual
# accuracy on the training data, where the accuracy of a test is calculated on Log-likelihood measure.:
# abs (log (P(s_1|f_i = v_j)/P(s_2|f_i = v_j))))
# this algorithm can only perform binary decision tasks. 
# Tests are generated according to all the possible values of all the features.
# The result of the classification will be written to the STDOUT.  
#
#
##feature vector used: 
#  Collocation features: 
#    *Word immediately to the right (+1 W) (ID = 0)
#    *Word immediately to the left (-1 W) (ID = 1)
#    *Pair of words at offsets -2 and -1 (ID = 2)
#    *Pair of words at offsets -1 and +1 (ID = 3)
#    *Pair of words at offsets +1 and +2 (ID = 4)
# 

# note that the training file and test file should in the senseval-2 format

# usage : decision-list.pl <line-train-file> <line-test-file <my-decision-list-file> 
#
# this also generates  "my-decision-list-file" that is a log file containing decision lists and their
# criteria along with calculated log likelihood based on the training data

# example :$ decision-list.pl line-train.txt line-test.txt my-decision-list.txt > my-line-answers.txt

# output: 

# <answer instance="line-n.w8_059:8174:" senseid="phone"/>
# <answer instance="line-n.w7_098:12684:" senseid="product"/>
# <answer instance="line-n.w8_106:13309:" senseid="phone"/>
# <answer instance="line-n.w9_40:10187:" senseid="phone"/>
# <answer instance="line-n.w9_16:217:" senseid="product"/>
# <answer instance="line-n.w8_119:16927:" senseid="product"/>
# <answer instance="line-n.w8_008:13756:" senseid="phone"/>
# <answer instance="line-n.w8_041:15186:" senseid="phone"/>
# <answer instance="line-n.art7} aphb 05601797:" senseid="phone"/>
# <answer instance="line-n.w8_119:2964:" senseid="product"/>
# <answer instance="line-n.w7_040:13652:" senseid="phone"/>
# <answer instance="line-n.w7_122:2194:" senseid="phone"/>
# <answer instance="line-n.art7} aphb 45903907:" senseid="phone"/>
# <answer instance="line-n.art7} aphb 43602625:" senseid="phone"/>
# <answer instance="line-n.w8_034:3995:" senseid="product"/>
# <answer instance="line-n.w8_139:696:" senseid="product"/>
# <answer instance="line-n.art7} aphb 20801955:" senseid="phone"/>
# <answer instance="line-n.w8_028:3156:" senseid="product"/>
# ...

# Baseline accuracy with most frequent sense ("phone")
# Total Instances : 126
# Correctly Tagged Words: 72
# Accuracy :57.1428571428571%

# Confusion Matrix (columns are predicted and rows are actual tags, values are overall error %)

#                 phone   product
# phone           0.00%   0.00%
# product         100.00% 0.00%


# Confusion Matrix in list format ( <actual> == > <predicted error%>


# <phone> ==>     <phone -- >
# <product> ==>   <phone 100.00% >

# # Final accuracy after applying the model
# Total Instances : 126
# Correctly Tagged Words: 106
# Accuracy :84.1269841269841%

# Confusion Matrix (columns are predicted and rows are actual tags, values are overall error %)

#                 phone   product
# phone           0.00%   50.00%
# product         50.00%  0.00%


# Confusion Matrix in list format ( <actual> == > <predicted error%>


# <phone> ==>     <product 50.00% >       <phone -- >
# <product> ==>   <phone 50.00% > <product -- >

use strict;
# use warnings;
use Data::Dumper;
use XML::Parser; 


die "Error:Wrong number of arguments\nUsage : perl tagger.pl
     <POS training file> <POS test file> [<files> ...] " if ($#ARGV<1);


my $trainFile = $ARGV[0]; # training file name
my $testFile = $ARGV[1]; # test file name
my $decisionListFile = $ARGV[2]; # decision list output file name

my $trainText; # content of training file 
my $testText;  # content of test file
my @sortedList; # sorted decision list 
my %trainHash;  # hash structure for training data
my @decisionList;  # array for all decisions 
my @featureVectors; # list of feature vectors

my @colFeatures; # collocation features matrix as array of hash
                 # with: 
                 # <Word immediately to the right (+1 W), Word immediately to the left (-1 W),
                 # ,Pair of words at offsets -2 and -1, Pair of words at offsets -1 and +1 ,
                 # Pair of words at offsets +1 and +2 > 

# string formats to output my-decision-list.txt file
my @testFormat = ("select \"%s\" if +1w is \"%s\" with log-likelihood : %f \n",
                "select \"%s\" if -1w is \"%s\" with log-likelihood : %f \n",
                "select \"%s\" if words at offsets -2 and -1, is \"%s\" with log-likelihood : %f \n",
                "select \"%s\" if words at offsets -1 and +1, is \"%s\" with log-likelihood : %f \n",
                "select \"%s\" if words at offsets +1 and +2, is \"%s\" with log-likelihood : %f \n",
                );


# reads training file line by line and store in a variable 
sub readTrainFile {

    open(my $trainFn, $trainFile)
    or die "Could not open file '$trainFile' $!";
    
    while (my $line = <$trainFn>){
       
        $trainText .= $line
    }

}

# parse training text to extract instances and put the in hash table with instance Id as key
# each sentence 
sub parseText{
    my $senseID;
    my $context;
    my $instance;
    my $instanceId;
    # extract instances
    while($trainText =~ /<instance id="([^"]+)">([\w\W]*?)<\/instance>/mg ){
        $instanceId = $1;
        $instance = $2;
        #capture senesID
        if ($instance =~ /<answer .*? senseid="([^"]+)"\/>/mg){
            $senseID  = $1;
        }

        if ($instance =~ /<context>([\w\W]*?)<\/context>/mg){
            $context = lc($1); # convert everything to lowercase
        }
        $trainHash{$instanceId}{"senseid"} = $senseID;
        $trainHash{$instanceId}{"context"} = $context; 
    }

}

# generates list of the aggregated feature vector, since we are not going to use the actual feature vectors, 
# for each feature, it counts the occurrence of each value and the associated senseID  
# generating feature vectors would add an extra step to learning process but for learning proposes
# I also built the list of feature vector. 
sub getFeatures {
    
    
    my $instance = shift;
    
    my $senseID = %{$instance}{"senseid"} ;
    # 0 : +1W
    # 1 : -1W
    # 2 : -2 and -1
    # 3 : -1 and +1
    # 4 : +1 and +2
    
    
    if (%{$instance}{"context"} =~ /([^\s]+)\s+([^\s]+)\s+<head>line[s]?<\/head>\s+([^\s]+)\s+([^\s]+)/gm ){
        $colFeatures[0]{$3}{$senseID}++;
        $colFeatures[1]{$2}{$senseID}++;
        $colFeatures[2]{"$1 $2"}{$senseID}++;
        $colFeatures[3]{"$2 $3"}{$senseID}++;
        $colFeatures[4]{"$3 $4"}{$senseID}++;
        my @v = ($3, $2, "$1 $2", "$2 $3", "$3 $4" );
        push @featureVectors, \@v; 
    }
    

}

# learn the decision test classifier from the feature vector list and store the model in decision list 
# each decision is stores as a hash containing, featureIdx,value, sense and log-likelihood   table in the array 
sub createTests {

   # find log value for each feature and value
   my $c_s_1_f_v ;# count (s_1,F_i = V_j)
   my $c_s_2_f_v ;# count (s_2,F_i = V_j)
   my $c_f_v ;# count (F_i = V_j)
   my $p_s1; #  count (s_1,F_i = V_j) / count (F_i = V_j)
   my $p_s2; #  count (s_2,F_i = V_j) / count (F_i = V_j)
   my $fid =0;  # feature ID  
   my $accLog; # accuracy log  = abs(log(p(s1|f1)/p(s2|f1))) which tells us how discriminative a feature is.   
   my $sense;
   
       #each feature
       foreach my $feature (@colFeatures){

           foreach my $value (keys %{$feature}) {# this is only one
           #calculate the log of the accuracy 
           $c_s_1_f_v = %{%{$feature}{$value}}{"phone"}+1; # in order to prevent division by zero
           $c_s_2_f_v = %{%{$feature}{$value}}{"product"}+1; #  
            
           $c_f_v = $c_s_1_f_v+$c_s_2_f_v; # count(fi) is equal to sum of possible senses.
           
           $p_s1 = $c_s_1_f_v/$c_f_v;
           $p_s2 = $c_s_2_f_v/$c_f_v;
           
           $accLog = abs(log($p_s1/$p_s2));
          
           $sense = $p_s1>$p_s2?"phone":"product"; # pick sense with higher probability 


           push @decisionList, {feature => $fid, value => $value, accLog => $accLog, sense => $sense };


           
           }
        $fid++;
       }
       

   
   

}


#read test file and run the classifier
sub parseTestFile(){

    my $senseID;
    my $instanceId;
    my $instance;
    my $context;
    open(my $testFn, $testFile)
    or die "Could not open file '$trainFile' $!";
    
    while (my $line = <$testFn>){
       
        $testText .= $line;
    }

    while($testText =~ /<instance id="([^"]+)">([\w\W]*?)<\/instance>/mg ){
        $instanceId = $1;
        $instance = $2;
        if ($instance =~ /<context>([\w\W]*?)<\/context>/mg){
            $context = lc($1);
        }
        # predict the sense using the model
        $senseID = runTestList($context);
        # output the the predicted answer 
        print "<answer instance=\"$instanceId\" senseid=\"$senseID\"/>\n";
    }

} 

#write decision list  to the file
sub printDecisionList(){
    open(my $fh, '>', $decisionListFile) or die "Could not open file '$decisionListFile' $!";

    foreach my $decision (@sortedList){
        
        my $sense =  %{$decision}{sense};
        my $value = %{$decision}{value};
        my $log = %{$decision}{accLog};
        printf $fh $testFormat[%$decision{feature}], $sense,$value,$log;
    }
    close $fh;

}

# predict result for input instance using decision list classifier
# runs  all the test in the list, if a test succeeds return associated sense. otherwise return most
# frequent sense ("Phone") 
sub runTestList (){
   my $context = shift;

    if ($context =~ /([^\s]+)\s+([^\s]+)\s+<head>[lL]ine[s]?<\/head>\s+([^\s]+)\s+([^\s]+)/gm ){
        
        #test for feature 1
        foreach my $test (@sortedList){

            # test for feature 1
            
            if(%{$test}{"feature"} == 0){
                # print "$3 eq ".%{$test}{value}."\n";
                if ($3 eq %{$test}{"value"}){
                    return %{$test}{"sense"};
                }
            }

            #test for feature 2
            if(%{$test}{"feature"} == 1){
                # print "$2 eq ".%{$test}{value}."\n";
                if ($2 eq %{$test}{"value"}){
                    return %{$test}{"sense"};
                }
            }

            #test for feature 3
            if(%{$test}{"feature"} == 2){
                # print "$1 $2 eq ".%{$test}{value}."\n";
                if ("$1 $2" eq %{$test}{"value"}){
                    return %{$test}{"sense"};
                }
            }

            ##test for feature 4
            if(%{$test}{"feature"} == 3){
                if ("$2 $3" eq %{$test}{"value"}){
                    return %{$test}{"sense"};
                }
            }

             ##test for feature 5
            if(%{$test}{"feature"} == 4){
                if ("$3 $4" eq %{$test}{"value"}){
                    return %{$test}{"sense"};
                }
            }

           

        }
         return "phone" ; # select phone if none of the test passed 

    }



}

# read training file
readTrainFile();
# parse training file
parseText();

my %temp;

#generate aggregated feature vectors 
foreach my $key (keys %trainHash){
    my @temp;
    
    getFeatures(\%{$trainHash{$key}});
    # push @colFeatures , \@temp;
}
#create test based on the feature vectors 
createTests();

# sort decision list in descending order
@sortedList = sort { $b->{accLog} <=> $a->{accLog}} @decisionList;

# write decision list to file
printDecisionList();


#read test file and run the classifier
parseTestFile();

# print Dumper(\@colFeatures);
# print Dumper(\@sortedList);
# print Dumper(\@featureVectors);