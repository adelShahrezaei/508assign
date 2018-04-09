#!/usr/bin/perl
use strict;
# use warnings;
use Data::Dumper;
use XML::Parser; 
#feature vectors used: 
# Collocation features: 
#    *Word immediately to the right (+1 W) 
#    *Word immediately to the left (-1 W) 
#    *Pair of words at offsets -2 and -1 
#    *Pair of words at offsets -1 and +1 
#    *Pair of words at offsets +1 and +2 


## p(tag|word) = freq(tag,word)/freq(word)

die "Error:Wrong number of arguments\nUsage : perl tagger.pl
     <POS training file> <POS test file> [<files> ...] " if ($#ARGV<1);


my $trainFile = $ARGV[0]; # training file name
my $testFile = $ARGV[1]; # test file name

my $trainText;
my $testText;  

my %trainHash; 
my @decisionList;  # array for all decisions 


my @colFeatures; # collocation features matrix as array of hash
                 # with: 
                 # <Word immediately to the right (+1 W), Word immediately to the left (-1 W),
                 # ,Pair of words at offsets -2 and -1, Pair of words at offsets -1 and +1 ,
                 # Pair of words at offsets +1 and +2 > 



# my $parser = new XML::Parser(Style => 'Tree', ErrorContext => 2);
# my $tree = $parser->parsefile($trainFile);

sub readTrainFile {

    open(my $trainFn, $trainFile)
    or die "Could not open file '$trainFile' $!";
    
    while (my $line = <$trainFn>){
       
        $trainText .= $line
    }

}

# parse text to extract instances and put the in hash table with instance Id as key
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
        if ($instance =~ /<answer .*? senseid="([^"]+)"\/>/mg){
            $senseID  = $1;
        }
        if ($instance =~ /<context>([\w\W]*?)<\/context>/mg){
            $context = $1;
        }
        $trainHash{$instanceId}{"senseid"} = $senseID;
        $trainHash{$instanceId}{"context"} = $context; 
    }

}

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

    }

    # # extract -1W
    
    # $context =~ /([^\s]+)\s+<head>line[s]?<\/head>/gm ;
    #     $featureV[1] = $1;
    
    
    # # Pair of words at offsets -2 and -1 
    # if ($context =~ /([^\s]+\s+[^\s]+)\s+<head>line[s]?<\/head>/gm ){
    #     $featureV[2] = $1;
    # }

    # # Pair of words at offsets -1 and +1 
    # $context =~ /([^\s]+)\s+<head>line[s]?<\/head>\s+([^\s]+)/gm ;
    #     $featureV[3] = "$1 $2";
    #     print "$1 $2 dfdff";
    
    # #Pair of words at offsets +1 and +2 
     
    # if ($context =~ /<head>line[s]?<\/head>\s+([^\s]+\s+[^\s]+)/gm){
    #     $featureV[4] = $1;
    # }

    

}

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
   
       foreach my $feature (@colFeatures){

           foreach my $value (keys %{$feature}) {# this is only one
           #calculate the log of the accuracy 
           # TODOD OOOOOOOO PHOME ? 
           $c_s_1_f_v = %{%{$feature}{$value}}{"phone"}+1; #????
           $c_s_2_f_v = %{%{$feature}{$value}}{"product"}+1; # ??? 
            
           $c_f_v = $c_s_1_f_v+$c_s_2_f_v; # count(fi) is equal to sum of possible senses.
           
           $p_s1 = $c_s_1_f_v/$c_f_v;
           $p_s2 = $c_s_2_f_v/$c_f_v;
           
           $accLog = abs(log($p_s1/$p_s2));
          
           $sense = $p_s1>$p_s2?"phone":"product";

           push @decisionList, {feature => $fid, value => $value, accLog => $accLog, sense => $sense };


           
           }
        $fid++;
       }
       

   
   

}



readTrainFile();
parseText();

my %temp;

foreach my $key (keys %trainHash){
    my @temp;
    
    getFeatures(\%{$trainHash{$key}});
    # push @colFeatures , \@temp;
}

createTests();

# sort decisionlist
my @sortedList = sort { $b->{accLog} <=> $a->{accLog}} @decisionList;
# print Dumper(\@colFeatures);
print Dumper(\@sortedList);