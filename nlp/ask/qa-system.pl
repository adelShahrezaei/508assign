use strict;
use warnings;
use Data::Dumper;
use WWW::Wikipedia;


our %verbVariants = ('is' => ['was'],
                 'was'=> ['is'], 
);

# main loop
# while(<STDIN>){

#     my $question; 
    
#     chomp;
#     exit if $_ eq "quit";

#     # $question = $_;
#     $question = "When was George Washington born?" 

   

   

# }
findAnswer("who is maynard?");
findAnswer("when jimi hendrix was born");
findAnswer("What is an asshole?");
findAnswer("Where is sin city?");

# start the pipeline
sub findAnswer{
    
    my $q = shift;
    my @tokens = tokenize($q);
    my @queries = rewriteQuery(@tokens);
    
    foreach my $query (@queries){
        
        queryWiki(\%{$query});
    }
    # print (Dumper @tokens);
}
# rewrite the question 
sub rewriteQuery{
    
    my @tokens = @_;
    my $type = $tokens[0]; # type of the question who,what,...
    my $verb;
    my $modalVerb;
    my $subject;
    my @rewrites;
    if ($type eq "who"){

            $verb = $tokens[1];
            $subject = join(" ",@tokens[2..$#tokens]);
            if (exists $verbVariants{$verb}){

                my %q = ('q'=>"$subject $verb", 'subject'=>$subject);
                push @rewrites, \%q;
                foreach my $var (@{$verbVariants{$verb}}){
                    my %q = ('q'=>"$subject $verb", 'subject'=>$subject);
                    push @rewrites, \%q;
                }
                    
                
            }

    }
    return @rewrites;
}

sub queryWiki{
    my %q = %{shift()};
    
    my $wiki = WWW::Wikipedia->new();
    my $result = $wiki->search($q{'subject'});
    
    
    if ( $result->text() ) { 
      print $result->text();
    }
    return $result->text();

}
# tokenize the question return tokens as a list of string  
# TODO use stop list 
sub tokenize{

    my $q = shift; 
    my @tokens = ($q =~ /\s?([^,!?\s]+)/g);
    return @tokens; 
      
}