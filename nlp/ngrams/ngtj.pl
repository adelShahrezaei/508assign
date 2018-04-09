
# use warnings;


## note that the double and single qoutation marks, that are wraping a sentence,
# are regarded as punctuations and treated as tokens




# use : perl ngrams.pl <n-grams> <number of generates sentcences> [<files> ...]

# die "use : perl ngrams.pl <n-grams> <number of generates sentcences> [<files> ...] " unless ($#ARGV>2);

print "This program generates random sentences based on an Ngram model.\n\n\n";



@files = @ARGV[2..$#ARGV]; # filename

$numOutput = $ARGV[1];


$n = $ARGV[0];# n-grams

$start = "<S>" ; # start token
$end = "<E>";# end token
$startn = "";
foreach my $i (0..($n-1)){
    $startn .= "$start "; 
}
%unigrams; 
%rawFreq;
%relativeFreq; 

# handle each file in filenames as corpus
foreach $file (@files){

    $content = ""; # store each text
    @sntcs  =(); #sentences
    #open file
    open($fn, $file)
        or die "Could not open file '$file' $!";
    
    while ($line = <$fn>){


        chomp $line ;
        $content .= $line;
    

    }

    #parse whole text into sentences
    @sntcs = $content =~ /[^?!.:]*[.?!:]['`’]*/gm; # find sentences 

    foreach $sntc (@sntcs) {
        

        

        # print "$sntc";
        $sntc = lc $sntc; #to lower case
        $sntc =~ s/([\(\).,;!?:]|[^\w]+[']|^['"]|['"][^\w])/ $1 /g; # add space between all punctuations
        $sntc =~ s/(^)(.*)($)/$1 $startn $2 $end $3/g; # add start and end tokens

    
        @tokens = ($sntc =~ /([^\s]+)/g); #parse tokens


        # generate unigram
        foreach (@tokens){
        $unigrams{$_} = defined $unigrams{$_}? $unigrams{$_}+1: 1;   
        }

    
        $c = 0;# current offset 
        
        while ($c+$n-1 < (0+@tokens) ){
        
            $history = join ' ',@tokens[$c..$c+$n-2];
            $current = $tokens[$c+$n-1];
            $rawFreq{$history}{$current} = defined $rawFreq{$history}{$current}? $rawFreq{$history}{$current}+1 : 1 ;
            $rawFreq{$history}{"#TOT#"}++;
            $c++;

        }
        chomp $sntc;
        

    
    
    
    
        
        
    }
    #Calculate thee relative probability
        foreach $history ( keys %rawFreq){
            foreach $cur ( keys %{$rawFreq{$history}}){
                if ($cur ne "#TOT#"){
                    $relativeFreq{$history}{$cur} = $rawFreq{$history}{$cur}/$rawFreq{$history}{"#TOT#"};
                }
            }

        }


}







# generates a sentence using Relative frequency table model
foreach my $i (0..$numOutput){

    my @sentence = qw(<S> <S>);
    my $next = ""; 
    my $r = rand(); 
    $sum = 0 ; 
    ##1st step: select start of a sentence
    foreach my $cur (keys %{$relativeFreq{"<S> <S>"}}){
        $sum += $relativeFreq{"<S> <S>"}{$cur};

        #we've found the corresponding probability 
        if ($sum > $r){
            $next = $cur;
            push @sentence, $next;
            last;
        }

    }
    
    # # generate next words until end of the sentence is reached
    # while($next ne "<E>"){
    $k=0;
    while ($next ne "<E>"){
        $sum = 0;
        $r = rand();
        $lastwords = join " " ,@sentence[($#sentence-($n-1)+1)..$#sentence];
        # $lastwords = join " ",@sentence[0..1];
        # print $lastwords."\n";
        foreach my $cur (keys %{$relativeFreq{$lastwords}}){
            # print $cur;
            $sum += $relativeFreq{$lastwords}{$cur};
            if ($sum > $r){
                $next = $cur;
                push @sentence, $next;
                last;
            }
        
        }
        


    }

    $result = join " ",@sentence;
    $result =~ s/(^["']|(?<=[\s])['"]|["'](?=[\s])|\s+(?=[.,;:!?]))//g; # fix the punctuations
    $result =~ s/(<S>\s*|\s<E>)//g;
    print $result."\n";
}






