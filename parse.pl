#!/usr/bin/env perl
#
# USAGE:
# ./parse.pl cookbook_import_pages_current.xml > cormat.txt
#
use strict; use warnings;
use feature 'say';


# counters
my @text;
my $intxtblk=0;

# make lowercase and replace nonword chars with _
# fix some common errors/merge similiar items
# see tr '\t' '\n' < ingredient.list|sort |uniq -c |sort -n | less
# -- maybe should be in mkmat.pl so we dont mess with data here
sub linkqa {
  $_=lc( shift );
  s/\W/_/g; 

  s/hass_avocado/avocado/;

  s/egg_whites/egg_white/;
  s/egg_yolks/egg_yolk/;

  s/baker_s_yeast/yeast/;
  s/active_dry_yeast/yeast/;
  # also nutritional, fresh, and instant -- left alone
  return($_);
}
# find all the [[link|text]] and extract the 'link' bit
# use linkqa to change values; filter out file: links
sub extractLinks {
  my $txt=shift;
  my @links;
  while($txt =~ m/\[\[([^\|\]]*)\|?.*\]\]/g) { push @links, linkqa($1) }
  
  return([ grep {!/^file/} @links ]);
}

# build "correlation" symetic matrix
# diagonal is total count of item (ingrediant) -- used to sort later

sub cleantext {
  my $txt=join("\n",@text);
  say join "\t", @{ (extractLinks($1) ) } if $txt =~ /=== Ingredients ===(.*?)^==/sm;
  # reset counters
  $intxtblk=0;
  @text=();
}

while(<>){
  if(/<text/) {
    $intxtblk=1;
  } elsif (m:</text:) {
    cleantext();
  }
  push @text, $_ if $intxtblk;
}

