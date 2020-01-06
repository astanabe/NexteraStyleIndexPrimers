use strict;
my $inputfile;
my $outprefix;
my $inputhandle;
my $outputhandle;
my @names;
my %sequences;
for (my $i = 0; $i < scalar(@ARGV); $i ++) {
	if ($i == 0) {
		if (-e $ARGV[$i]) {
			$inputfile = $ARGV[$i];
		}
		else {
			&errorMessage(__LINE__, "The input file does not exist.");
		}
	}
	elsif ($i == 1) {
		while (glob("$ARGV[$i]*.*")) {
			&errorMessage(__LINE__, "Output file already exists.");
		}
		$outprefix = $ARGV[$i];
	}
	elsif ($i > 1) {
		&errorMessage(__LINE__, "Too many arguments are given.");
	}
}
if (!$outprefix) {
	$outprefix = $inputfile;
	$outprefix =~ s/.[^\.]+$//;
}
unless (open($inputhandle, "< $inputfile")) {
	&errorMessage(__LINE__, "Cannot open input file.");
}
while (<$inputhandle>) {
	s/\r?\n?$//;
	my @temp = split(/\t/, $_);
	if ($temp[0] && $temp[1]) {
		push(@names, $temp[0]);
		$sequences{$temp[0]} = $temp[1];
	}
	else {
		&errorMessage(__LINE__, "The input file is invalid.");
	}
}
close($inputhandle);
my $temp = 0;
for (my $i = 0; $i < scalar(@names) / 96; $i ++) {
	my $outputfile = $outprefix . '_' . sprintf("%02d", $i + 1) . '.csv';
	if (-e $outputfile) {
		&errorMessage(__LINE__, "Output file already exists.");
	}
	else {
		unless (open($outputhandle, "> $outputfile")) {
			&errorMessage(__LINE__, "Cannot write \"$outputfile\".");
		}
		print($outputhandle "Well Position,Name,Sequence\n");
		foreach my $row ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H') {
			foreach my $col (1 .. 12) {
				if ($names[$temp] && $sequences{$names[$temp]}) {
					print($outputhandle "$row$col,$names[$temp],$sequences{$names[$temp]}\n");
				}
				else {
					print($outputhandle "$row$col,,\n");
				}
				$temp ++;
			}
		}
		close($outputhandle);
	}
}

sub errorMessage {
	my $lineno = shift(@_);
	my $message = shift(@_);
	print(STDERR "ERROR!: line $lineno\n$message\n");
	print(STDERR "If you want to read help message, run this script without options.\n");
	exit(1);
}
