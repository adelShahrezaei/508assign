use strict;
# use warnings;
use Data::Dumper;

## p(tag|word) = freq(tag,word)/freq(word)

die "Error:Wrong number of arguments\nUsage : perl tagger.pl
     <POS trainig file> <POS test file> [<files> ...] " if ($#ARGV<1);

my $trainFile = $ARGV[0]; # training file name
my $testFile = $ARGV[1]; # test file name


our %wordFreqTbl; #  Word frequency table freq(w_i)

our %WordTagfreqTbl; # tag-word freqency table freq(w_i,t_i)




#generates frequency tables from training file

open(my $tainFn, $trainFile)
    or die "Could not open file '$trainFile' $!";


while (my $line = <$tainFn>){

    chomp $line;
    
    #tokenize
    my %tokens;
    %tokens = ($line =~ /([\w.:!)?&(,'\$%-]+|'+|`+|\w+\\\/\w+)\/([\w,.!():\$]+|'+|`+)/mg ); # crate hash of Word => Tag in current line
    
    keys %tokens; 
    while (my($key, $value) = each %tokens ){
        # key is the  word and value is the tag 
        $wordFreqTbl{$key}++; 
        $WordTagfreqTbl{$key}{$value}++;
    }
    
}

# retruns TAG that have max likelyhood value for input word, returns "NN" if 
# input does not exist.
sub maxLikelyHoodTag{
    my $word = shift; 
    my $max = 0; #holds max probelity
    my $maxTag; # holds Tag with max probabilty
    my $curP; 
    if (exists $wordFreqTbl{$word}){

        foreach my $tag (keys %{$WordTagfreqTbl{$word}}){
            
            $curP = $WordTagfreqTbl{$word}{$tag}/ $wordFreqTbl{$word};# claculate probabilty

            if ($curP > $max ){
                $max = $curP;
                $maxTag = $tag; 
            }
        } 

        return $maxTag;

    }else{
        #return "NN" if word does not exist in model
        return "NN";
    }

}

sub applyRules{

    
    my $line = shift ; 
    my @tokens = ($line =~ /([\w.:!)?&(,'\$%-]+|'+|`+|\w+\\\/\w+)\/([\w,.!():\$]+|'+|`+)/mg ); # crate array of words and Tags in current sentence
    
    #itterate over all tags 
    for (my $i=0; $i< $#tokens; $i=$i+2){
        
        # i = word
        # i+1 = tag
        # rule 1 : NN to VB if previous tag is TO
        if($tokens[$i+1] eq "NN" && $tokens[$i-1] eq "TO" ){
            $tokens[$i+1] = "VB";
            
        }
        

        # rule 2 : NN is capitalised use instead
        if($tokens[$i+1] eq "NN" && (lc($tokens[$i]) ne $tokens[$i])){
            $tokens[$i+1] = "NNP";
            
            
        }

         # rule 3 : NNP is not capitalised use NN instead
        if($tokens[$i+1] eq "NNP" && (lc($tokens[$i]) eq $tokens[$i])){
            $tokens[$i+1] = "NN";
            
            
        }

         # rule 4 : VBN to VBD if previous word is capitalised
        if($tokens[$i+1] eq "VBN" && (lc($tokens[$i]) ne $tokens[$i])){
            $tokens[$i+1] = "VBD";
            
        }

         # rule 5 : VBN to VBD if previous word is capitalised
        if($tokens[$i+1] eq "VBN" && (lc($tokens[$i]) ne $tokens[$i])){
            $tokens[$i+1] = "VBD";
            
        }

         # rule 5 : VBD to VBN if one of the three previous tag is VBZ
        if($tokens[$i+1] eq "VBD" && ($tokens[$i-5..$i-1] ~~ "VBZ")){
            $tokens[$i+1] = "VBN";
            
        }
        

        
    }

    #regenerate the orginal line
    my $result= ""; 
    if ($line =~ /\[.+\]/gm){
        $result .= "[ ";
        for (my $i=0; $i< $#tokens; $i=$i+2){
            $result.= $tokens[$i]."/".$tokens[$i+1]." ";
        }
        $result .="]";
    }else{
         for (my $i=0; $i< $#tokens; $i=$i+2){
           $result.= $tokens[$i]."/".$tokens[$i+1]." ";
        }
        
    }
   
    
    return $result;
}

#tag the test file

open(my $testFn, $testFile)
    or die "Could not open file '$trainFile' $!";


while (my $line = <$testFn>){

    chomp $line;
    
    # find the maximum likely hood tag for each token in line and put transform it  into "word/TAG" format
    $line =~ s/([\w.:!)?&(,'\\\/\$%-]+|'+|`+)/""."$1\/".maxLikelyHoodTag($1).""/ge; 

    print applyRules($line)."\n";
    # print $line."\n";
   
    
}

# print Dumper(\%WordTagfreqTbl);
