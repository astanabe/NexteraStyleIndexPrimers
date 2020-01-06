my @indexseq;
my $maxindex = 192; # 192 for forward, 288 for reverse
my $unit = 8; # 8 for forward, 12 for reverse
my $min = 1; # 1 for forward, 2 for reverse
my $max = 3; # 3 for forward, 4 for reverse

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
