

use Data::Dumper;
use WordNet::QueryData;
use List::Permutor;

# sub getSynonyms {
#     my $word = shift;
#     my $wn = WordNet::QueryData->new( noload => 1, dir => "./dict/");
#     # use wordnet to find synonyms 
#     my %synonyms;
#     my @t1s = $wn->querySense($word, "syns");
#     foreach $t1 (@t1s){
#         my @t2s = $wn->querySense($t1, "syns");
#         foreach $t2 (@t2s){
#            my @t3s = $wn->querySense($t2, "syns");
#            for $t3 (@t3s){
#                $t3 =~ s/#.+?#.+?//g;
#                $synonyms{$t3} = 1;
#            }
#         }
#     }
#     return \%synonyms;
        


# }

sub genPermutation{
    my @words = @_;
    
    my $perm = new List::Permutor @words;
    while (my @set = $perm->next){
      print join ' ',@set;
      print "\n";
    }

}
genPermutation(qw/ this is test /);

# print (Dumper(\%{getSynonyms("phone")}));
# $rec = {};
    
# $rec->{'q'} = 'big';
# push @AoH, $rec;


# $rec ={ };
# $rec->{'q'} = 'short';

# push @AoH, $rec;

# print Dumper(\@AoH);

# $x = "when was George Washington born?";
#     $x = $x =~ s/([A-Z][^\s]+\s)+//r;
# print $x;