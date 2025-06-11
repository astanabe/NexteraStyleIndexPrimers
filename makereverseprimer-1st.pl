my @indexseq;

while (<>) {
	if (/[ACGT]+/) {
		push(@indexseq, $&);
	}
}

my $maxn = scalar(@indexseq);
my $length = length($maxn);

for (my $i = 1; $i <= $maxn; $i ++) {
	printf(STDOUT "R%0*d", $length, $i);
	print(STDOUT '-' . $indexseq[($i - 1)] . "\t" . 'GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG' . $indexseq[($i - 1)] . '[reverse specific primer]' . "\n");
}
