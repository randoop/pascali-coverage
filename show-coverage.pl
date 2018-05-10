#!/usr/bin/env perl

=head1 NAME

show-coverage.pl

=head1 SYNOPSIS

show-coverage.pl [options] [optional pascali coverage file]

 Options:
  -help        brief help message
  -details     include details of each test run
  -man         full documentation

=head1 OPTIONS

=over 4

=item B<-help>

Print a brief help message and exits.

=item B<-details>

Include coverage details for each test.
[default is summary only]

=item B<-man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

This perl script reads a Pascali coverage file, calculates the percent coverage
and displays the result.

By default, the script will read the file:

  evaluation/coverage/report-<today's date>.csv

You may supply an alternative file as an argument.

=cut

use strict;
use warnings;

use POSIX qw(strftime);
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);

my $help = 0;
my $details = 0;
my $man = 0;

    # Parse options and print usage if there is a syntax error,
    # or if usage was explicitly requested.
    GetOptions('help|?' => \$help, details => \$details, man => \$man) or pod2usage(2);
    pod2usage(1) if $help;
    pod2usage(-verbose => 2) if $man;
    # Check for too many filenames
    pod2usage("$0: Too many files given.\n")  if (@ARGV > 1);

my $expected_test_count = 76;
my $test_count = 0;
my $tot_line = 0;
my $tot_exec = 0;
my $tot_fail = 0;
my @fields;
my $filename = strftime("evaluation/coverage/report-%Y%m%d.csv", localtime);
my @lines;
my $line;

    # first key is case-insensitive test name
    # second key is test number
    sub by_name_and_number {
        "\L@$a[0]" cmp "\L@$b[0]"
          or
        @$a[1] <=> @$b[1];
    }

    print(strftime("\nToday's date: %Y-%m-%d %H:%M:%S", localtime), "\n");

    if (@ARGV == 1) {
        $filename = $ARGV[0];
    }

    open(my $fh, '<', $filename)
      or die "Could not open file '$filename'. $!.\n";
    printf("Processing file: %s\n", $filename);
    print(strftime("Created: %Y-%m-%d %H:%M:%S", localtime((stat($fh))[9])), "\n");

    if ($details) {
        print "\nTest    Lines     Total    %", "\n";
        print "name    covered   lines    coverage", "\n";
    }

    # read all input lines into an array
    # so we can sort it to get consistent output
    while (<$fh>) {
        chomp;
        @fields = split /,/;
        if (@fields == 0) {
            # do nothing for a blank line
        } elsif (@fields == 1) {
            # do nothing for report name line
        } elsif ($fields[0] eq "project") {
            # do nothing for a header line
        } else {
            push @lines, [ @fields ];
        }
    }

    for $line (sort by_name_and_number @lines) {
        $test_count += 1;
        $tot_exec += @$line[2];
        $tot_line += @$line[3];
        if (@$line[3] != 0) {
            if ($details) {
                printf("%s.%d: %d %d %.2f\n", @$line[0], @$line[1], @$line[2], @$line[3], @$line[2]/@$line[3]);
            }
        } else {
            $tot_fail += 1;
            if ($details) {
                printf("%s.%d: failed\n", @$line[0], @$line[1]);
            }
        }
    }

    if ($expected_test_count < $test_count) {
        die "More test results than expected!";
    }
    $tot_fail = $expected_test_count - $test_count + $tot_fail;

    printf("\nNumber tests: %d, %d failed\n", $expected_test_count, $tot_fail);
    print "Total lines: ", $tot_line, "\n";
    print "Lines executed: ", $tot_exec, "\n";
    printf("Coverage: %.2f\n", $tot_exec/$tot_line);
