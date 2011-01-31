package Dist::Zilla::Plugin::PodLinkTests;
BEGIN {
  $Dist::Zilla::Plugin::PodLinkTests::VERSION = '1.004000';
}
BEGIN {
  $Dist::Zilla::Plugin::PodLinkTests::AUTHORITY = 'cpan:RWSTAUNER';
}
# ABSTRACT: Dynamically add release tests for POD links


use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';

my @tests = qw(linkcheck no404s);
{
	use Moose::Util::TypeConstraints 1.01;

	has test => (
		is      => 'ro',
		isa     => enum( [ qw(both none), @tests ]),
		default => 'both',
	);

	no Moose::Util::TypeConstraints;
}

# overwrite this sub imported from Data::Section
# to only return desired sections.
sub merged_section_data {
	my ($self) = @_;

	my $selftest = $self->test;
	return {} if $selftest eq 'none';

	my $data = $self->SUPER::merged_section_data();
	return $data if $selftest eq 'both';

	foreach my $test ( @tests ){
		$selftest eq $test
			or delete $data->{"xt/release/pod-$test.t"};
	}

	return $data;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;




=pod

=for :stopwords Randy Stauner CPANPLUS CPAN AnnoCPAN RT CPANTS Kwalitee diff IRC

=head1 NAME

Dist::Zilla::Plugin::PodLinkTests - Dynamically add release tests for POD links

=head1 VERSION

version 1.004000

=head1 SYNOPSIS

	# dist.ini
	[PodLinkTests]
	; test = both   ; options: qw(both none linkcheck no404s)

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files:

  xt/release/pod-linkcheck.t - a standard Test::Pod::LinkCheck test
  xt/release/pod-no404s.t    - a standard Test::Pod::No404s test

The tests check for the following C<%ENV> variables:

=over 4

=item *

C<$ENV{SKIP_POD_LINK_TESTS}> - skip both

=item *

C<$ENV{SKIP_POD_LINKCHECK}>  - skip L<Test::Pod::LinkCheck>

=item *

C<$ENV{SKIP_POD_NO404S}>     - skip L<Test::Pod::No404s>

=item *

C<$ENV{AUTOMATED_TESTING}>   - skip L<Test::Pod::No404s>

=back

I elected to skip the 404 test with C<AUTOMATED_TESTING>
because I don't want to run that test (and bother the network) often,
but I do like to run my author and release tests
before actually attempting C<dzil release>.

So using C<dzil smoke> instead of C<dzil test>
will skip the 404 network tests.

B<NOTE> You may need to update your CPANPLUS index
before Test::Pod::LinkCheck will work (or in my case even install).
Using the C<x> command at the C<cpanp> prompt did the trick for me.

=for Pod::Coverage merged_section_data

=head1 SEE ALSO

=over 4

=item *

L<Test::Pod::LinkCheck>

=item *

L<Test::Pod::No404s>

=back

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

  perldoc Dist::Zilla::Plugin::PodLinkTests

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-Plugin-PodLinkTests>

=item *

RT: CPAN's Bug Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-Plugin-PodLinkTests>

=item *

AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-Plugin-PodLinkTests>

=item *

CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-Plugin-PodLinkTests>

=item *

CPAN Forum

L<http://cpanforum.com/dist/Dist-Zilla-Plugin-PodLinkTests>

=item *

CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/Dist-Zilla-Plugin-PodLinkTests>

=item *

CPAN Testers Results

L<http://cpantesters.org/distro/D/Dist-Zilla-Plugin-PodLinkTests.html>

=item *

CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Dist-Zilla-Plugin-PodLinkTests>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-dist-zilla-plugin-podlinktests at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-Plugin-PodLinkTests>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head2 Source Code


L<http://github.com/magnificent-tears/Dist-Zilla-Plugin-PodLinkTests/tree>

  git clone git://github.com/magnificent-tears/Dist-Zilla-Plugin-PodLinkTests.git

=head1 AUTHOR

Randy Stauner <rwstauner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Randy Stauner.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__DATA__
___[ xt/release/pod-linkcheck.t ]___
#!perl

use strict;
use warnings;
use Test::More;

foreach my $env_skip ( qw(
  SKIP_POD_LINK_TESTS
  SKIP_POD_LINKCHECK
) ){
  plan skip_all => "\$ENV{$env_skip} is set, skipping"
    if $ENV{$env_skip};
}

eval "use Test::Pod::LinkCheck";
if ( $@ ) {
  plan skip_all => 'Test::Pod::LinkCheck required for testing POD';
}
else {
  Test::Pod::LinkCheck->new->all_pod_ok;
}
___[ xt/release/pod-no404s.t ]___
#!perl

use strict;
use warnings;
use Test::More;

foreach my $env_skip ( qw(
  SKIP_POD_LINK_TESTS
  SKIP_POD_NO404S
  AUTOMATED_TESTING
) ){
  plan skip_all => "\$ENV{$env_skip} is set, skipping"
    if $ENV{$env_skip};
}

eval "use Test::Pod::No404s";
if ( $@ ) {
  plan skip_all => 'Test::Pod::No404s required for testing POD';
}
else {
  all_pod_files_ok();
}
