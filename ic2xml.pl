#!/usr/bin/perl -w

use strict;
use Data::Dumper;

print "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
print "<Router>\n";

my $tree={};
my $rank=0; # relative order of nodes

sub mkpath {
	my $path = shift;
	my @components = split /\./, $path; # break path into individual components
	map { $_ = "X$_" if (m/^\d+$/og); } @components; # Modify components that are only numeric
	$path=''; # clear path 
	my $node = $tree; # start from root of tree
	foreach my $component (@components) {
		unless (exists $node->{$component}) {
			$node->{$component}->{rank}= ++$rank; 
		}
		$node = $node->{$component};
	}
	return $node;
}

<>;<>;<>; # ignore three first lines
my $context_node;
while (defined(my $line=<>)) {
	chomp($line);
	$line =~ s/^\s+//og; # kill heading spaces
	if ($line =~  m/^#/og) { 
#		print "IGNORED:$line\n";
		next;
	}
 	if ($line =~ m/^\s+$/og) {
		###print "IGNORED:$line\n";
		next;
	}	

	#my @fields = split /\s+/, $line;
	$line =~ s/&/&amp;/og;
	$line =~ m/(A|N)\s+([A-Za-z0-9._]+)\s*(\'?[A-Za-z0-9\._ \t,;:#"=&@\-\+\?\/]*\'?)?/og;
	my ($type, $name, $value) = ($1, $2, $3); 
	if ($type eq 'N') {
		$value = $name unless (defined($value)); # On 2 occurrences, short nodes names appear (no path associated)
		$context_node =  mkpath($value);
	} else {
		my $fields = $context_node->{fields};
		unless (defined ($fields)) {
			$fields = [];
			$context_node->{fields} = $fields;
		}
		my %h;
		$h{$name}=$value;
		push(@$fields, \%h);
	}
	
}

#print "\n\n\n\n\n\n" . Dumper($tree) . "\n";

sub traverse_tree {
	my $node = shift;
	my $level = shift;
	my $node_func = shift;
	my $attr_func = shift;

#	print "node: $node\n";
#	print "node_func: $node_func\n";
#	print "attr_func: $node_func\n";

	my @keys;
	#eval { @keys = sort { $node->{$a}->{rank} <=> $node->{$b}->{rank} } keys %$node; };
	@keys = keys %$node;
#	print "count: " . scalar(@keys) . "\n";
#	print join '/', @keys; print "\n";

	my $stub = '  ' x $level;
	foreach my $key (@keys) {
		unless ($key eq 'rank' or $key eq 'fields') {
			print "${stub}<$key";

			my $val = $node->{$key}->{fields}; # List attributes
			if (defined($val)) {
				my $hasspace;
				my @attrs = @$val; 
				foreach my $attr (@attrs) {
					print " " unless ($hasspace);
					$hasspace=1;
					my ($k,$v) = each %$attr;				
					print "${k}=${v} ";
				}
			}
			print "> \n";
			my $next_node = $node->{$key};
			#print "next_node: $next_node\n";
			traverse_tree($next_node, $level+1, $node_func, $attr_func);
			print "${stub}</$key>\n";		
		}
		next if ($key eq 'fields' or $key eq 'rank');
	}
}

#print Dumper($tree);

traverse_tree ($tree, 0, undef,undef);
print "</Router>\n";
