#!/usr/bin/perl

# read list of colors from flightmap.mapcss
%colors = ();
open $f, "<flightmap.mapcss";
while (<$f>) {
  if (m/(#[0-9a-f]{6,8})/i) {
    $colors{$1} = 1;
  }
}
close($f);
@colors = keys(%colors);

# now process flightmap-template.mapnik and replace COLOR placeholders by colors
open $f, "<flightmap-template.mapnik";
open $r, ">flightmap.mapnik";
while (<$f>) {
  if (m/^# FOR COLORS (.*)$/) {
    $repl_var = $1;
    $t = "";
    while (<$f>) {
      if (m/^# END/) {
	last;
      }

      $t .= $_;
    }

    foreach (@colors) {
      my $u = $t;
      $u =~ s/$repl_var/$_/g;
      print $r $u;
    }

  }
  else {
    print $r $_;
  }
}
close($r);
close($f);
