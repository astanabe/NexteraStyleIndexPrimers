my @indexseq;
my $maxindex = 8;
my $unit = 4;
my $min = 1;
my $max = 1;

while (<>) {
	if (/[ACGT]+/) {
		push(@indexseq, $&);
		#print($& . "\n");
	}
}

my $seed;
my $gen;
my $out = 0;

unless ($seed) {
	$seed = time^$$;
}

eval "use Math::Random::MT::Auto";
if ($@) {
	eval "use Math::Random::MT::Perl";
	if ($@) {
		print(STDERR "No module\n");
		exit(1);
	}
	else {
		$gen = Math::Random::MT::Perl->new($seed);
	}
}
else {
	$gen = Math::Random::MT::Auto->new();
	$gen->srand($seed);
}

while ($out < $maxindex) {
	my @select;
	for (my $i = 0; $i < $unit; $i ++) {
		$select[$i] = splice(@indexseq, int($gen->rand(scalar(@indexseq))), 1);
	}
	if (&checkComposition(@select)) {
		print(STDOUT join("\n", @select) . "\n\n");
		$out += $unit;
	}
	else {
		push(@indexseq, @select);
	}
}

sub checkComposition {
	my @select = @_;
	#print(STDOUT "@select\n");
	my @composition;
	foreach my $indexseq (@select) {
		my @base = $indexseq =~ /[ACGT]/g;
		for (my $i = 0; $i < scalar(@base); $i ++) {
			$composition[$i]{$base[$i]} ++;
		}
	}
	for (my $i = 0; $i < scalar(@composition); $i ++) {
		foreach my $base ('A', 'C', 'G', 'T') {
			if ($composition[$i]{$base} < $min || $composition[$i]{$base} > $max) {
				return(0);
			}
		}
	}
	return(1);
}
