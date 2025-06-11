# NexteraStyleIndexPrimers
## v1
Primers containing 8-mer length index bases.
## v2 for combinatorial dual indexing (up to 2304-plex)
All primers contain 8-mer length index bases for combinatorial dual indexing. 192 forward index primers and 288 reverse index primers are available. A set of forward and reverse index primers for a 96-well plate contain 8 and 12 primers, respectively. 8 forward indices conrain 1 to 3 each base at the same positions. 12 reverse indices contain 2 to 4 each base at the same positions. The forward X-set should be paired with the reverse set of the same letter. If different letter set combination is allowed, 55296-plex can be achieved.
## v3 for unique dual indexing (up to 3840-plex)
All primers contain 10-mer length index bases for unique dual indexing. 3840 forward index primers and 3840 reverse index primers are available. A set of index primers for a 96-well plate contain 96 primers. 96 indices contain 12 to 48 each base at the same positions. The numbers of M (A or C) and K (G or T) bases are controlled within a range of 39 to 57 at the same positions in a set. The forward N-set must be paired with the reverse set of the same number.
## v4 for unique dual indexing (up to 30720-plex)
All primers contain 12-mer length index bases for unique dual indexing. 30720 forward index primers and 30720 reverse index primers are available. A set of index primers for a 384-well plate contain 384 primers. 384 indices contain 64 to 128 each base at the same positions. The numbers of M (A or C) and K (G or T) bases are controlled within a range of 154 to 230 at the same positions in a set. The forward N-set must be paired with the reverse set of the same number.
## v5 for quadruple indexing (up to 3072-plex for amplicon sequencing)
Special index primers for amplicon sequencing. 2-step PCR library preparation is required. 8-plex unique dual indexing primers for 1st-PCR and 384-plex unique dual indexing primers for 2nd-PCR are available. These 1st- and 2nd-PCR indices can be applied in combination. Thus, 8 x 384 = 3072-plex sequencing can be conducted. The indices for 1st- and 2nd-PCR are 6-mer and 8-mer length, respectively. A set of 1st-PCR primers for tubes contain 4 primers. 4 indices contain 1 each base at the same positions. A set of 2nd-PCR index primers for a 96-well plate contain 12 primers. 12 indices contain 1 to 5 each base at the same positions. The numbers of M (A or C) and K (G or T) bases are fixed to 6 at the same positions in a set. The forward N-set must be paired with the reverse set of the same number. The sequence data cannot be demultiplexed by Illumina's bcl2fastq or BCL Convert.
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
```
# Install Math::Random::MT::Auto
sudo -HE sh -c "yes '' | cpan -fi Math::Random::MT::Auto"
# Open and edit first 4 lines of makeindex.pl
perl -i -npe 's/^my \$length = \d+;/my \$length = 8;/; s/^my \$mindiff = \d+;/my \$mindiff = 3;/; s/^my \$maxgc = 0\.\d+;/my \$maxgc = 0.62;/; s/^my \$mingc = 0\.\d+;/my \$mingc = 0.37;/;' makeindex.pl
# Run makeindex.pl
perl makeindex.pl > index-v2.txt
# Select forwardindex
perl selectindex-v5-2nd.pl index-v2.txt > forwardindex-v5-2nd.txt
# Make forwardprimer
perl makeforwardprimer.pl forwardindex-v5-2nd.txt > forwardprimer-v5-2nd.txt
# Make CSV files for IDT
perl makecsv-v5-2nd.pl forwardprimer-v5-2nd.txt forwardprimer-v5-2nd
# Select reverseindex
perl selectindex-v5-2nd.pl index-v2.txt > reverseindex-v5-2nd.txt
# Make reverseprimer
perl makereverseprimer.pl reverseindex-v5-2nd.txt > reverseprimer-v5-2nd.txt
# Make CSV files for IDT
perl makecsv-v5-2nd.pl reverseprimer-v5-2nd.txt reverseprimer-v5-2nd
# Convert CSV to XLSX
for f in `ls *primer-v5-2nd_??.csv | grep -o -P '^[^\.]+'`; do csv2xlsx -s $f -o $f.xlsx $f.csv; done
# Make IndexKit
mkdir -p Illumina\ Experiment\ Manager/IndexKits
perl makeindexkit-iem.pl forwardprimer-v5-2nd.txt reverseprimer-v5-2nd.txt Illumina\ Experiment\ Manager/IndexKits/Tanabe-v5-2nd-Nextera-IndexKit.txt
mkdir -p BaseSpace
perl makeindexkit-bs.pl forwardprimer-v5-2nd.txt reverseprimer-v5-2nd.txt BaseSpace/Tanabe-v5-2nd-Nextera-IndexKit.tsv
# Open and edit first 4 lines of makeindex.pl
perl -i -npe 's/^my \$length = \d+;/my \$length = 6;/; s/^my \$mindiff = \d+;/my \$mindiff = 3;/; s/^my \$maxgc = 0\.\d+;/my \$maxgc = 0.51;/; s/^my \$mingc = 0\.\d+;/my \$mingc = 0.49;/;' makeindex.pl
# Run makeindex.pl
perl makeindex.pl > index-v5-1st.txt
# Select forwardindex
perl selectindex-v5-1st.pl index-v5-1st.txt > forwardindex-v5-1st.txt
# Make forwardprimer
perl makeforwardprimer-1st.pl forwardindex-v5-1st.txt > forwardprimer-v5-1st.txt
# Make CSV files for IDT
perl makecsv-v5-1st.pl forwardprimer-v5-1st.txt forwardprimer-v5-1st
# Select reverseindex
perl selectindex-v5-1st.pl index-v5-1st.txt > reverseindex-v5-1st.txt
# Make reverseprimer
perl makereverseprimer-1st.pl reverseindex-v5-1st.txt > reverseprimer-v5-1st.txt
# Make CSV files for IDT
perl makecsv-v5-1st.pl reverseprimer-v5-1st.txt reverseprimer-v5-1st
# Convert CSV to XLSX
for f in `ls *primer-v5-1st.csv | grep -o -P '^[^\.]+'`; do csv2xlsx -s $f -o $f.xlsx $f.csv; done
```
