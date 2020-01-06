my @indexseq;
my $maxindex = 3840;
my $unit = 96;
my $min = 12;
my $max = 48;
my $minmkratio = 0.8 / 1.2;
my $maxmkratio = 1.2 / 0.8;

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
	if (&checkCompositionAndMKRatio(@select)) {
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

sub checkCompositionAndMKRatio {
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
		my $mkratio = ($composition[$i]{'A'} + $composition[$i]{'C'}) / ($composition[$i]{'G'} + $composition[$i]{'T'});
		if ($mkratio < $minmkratio || $mkratio > $maxmkratio) {
			return(0);
		}
	}
	return(1);
}

sub checkMKRatio {
	my @select = @_;
	#print(STDOUT "@select\n");
	my @mkratio;
	foreach my $indexseq (@select) {
		my @base = $indexseq =~ /[ACGT]/g;
		for (my $i = 0; $i < scalar(@base); $i ++) {
			if ($base[$i] eq 'A' || $base[$i] eq 'C') {
				$mkratio[$i]{'M'} ++;
			}
			elsif ($base[$i] eq 'G' || $base[$i] eq 'T') {
				$mkratio[$i]{'K'} ++;
			}
		}
	}
	for (my $i = 0; $i < scalar(@mkratio); $i ++) {
		my $mkratio = $mkratio[$i]{'M'} / $mkratio[$i]{'K'};
		if ($mkratio < $minmkratio || $mkratio > $maxmkratio) {
			return(0);
		}
	}
	return(1);
}
