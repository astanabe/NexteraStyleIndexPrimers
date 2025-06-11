my $length = 8;
my $mindiff = 3;
my $maxgc = 0.62; # 4
my $mingc = 0.37; # 3
my @indexseq;

&addbase('A');
&addbase('T');
&addbase('G');
&addbase('C');

sub addbase {
	my @tempseq;
	push(@tempseq, @_);
	if (scalar(@tempseq) == $length) {
		my $temp = join('', @tempseq);
		if (!checkGC($temp) && !&checkduplicate($temp)) {
			print(STDOUT "$temp\n");
			push(@indexseq, $temp);
		}
	}
	elsif ($tempseq[-1] eq 'A' && $tempseq[-2] eq 'T' || $tempseq[-1] eq 'T' && $tempseq[-2] eq 'A') {
		foreach my $nextbase ('C', 'G') {
			&addbase(@tempseq, $nextbase);
		}
	}
	elsif ($tempseq[-1] eq 'C' && $tempseq[-2] eq 'G' || $tempseq[-1] eq 'G' && $tempseq[-2] eq 'C') {
		foreach my $nextbase ('A', 'T') {
			&addbase(@tempseq, $nextbase);
		}
	}
	elsif ($tempseq[-1] ne $tempseq[-2]) {
		foreach my $nextbase ('A', 'C', 'G', 'T') {
			&addbase(@tempseq, $nextbase);
		}
	}
	else {
		if ($tempseq[-1] eq 'A') {
			foreach my $nextbase ('C', 'G') {
				&addbase(@tempseq, $nextbase);
			}
		}
		elsif ($tempseq[-1] eq 'C') {
			foreach my $nextbase ('A', 'T') {
				&addbase(@tempseq, $nextbase);
			}
		}
		elsif ($tempseq[-1] eq 'G') {
			foreach my $nextbase ('A', 'T') {
				&addbase(@tempseq, $nextbase);
			}
		}
		elsif ($tempseq[-1] eq 'T') {
			foreach my $nextbase ('C', 'G') {
				&addbase(@tempseq, $nextbase);
			}
		}
	}
}

sub checkGC {
	my $indexseq = shift(@_);
	my $gc = 0;
	for (my $i = 0; $i < $length; $i ++) {
		if (substr($indexseq, $i, 1) eq 'G' || substr($indexseq, $i, 1) eq 'C') {
			$gc ++;
		}
	}
	$gc /= $length;
	if ($gc > $maxgc || $gc < $mingc) {
		return(1);
	}
	else {
		return(0);
	}
}

sub checkduplicate {
	my $indexseq1 = shift(@_);
	my $dup = 0;
	foreach my $indexseq2 (@indexseq) {
		my $diff = 0;
		for (my $i = 0; $i < $length; $i ++) {
			if (substr($indexseq1, $i, 1) ne substr($indexseq2, $i, 1)) {
				$diff ++;
			}
		}
		if ($diff < $mindiff) {
			$dup = 1;
			last;
		}
	}
	return($dup);
}
