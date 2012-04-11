#!/usr/bin/perl

my $file = '/tmp/parlGCsource.html';

use strict;
use HTML::Query 'Query';
use HTML::Element;
use LWP::Simple;
my $URL = 'http://www.parl.gc.ca/About/Parliament/FederalRidingsHistory/hfer.asp?Language=E&Search=Gres&genElection=36&ridProvince=0&submit1=Search';

getstore($URL, $file);

print "File saved\n";

open(FILE, $file) or die $!;

print "Slurping data\n";
my @content = <FILE>;

close(FILE);


print "Processing data";
#For each line
my $i=0;
my %results;
for(@content) {
	my $line = $_;
	
	#If the line is a riding
	if($line =~ m/class='rid'/) {
		my $q = Query(text=>"$line");

		# Isolate the content of the a tag and print it
		# q is an 'engine' to query dom elements of an HTML document
		my @es = $q->query('a')->get_elements();
		for (@es) {
			my @t = $_->content_list();
			for(@t) {
				$results{ $i } = $_;
				print $_, "\n";
			}
		}
		$i++;

	}

}


print 'Done.', "\n";
