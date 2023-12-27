# NexteraStyleIndexPrimers
## v1
Primers containing 8-mer length index bases.
## v2 for combinatorial dual indexing
All primers contain 8-mer length index bases for combinatorial dual indexing. 192 forward index primers and 288 reverse index primers are available. A set of forward and reverse index primers for a 96-well plate contain 8 and 12 primers, respectively. 8 forward indices conrain 1 to 3 each bases at the same positions. 12 reverse indices contain 2 to 4 each bases at the same positions.
## v3 for unique dual indexing
All primers contain 10-mer length index bases for unique dual indexing. 3840 forward index primers and 3840 reverse index primers are available. A set of index primers for a 96-well plate contain 96 primers. 96 indices contain 12 to 48 each bases at the same positions. Both M (A or C) and K (G or T) bases are controlled within a range of 39 to 57 at the same positions.
## v4 for unique dual indexing
All primers contain 12-mer length index bases for unique dual indexing. 30720 forward index primers and 30720 reverse index primers are available. A set of index primers for a 384-well plate contain 384 primers. 384 indices contain 64 to 128 each bases at the same positions. Both M (A or C) and K (G or T) bases are controlled within a range of 154 to 230 at the same positions.
## How to generate
```
# Install Math::Random::MT::Auto
sudo -HE sh -c "yes '' | cpan -fi Math::Random::MT::Auto"
# Open and edit first 4 lines of makeindex.pl
perl -i -npe 's/^my \$length = \d+;/my \$length = 8;/; s/^my \$mindiff = \d+;/my \$mindiff = 3;/; s/^my \$maxgc = 0\.\d+;/my \$maxgc = 0.62;/; s/^my \$mingc = 0\.\d+;/my \$mingc = 0.37;/;' makeindex.pl
# Run makeindex.pl
perl makeindex.pl > index-v2.txt
# Open and edit first 5 lines of selectindex-v2.pl
perl -i -npe 's/^my \$maxindex = \d+;/my \$maxindex = 192;/; s/^my \$unit = \d+;/my \$unit = 8;/; s/^my \$min = \d+;/my \$min = 1;/; s/^my \$max = \d+;/my \$max = 3;/;' selectindex-v2.pl
# Select forwardindex
perl selectindex-v2.pl index-v2.txt > forwardindex-v2.txt
# Make forwardprimer
perl makeforwardprimer.pl forwardindex-v2.txt > forwardprimer-v2.txt
# Open and edit first 5 lines of selectindex-v2.pl
perl -i -npe 's/^my \$maxindex = \d+;/my \$maxindex = 288;/; s/^my \$unit = \d+;/my \$unit = 12;/; s/^my \$min = \d+;/my \$min = 2;/; s/^my \$max = \d+;/my \$max = 4;/;' selectindex-v2.pl
# Select reverseindex
perl selectindex-v2.pl index-v2.txt > reverseindex-v2.txt
# Make reverseprimer
perl makereverseprimer.pl reverseindex-v2.txt > reverseprimer-v2.txt
# Make IndexKit
mkdir -p Illumina\ Experiment\ Manager/IndexKits
perl makeindexkit-iem.pl forwardprimer-v2.txt reverseprimer-v2.txt Illumina\ Experiment\ Manager/IndexKits/Tanabe-v2-Nextera-IndexKit.txt
mkdir -p BaseSpace
perl makeindexkit-bs.pl forwardprimer-v2.txt reverseprimer-v2.txt BaseSpace/Tanabe-v2-Nextera-IndexKit.tsv
```
```
# Install Math::Random::MT::Auto
sudo -HE sh -c "yes '' | cpan -fi Math::Random::MT::Auto"
# Open and edit first 4 lines of makeindex.pl
perl -i -npe 's/^my \$length = \d+;/my \$length = 10;/; s/^my \$mindiff = \d+;/my \$mindiff = 3;/; s/^my \$maxgc = 0\.\d+;/my \$maxgc = 0.51;/; s/^my \$mingc = 0\.\d+;/my \$mingc = 0.39;/;' makeindex.pl
# Run makeindex.pl
perl makeindex.pl > index-v3.txt
# Select forwardindex
perl selectindex-v3.pl index-v3.txt > forwardindex-v3.txt
# Make forwardprimer
perl makeforwardprimer.pl forwardindex-v3.txt > forwardprimer-v3.txt
# Make CSV files for IDT
perl makecsv-v3.pl forwardprimer-v3.txt forwardprimer-v3
# Select reverseindex
perl selectindex-v3.pl index-v3.txt > reverseindex-v3.txt
# Make reverseprimer
perl makereverseprimer.pl reverseindex-v3.txt > reverseprimer-v3.txt
# Make CSV files for IDT
perl makecsv-v3.pl reverseprimer-v3.txt reverseprimer-v3
# Convert CSV to XLSX
for f in `ls *primer-v3_??.csv | grep -o -P '^[^\.]+'`; do csv2xlsx -s $f -o $f.xlsx $f.csv; done
# Make IndexKit
mkdir -p Illumina\ Experiment\ Manager/IndexKits
perl makeindexkit-iem.pl forwardprimer-v3.txt reverseprimer-v3.txt Illumina\ Experiment\ Manager/IndexKits/Tanabe-v3-Nextera-IndexKit.txt
mkdir -p BaseSpace
perl makeindexkit-bs.pl forwardprimer-v3.txt reverseprimer-v3.txt BaseSpace/Tanabe-v3-Nextera-IndexKit.tsv
```
```
# Install Math::Random::MT::Auto
sudo -HE sh -c "yes '' | cpan -fi Math::Random::MT::Auto"
# Open and edit first 4 lines of makeindex.pl
perl -i -npe 's/^my \$length = \d+;/my \$length = 12;/; s/^my \$mindiff = \d+;/my \$mindiff = 3;/; s/^my \$maxgc = 0\.\d+;/my \$maxgc = 0.51;/; s/^my \$mingc = 0\.\d+;/my \$mingc = 0.39;/;' makeindex.pl
# Run makeindex.pl
perl makeindex.pl > index-v4.txt
# Select forwardindex
perl selectindex-v4.pl index-v4.txt > forwardindex-v4.txt
# Make forwardprimer
perl makeforwardprimer.pl forwardindex-v4.txt > forwardprimer-v4.txt
# Make CSV files for IDT
perl makecsv-v4.pl forwardprimer-v4.txt forwardprimer-v4
# Select reverseindex
perl selectindex-v4.pl index-v4.txt > reverseindex-v4.txt
# Make reverseprimer
perl makereverseprimer.pl reverseindex-v4.txt > reverseprimer-v4.txt
# Make CSV files for IDT
perl makecsv-v4.pl reverseprimer-v4.txt reverseprimer-v4
# Convert CSV to XLSX
for f in `ls *primer-v4_??.csv | grep -o -P '^[^\.]+'`; do csv2xlsx -s $f -o $f.xlsx $f.csv; done
# Make IndexKit
mkdir -p Illumina\ Experiment\ Manager/IndexKits
perl makeindexkit-iem.pl forwardprimer-v4.txt reverseprimer-v4.txt Illumina\ Experiment\ Manager/IndexKits/Tanabe-v4-Nextera-IndexKit.txt
mkdir -p BaseSpace
perl makeindexkit-bs.pl forwardprimer-v4.txt reverseprimer-v4.txt BaseSpace/Tanabe-v4-Nextera-IndexKit.tsv
```
