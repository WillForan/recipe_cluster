#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';



my %mat;
sub buildmat {
 my @list=@{ (shift) };
 for my $k1 (@list) {
   for my $k2 (@list) {
     $mat{$k1}{$k2}+=1;
     $mat{$k2}{$k1}+=1;
  }
 }
}

while(<>){
 chomp;
 buildmat([split(/\t/)]);
}

my @keys=sort { $mat{$b}{$b} <=> $mat{$a}{$a} } (keys %mat);

say "\t",join("\t",@keys);
for my $k1 (@keys) {
  print $k1;
  for my $k2 (@keys) {
    #my $normed=sprintf "%0.2f",$mat{$k1}{$k2}/$mat{$k1}{$k1};
    print "\t".($mat{$k1}{$k2}||0);
  }
  print "\n";
}
