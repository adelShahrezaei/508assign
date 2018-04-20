use strict;
use warnings;
use Data::Dumper;
use WWW::Wikipedia;
use open ":std", ":encoding(UTF-8)";

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

print Dumper(\%auxVerbs);
# main loop
# while(<STDIN>){

#     my $question; 
    
#     chomp;
#     exit if $_ eq "quit";

#     # $question = $_;
#     $question = "When was George Washington born?" 

   

   

# }


# findAnswer("who is barack obama?");
# findAnswer("who is donald trump?");
# findAnswer("who is jimi hendrix?");

# findAnswer("What is a computer?");
# findAnswer("What is a rifle?");
# findAnswer("What is big bang?");
# findAnswer("What is the moon?");
# findAnswer("who discovered proton?"); FAILED

# findAnswer("What is game theory?");
# findAnswer("when is christmas?");
# findAnswer("when did muhammad ali die?");
# findAnswer("when did john F. kennedy die?");
# findAnswer("when is olympics?");
# findAnswer("when is easter?");
findAnswer("where is paris?");
findAnswer("where is Eiffel Tower?");
findAnswer("where is tehran");
findAnswer("where is new york city");
findAnswer("where is google?");
# findAnswer("Where is sin city?");
close $fh;
# start the pipeline
sub findAnswer{
    
    my $q = shift;
    print $fh "\n\n\n=========================<USER QUESTION> $q\n";
    my @tokens = tokenize($q);
    my @queries = rewriteQuery(@tokens);
    my $wikiText = "";
    # my $qq = $queries[0];
    # print %{@queries[0]}{'q'};
    # my %qhash = %{$qq};
    
   
    # my $wikiText = queryWiki(\$queries[0]);
    # 
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
           print $fh "<ANSWER> $answer\n";
           print "$qhash{'subject'} $qhash{'verb'} $qhash{'add'} $answer.\n";
           last;
       }
    }
    # print (Dumper @tokens);
}
# rewrite the question 
sub rewriteQuery{
    
    my @tokens = @_;
    my $type = $tokens[0]; # type of the question who,what,...
    my $verb;
    my $auxVerb;
    my $article;
    my $subject;
    my @rewrites;
    if (lc $type eq "who"){
            # doesnt work for those names that are like winston churchill = >
            $verb = $tokens[1];
            $subject = join(" ",@tokens[2..$#tokens]);
            
                
                # my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $verb ([^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$verb);
                # push @rewrites, \%q;
                # foreach my $var (@{$verbVariants{$verb}}){
                #     my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
                #     %q = ('q'=>qr/(?i)['].*?['][^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
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

           
                
                # my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $verb ([^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$verb);
                # push @rewrites, \%q;
                # foreach my $var (@{$verbVariants{$verb}}){
                #     my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
                #     %q = ('q'=>qr/(?i)['].*?['][^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
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
             
            # if (exists $articlesH{$tokens[2]}){ ## there is an article a. an, the
            #     $article = $tokens[2];
            #     $subject = join(" ",@tokens[3..$#tokens]);            
            # }else{ #there is no article 
            #     $subject = join(" ",@tokens[2..$#tokens]);
            # }

           
                
                # my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $verb ([^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$verb);
                # push @rewrites, \%q;
                # foreach my $var (@{$verbVariants{$verb}}){
                #     my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
                #     %q = ('q'=>qr/(?i)['].*?['][^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
              
                my $q = { }; 
                $q->{'q'} = qr/(?i) $verb ((?:before |after |on |during )[^.]*)[.,!?]/;
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


                if (exists $verbVariants{$verb}){
                    foreach my $var (@{$verbVariants{$verb}}){
                        my $q = { }; 
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
                
                print Dumper(\@rewrites);
                

                

    }elsif (lc $type eq "where"){ # when question e.g. "where is paris?"
            #check for auxiliary verb
            
            if (exists($auxVerbs{$tokens[1]})){# there is an auxilary verb "when did mohammad ali died?"
                $auxVerb = $tokens[1];
                $verb = $tokens[$#tokens];
                
                $subject = join(' ',@tokens[2..$#tokens-1]);
            }else{ # there is no auxilary verb "when did mohammad ali died?"
                $verb = $tokens[1];
                $subject = join(' ',@tokens[2..$#tokens]);
            }
             
            # if (exists $articlesH{$tokens[2]}){ ## there is an article a. an, the
            #     $article = $tokens[2];
            #     $subject = join(" ",@tokens[3..$#tokens]);            
            # }else{ #there is no article 
            #     $subject = join(" ",@tokens[2..$#tokens]);
            # }

           
                
                # my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $verb ([^.]*)[.,!?]/ , 'subject'=>$subject, 'verb'=>$verb);
                # push @rewrites, \%q;
                # foreach my $var (@{$verbVariants{$verb}}){
                #     my %q = ('q'=>qr/(?i)[']?$subject[']?[^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;
                #     %q = ('q'=>qr/(?i)['].*?['][^.]* $var ([^.]*)[.,!?]/, 'subject'=>$subject, 'verb'=>$verb);
                    
                #     push @rewrites, \%q;

                my $q = { }; 
                $q->{'q'} = qr/(?i).*?_location_?.*? = (\w* (?:, \w*)?)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                $q->{'add'} = "in"; # add to the answer!
                push @rewrites, $q;

                my $q = { }; 
                $q->{'q'} = qr/(?i)location ((?:in ).*(?:, \w*)?)/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;
                my $q = { }; 
                $q->{'q'} = qr/(?i) $verb.*?((?:in |located in |placed in  )\w*(?:, \w*)?)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;

                

                my $q = { }; 
                $q->{'q'} = qr/(?i)is $verb(.*? (?:of )\w*(?:, \w*)?)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;

                my $q = { }; 
                $q->{'q'} = qr/(?i)((?:in |located in |placed in  )\w*(?:, \w*)?)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                
                push @rewrites, $q;

                
           
                $q = { }; 
                $q->{'q'} = qr/(?i) address of $subject $verb (\w*(?:, \w*)?)[.,!?]/;
                $q->{'subject'} = $subject;
                $q->{'verb'} = $verb;
                

                push @rewrites, $q;

                # $q = { }; 
                # $q->{'q'} = qr/(?i)((?:before |after |on |during )(?:january |february |march |april 
                # |may |june |july |august |september |november |december )(?:[0-9]{1,2})?(?:, [0-9]{4})?)/;
                # $q->{'subject'} = $subject;
                # $q->{'verb'} = $verb;
                
                
                # push @rewrites, $q;


                # if (exists $verbVariants{$verb}){
                #     foreach my $var (@{$verbVariants{$verb}}){
                #         my $q = { }; 
                #         $q->{'q'} = qr/(?i) $var ((?:before |after |on |during )[^.]*)[.,!?]/;
                #         $q->{'subject'} = $subject;
                #         $q->{'verb'} = $var;

                #         push @rewrites, $q;

                #         $q = { }; 
                #         $q->{'q'} = qr/(?i) date of the $subject $var ((?:before |after |on |during | )[^.]*)[.,!?]/;
                #         $q->{'subject'} = $subject;
                #         $q->{'verb'} = $var;


                #         push @rewrites, $q;
                        
                        
                #     }
                    
                
                # }
                
                print Dumper(\@rewrites);
                

                

    }
    
    return @rewrites;
}

sub queryWiki{
    my %q = %{shift()};
    
    my $wiki = WWW::Wikipedia->new(clean_html => 1 );
    my $result = $wiki->search($q{'subject'});
    
    
    if ( $result->text() ) { 
      return $result->text();
    }
    
}

sub matchAnswer{
    my ($rewrite, $text) = @_;
    my %q= %{$rewrite}; # rewrite is a hash
    # process raw text from wikipedia
    my $answer = 0 ;
    # $text= lc $text;
    # my $qq = $q{'subject'};
    
    my $re = $q{'q'};
    ($answer) = $text =~ m/$re/gm; 

    return  $answer;

}
# tokenize the question return tokens as a list of string  
# TODO use stop list 
sub tokenize{

    my $q = shift; 
    my @tokens = ($q =~ /\s?([^,!?\s]+)/g);
    return @tokens; 
      
}