use strict;
my $forwardprimerfile;
my $reverseprimerfile;
my $outputfile;
my $inputhandle;
my $outputhandle;
for (my $i = 0; $i < scalar(@ARGV); $i ++) {
	if ($i == 0) {
		if (-e $ARGV[$i]) {
			$forwardprimerfile = $ARGV[$i];
		}
		else {
			&errorMessage(__LINE__, "The input file does not exist.");
		}
	}
	elsif ($i == 1) {
		if (-e $ARGV[$i]) {
			$reverseprimerfile = $ARGV[$i];
		}
		else {
			&errorMessage(__LINE__, "The input file does not exist.");
		}
	}
	elsif ($i == 2) {
		if (-e $ARGV[$i]) {
			&errorMessage(__LINE__, "Output file already exists.");
		}
		$outputfile = $ARGV[$i];
	}
	elsif ($i > 2) {
		&errorMessage(__LINE__, "Too many arguments are given.");
	}
}
if (!$forwardprimerfile || !$reverseprimerfile || !$outputfile) {
	&errorMessage(__LINE__, "Invalid options.");
}
my $name = $outputfile;
$name =~ s/\.[^\.]+$//;
unless (open($outputhandle, "> $outputfile")) {
	&errorMessage(__LINE__, "Cannot write \"$outputfile\".");
}
print($outputhandle "[Version]\n1\n[Name]\n$name\n[PlateExtension]\nnexxtv2\n[Settings]\n[I7]\n");
unless (open($inputhandle, "< $reverseprimerfile")) {
	&errorMessage(__LINE__, "Cannot read \"$reverseprimerfile\".");
}
while (<$inputhandle>) {
	if (/^(R\d+)-([ACGT]+)\t/) {
		print($outputhandle $1 . "\t" . reversecomplement($2) . "\n");
	}
}
close($inputhandle);
print($outputhandle "[I5]\n");
unless (open($inputhandle, "< $forwardprimerfile")) {
	&errorMessage(__LINE__, "Cannot read \"$forwardprimerfile\".");
}
while (<$inputhandle>) {
	if (/^(F\d+)-([ACGT]+)\t/) {
		print($outputhandle $1 . "\t" . $2 . "\n");
	}
}
close($inputhandle);
close($outputhandle);

sub reversecomplement {
	my @temp = split('', $_[0]);
	my @seq;
	foreach my $seq (reverse(@temp)) {
		$seq =~ tr/ACGTMRYKVHDBacgtmrykvhdb/TGCAKYRMBDHVtgcakyrmbdhv/;
		push(@seq, $seq);
	}
	return(join('', @seq));
}

sub errorMessage {
	my $lineno = shift(@_);
	my $message = shift(@_);
	print(STDERR "ERROR!: line $lineno\n$message\n");
	print(STDERR "If you want to read help message, run this script without options.\n");
	exit(1);
}
