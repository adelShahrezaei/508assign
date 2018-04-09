
# this program learns a n-gram model base based on given text files 
# after generating raw frequency table we calculate relative frequnecy table using 
# markov assumption. It also generates arbitary number of random sentences using the model
# puctuations are also include in the model 


# note that the double and single quotation marks, that are wraping a sentence,
# are regarded as punctuations and treated as tokens

# read file
# use : perl ngrams.pl <n-grams> <number of generates sentcences> [<files> ...]

# example : peel ngram.pl 3 10 1399-0.txt sl5.txt 76-0.txt catcher.txt
# this should generate 10 randomly generated sentences based on a tri-gram model learned from 
# the ".txt" files
# for the corpus use plain text files/



die "Error:Wrong number of arguments\nUsage : perl ngrams.pl <N-grams model> <number of generated sentences> [<files> ...] " if ($#ARGV<=1);


@filenames = @ARGV[2..$#ARGV]; # filename 
$numOfSentences = $ARGV[1]; # number of random sentences to generate based the model

$N = $ARGV[0];# n-grams
$startToken = "<Start> " x($N-1)  ; # start token multiplid by model size
$endToken = "</Start>";# end token
%n_1_gram; #n-1 gram table
%frequencyTable; # raw frequency table
%relativeFreqTable; # relative frequncy table p(w|x)



# this method uses the punctuations ".!:?" and quotation marks to extract all the sentences from the text give text
sub findSentences{

    $txt = shift;

    @sentences = $txt =~ /[^?!.:]*[.?!:]['`’"]*/gm; # find sentences

}

#extracts tokens based from give sentences
sub processSentence{

    
    
    $sentence = shift;
    # $sentence = lc $sentence; #to lower case
    $sentence =~ s/([\(\).,;!?:]|[^\w]+[']|^['"]|['"][^\w])/ $1 /g; # add space between all punctuations
    $sentence =~ s/(^)(.*)($)/$1 $startToken $2 $endToken $3/g; # add start and end tokens

    @tokens = ($sentence =~ /([^\s]+)/g); #extract each token

    # generate frequency table
    
    $leftBound = 0;# left boundary of the history 

    while ($leftBound+$N-1 < (0+@tokens) ){
        
        $i = join ' ',@tokens[$leftBound..$leftBound+$N-2];
        $current = $tokens[$leftBound+$N-1];
        $frequencyTable{$i}{$current} = defined $frequencyTable{$i}{$current}? $frequencyTable{$i}{$current}+1 : 1 ;
        $frequencyTable{$i}{"~aggTotal~"}++; #store the total number of occurrence 
        $leftBound++;

    }

} 

# this method calculates the relative frequencies of raw frequency table
sub calcRelativeFreq{
    # i & j represent current word and history

    foreach $i ( keys %frequencyTable){
        foreach $j ( keys %{$relativeFreqTable{$i}}){
            if ($j ne "~aggTotal~"){
                $relativeFreqTable{$i}{$j} = $frequencyTable{$i}{$j}/$frequencyTable{$i}{"~aggTotal~"};
            }
        }

    }

}

# generates a sentence using learned model
# next word in the sentence is selected by a random number and probability disrtibution 
# of all of the possible next words in the model

sub generateSentence{
    
    my @sentence = split " ",$startToken; # start with te startToken
    my $nextWord = ""; 
    my $r = rand(); # generate a random number between 0-1
    $sum = 0 ; 

    

    foreach my $i (keys %{$relativeFreq{$startToken}}){
        $sum += $relativeFreq{$startToken}{$i};

        #if the current sum of the  probabilities of previous items are less than greater than 
        # random number we know that the random number lies between current word and next word

        if ($sum > $r){
            $nextWord = $i;
            push @sentence, $nextWord; #add the word to the sentence
            last;
        }

    }
    
    # Keep finding next words until we reach End of the sentence
    while ($nextWord ne $endToken){

        $sum = 0;
        $r = rand();
        $current = join " " ,@sentence[($#sentence-($N-1)+1)..$#sentence];
       
        foreach my $j (keys %{$relativeFreq{$current}}){

            $sum += $relativeFreq{$current}{$j};
            if ($sum > $r){
                $nextWord = $j;
                push @sentence, $nextWord;
                last;
            }
        
        }
        


    }

    $output = join " ",@sentence; #generate the sentece for the array
    $output =~ s/(^["']|(?<=[\s])['"]|["'](?=[\s])|\s+(?=[.,;:!?]))//g; # replace all the punctuations 

    return $output;


}


# handle each file in filenames as corpus
foreach $filename (@filenames){

    $txt = ""; # store each text
    @sentences  =(); #sentences
    
    open($fn, $filename)
        or die "Could not open file '$filename' $!";
    
    while ($line = <$fn>){


        chomp $line ;
        $txt .= $line;
    

    }

    #parse whole text into sentences
    findSentences($txt);
    $leftBound = 0; 

    foreach (@sentences) {
        processSentence($_);
        # print "[$leftBound] $_\n";
        $leftBound++;
    }

}




# print Dumper(\%frerelativeFreqTable;

calcRelativeFreq();


foreach my $i (0..$numOfSentences){
    $genSentence = generateSentence();
    $genSentence =~ s/(<Start>\s*|\s<\/Start>)//g; #remove start and end token for better printing
    print generateSentence()."\n";
}




#dump data of unigram 
# foreach $key (sort (keys(%unigrams))){
#     print "$key\t==>\t$unigrams{$key}\n";
# }





# print Dumper(\%relativeFreq);