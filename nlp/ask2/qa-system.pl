#Mohammad Adel Shahrezaei
# This program is a simple question and answer system that interact with the user through terminal
# After capturing the question(e.g "Who was abraham lincoln?") as in put. we extract the possible subject of the question ("Abraham Lincoln")
# this subject is used to query wikipedia and fetch the summary of the corresponding Wikipage. 
# Multiple possible rewrites of the question possible answer patters were generated using regular expression and sentence structure
# we used this rewrite to search through the wiki page and capture the answer, from this answer we generate a
# ("abraham lincoln was an American statesman and lawyer who served as the 16th President...") and print it stdout.
# question rewrite system uses type of the question ("who, what, when, where"),verb variations and auxiliary verbs to generate answer patterns.
# for where and when questions wiki page's info box is also used. If the program can not find the answer it response  
# Input questions have to be grammatically correct and contain a recognizable subject for example "where is my book" would not work. 
# a log file is also generated for debugging proposes which contains : the users question, the searches executed, the raw results 
# from Wikipedia, and the generated answer .

# usage : perl qa-system.pl <mylogfile.txt>

# type exit to quit


use strict;
use warnings;
use Data::Dumper;
use WWW::Wikipedia;
use WordNet::QueryData;


use open ":std", ":encoding(UTF-8)";

# read stop words
open (my $sfh, '<',"stopword.txt") or die "Could not open Stopwords.txt";
chomp(my @stopwords = <$sfh>);
close $sfh;
our %stopwords = map {$_ => 1} @stopwords;
# fix case sensetive ness 
our %verbVariants = ('is' => ['was'],
                 'was'=> ['is'],
                 'die'=> ['died','death'],
                 'death'=> ['die', 'died'],
                 

);

our %auxVerbs = ('do'=>1, 'does'=>1, 'did'=>1);

our @articles = ('a', 'an', 'the');
our %articlesH = map { $_ => 1 } @articles; # turn arrya into hash for existence check 

our $logFileName = $ARGV[0];
open (our $fh, '>' ,$logFileName) or die "Could not open file '$logFileName' $!";

our %question; # stores all data for current question
our %rewrites; # stores all rewrites for current question
# main loop
print "**This is a QA system by Adel Shahrzaei. It will try to answer questions that start with Who, What, When or Where.
\nEnter \"exit\" to leave the program.\n \n=?> ";


# while(<STDIN>){

#     my $question = $_; 
    
#     chomp;
#     exit if $_ eq "exit";

#     # $question = $_;
#     print "=> ";
#     findAnswer($question);
#     print "=?> "
   

   

# }




# start the pipeline
sub findAnswer{
    #init question
    undef %question ;
    $question{'subjects'} = ();

    my $answered = 0 ;#flag to see if we've found answer or not
    my $q = shift;
    print $fh "\n\n\n=========================<USER QUESTION> $q\n";
    my @tokens = tokenize($q);
    my @queries = rewriteQuery(@tokens);
    my $wikiText = "";
    
   print Dumper(\%question);
    
    
    foreach my $query (@queries){

       if ($wikiText eq ""){

          $wikiText = queryWiki(\%{$query});
          print $fh "<RAW WIKI> $wikiText\n";
       }  
       
       my %qhash = %{$query};
       print $fh "<QUERY> ";
       print $fh Dumper(\%{$query});
       print $fh "\n";       
    
       if (my $answer = matchAnswer(\%{$query},$wikiText)){
           
           if(exists($qhash{'add'})){
            print "$qhash{'subject'} $qhash{'verb'} $qhash{'add'} $answer.\n"; 
            print $fh "<ANSWER> $qhash{'subject'} $qhash{'verb'} $qhash{'add'} $answer.\n";   
           }else{
            print $fh "<ANSWER> $qhash{'subject'} $qhash{'verb'} $answer.\n";
            print "$qhash{'subject'} $qhash{'verb'} $answer.\n";   
           }
           $answered = 1;
           last;
       }
      
    }
    if($answered == 0){
        print "I am sorry, I don't know the answer.\n";
    }
    
}
# rewrite the question 
sub queryReformulation(){
    # use word net for query expansion


}
#generates all possible Permutation of given word list (w1,w2,w3,w4 & w2,w3,w1,w4)
sub genPermutation{
    my @words = @{shift()};


}
sub rewriteQuery{
    
    my @tokens = @_;
    my $type = $tokens[0]; # type of the question who,what,...
    my $verb;
    my $auxVerb;
    my $article;
    my $subject;
    my @rewrites;
    if (lc $type eq "who"){ # for who questions e.g. "who was hitler?"
            
            $verb = $tokens[1];
            $subject = join(" ",@tokens[2..$#tokens]);
            
                
                
                my $q = { }; 
                $q->{'q'} = qr/(?i) $verb ((?:a[n]? |the )[^.]*)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
               
                push @rewrites, $q;
                if (exists $verbVariants{$verb}){
                    foreach my $var (@{$verbVariants{$verb}}){
                        my %q = ('q'=>qr/(?i) $var ((?:a[n]?|the) [^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$var);
                        
                        push @rewrites, \%q;
                        
                        
                        
                    }
                    
                
                }

    }

    elsif (lc $type eq "what"){ # what question e.g. "what is a computer?"
            
            $verb = $tokens[1];
            if (exists $articlesH{$tokens[2]}){ ## there is an article a. an, the
                $article = $tokens[2];
                $subject = join(" ",@tokens[3..$#tokens]);            
            }else{ #there is no article 
                $subject = join(" ",@tokens[2..$#tokens]);
            }

           
                
                
                my %q = ('q'=>qr/(?i) $verb ((?:a[n]? |the |)[^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$verb);
                push @rewrites, \%q;
                 if (exists $verbVariants{$verb}){
                    foreach my $var (@{$verbVariants{$verb}}){
                        my %q = ('q'=>qr/(?i) $var ((?:a[n]? |the |)[^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$var);
                        
                        push @rewrites, \%q;
                        
                        
                        
                    }
                    
                
                }

    }
    elsif (lc $type eq "when"){ # when question e.g. "when jimi hendrix was born?"
            #check for auxiliary verb
            
            if (exists($auxVerbs{$tokens[1]})){# there is an auxilary verb "when did mohammad ali died?"
                $auxVerb = $tokens[1];
                $verb = $tokens[$#tokens];
                
                $subject = join(' ',@tokens[2..$#tokens-1]);
            }else{ # there is no auxilary verb "when did mohammad ali died?"
                $verb = $tokens[1];
                $subject = join(' ',@tokens[2..$#tokens]);
            }
             
                
                my $q = { }; 
                $q->{'q'} = qr/(?i)((?:celebrated (?:on )|taking place (?:on ))[^.,!?]*)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;

                $q = { }; 
                $q->{'q'} = qr/(?i) ((?:before |after |on |during )[^.!?=]*)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
 

                push @rewrites, $q;
           
                $q = { }; 
                $q->{'q'} = qr/(?i) date of the $subject $verb ((?:before |after |on |during | )[^.]*)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                

                push @rewrites, $q;

                $q = { }; 
                $q->{'q'} = qr/(?i)((?:before |after |on |during )(?:january |february |march |april 
                |may |june |july |august |september |november |december )(?:[0-9]{1,2})?(?:, [0-9]{4})?)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                
                push @rewrites, $q;

                # check for verb variations 
                if (exists $verbVariants{$verb}){
                    foreach my $var (@{$verbVariants{$verb}}){
                        $q = { }; 
                        $q->{'q'} = qr/(?i) $var ((?:before |after |on |during )[^.]*)[.,!?]/;
                        $q->{'subject'} = $subject;
                        $q->{'verb'} = $var;

                        push @rewrites, $q;

                        $q = { }; 
                        $q->{'q'} = qr/(?i) date of the $subject $var ((?:before |after |on |during | )[^.]*)[.,!?]/;
                        $q->{'subject'} = $subject;
                        $q->{'verb'} = $var;


                        push @rewrites, $q;
                        
                        
                    }
                    
                
                }
                
                
                

                

    }
    elsif (lc $type eq "where"){ # when question e.g. "where is paris?"
            #check for auxiliary verb
            
            if (exists($auxVerbs{$tokens[1]})){# there is an auxilary verb "when did mohammad ali died?"
                $auxVerb = $tokens[1];
                $verb = $tokens[$#tokens];
                
                $subject = join(' ',@tokens[2..$#tokens-1]);
            }else{ # there is no auxilary verb "when did mohammad ali died?"
                $verb = $tokens[1];
                $subject = join(' ',@tokens[2..$#tokens]);
            }
             
          

                my $q = { }; 
                $q->{'q'} = qr/(?i)((?:located (?:in |at )?|placed (?:in )?)[^.,!?]*)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;

                
           
                $q = { }; 
                $q->{'q'} = qr/(?i) address of $subject $verb (\w*(?:, \w*)?)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                

                push @rewrites, $q;
                
                $q = { }; 
                $q->{'q'} = qr/(?i).*?_location_?.*? = ((?:in )\w*(:?\s\w*)?(?:, \w*)?)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                $q->{'add'} = "in"; # add to the answer!
                push @rewrites, $q;

                $q = { }; 
                $q->{'q'} = qr/(?i)location ((?:in )\w*(:?\s\w*)?(?:, \w*)?)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;
               

                

                $q = { }; 
                $q->{'q'} = qr/(?i)is $verb(.*? (?:of )\w*(?:, \w*)?)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;   
                $q = { }; 
                $q->{'q'} = qr/(?i) is.*?((?:in )[^.,!?]*)/; ##this is actually a fallback
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;      
    }
    
    return @rewrites;
}

# fetch wiki page
sub queryWiki{
    my %q = %{shift()};
    my $wikiText;
    my $wiki = WWW::Wikipedia->new(clean_html => 1 );
    my $result = $wiki->search($q{'subject'});
    
    if (defined $result){
        if ( $result->text() ) { 
        $wikiText = $result->text();
        $wikiText =~ s/\R/ /g; 
        return $wikiText;
        }
    }
    
}

# uses regex to match answer pattern with wiki text take two parameter wikiText and Regex
sub matchAnswer{
    my ($rewrite, $text) = @_;
    my %q= %{$rewrite}; # rewrite is a hash
    # process raw text from wikipedia
    my $answer = 0 ;
    # $text= chomp $text;
    # my $qq = $q{'subject'};
    
    my $re = $q{'q'};
    # print $re;
    ($answer) = $text =~ m/$re/gm; 

    return  $answer;

}
# tokenize the question return tokens as a list of string  
# perform preprocessing as well
sub tokenize{
    
    my $q = shift; 
    print $q;
    # extract subject using orthographic information

    my @v = ($q =~ /((?<!^)[A-Z][^\s!?,]+)/g);

    my $subject =  (join " ",@v);
    push @{$question{'subjects'}}, $subject;
    
    $q = ($q =~ s/((?<!^)[A-Z][^\s!?,]+)//rg);
    
    
    my @tokens = ($q =~ /\s?([^,!?\s]+)/g);
    ## type is the first word (when, where, what, who)
    $question{'type'}= lc $tokens[0];

    # extract verb an aux verb for each type of question
    if ($question{'type'} eq 'what'){
        if (exists($auxVerbs{$tokens[1]})){ ##there is an aux verb
            $question{'aux'} = $tokens[1];
            $question{'verb'} = $tokens[$#tokens]; # can be improved
        }else{
            
            $question{'verb'} = $tokens[1];
        }
    }elsif ($question{'type'} eq 'who'){
        
            $question{'verb'} = $tokens[1];
        
    }elsif ($question{'type'} eq 'when'){
        if (exists($auxVerbs{$tokens[1]})){ ##there is an aux verb
            $question{'aux'} = $tokens[1];
            $question{'verb'} = $tokens[$#tokens]; # can be improved
        }else{
            
            $question{'verb'} = $tokens[1];
        }
    }elsif ($question{'type'} eq 'when'){
        if (exists($auxVerbs{$tokens[1]})){ ##there is an aux verb
            $question{'aux'} = $tokens[1];
            $question{'verb'} = $tokens[$#tokens]; # can be improved
        }else{
            
            $question{'verb'} = $tokens[1];
        }
    }

    my @synonyms; 
    #get synonyms
    foreach my $token (@tokens){
        if (!exists($stopwords{lc $token})){ #if not stop word
            my %token_syn; 
            $token_syn{'orginal'} = $token;
            my %syn = %{getSynonyms($token)};
            $token_syn{'synonyms'} = \%syn;
            push @synonyms, \%token_syn;
        }
    }

    push @tokens, $subject;
    $question{'tokens'} = \@tokens;    
    $question{'synonyms'} =  \@synonyms;
    return @tokens; 
  
}

sub getSynonyms {
    my $word = shift;
    my $wn = WordNet::QueryData->new( noload => 1, dir => "./dict/");
    # use wordnet to find synonyms 
    my %synonyms;
    my @t1s = $wn->querySense($word, "syns");
    foreach my $t1 (@t1s){
        my @t2s = $wn->querySense($t1, "syns");
        foreach my $t2 (@t2s){
           my @t3s = $wn->querySense($t2, "syns");
           foreach my  $t3 (@t3s){
               $t3 =~ s/#.+?#.+?//g;
               $synonyms{$t3} = 1;
           }
        }
    }
    return \%synonyms;
        


}



findAnswer("What is the population of the Bahamas?");
findAnswer("What did Vasco Da Gama discover?");

# findAnswer("When was George Washington born?");
findAnswer("Who is Barack Obama?");
findAnswer("Who is Desmond Tutu??");



close $fh;