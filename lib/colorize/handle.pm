package colorize::handle;

# DATE
# VERSION

use strict;
use warnings;
use PerlIO::via::ANSIColor;

my %colorized; # key = handle

sub import {
    my ($pkg, $handle, $color) = @_;
    die "Please specify handle and color" unless $handle && $color;

    return if $colorized{$handle};

    my @layers = PerlIO::get_layers($handle);
    PerlIO::via::ANSIColor->color($color);
    binmode($handle, ":via(ANSIColor)");

    $colorized{$handle} = [scalar(@layers)];
}

sub unimport {
    my ($pkg, $handle) = @_;
    die "Please specify handle" unless $handle;

    return unless $colorized{$handle};
    my $pos = $colorized{$handle}[0];

    my @layers = PerlIO::get_layers($handle);
    if ($pos == $#layers && $layers[$pos] eq 'via') {
        # get_layers() only return 'via' so we assume that the last 'via' layer
        # is us.
        binmode($handle, ':pop');
    }

    undef $colorized{$handle};
}


1;
# ABSTRACT: Colorize a filehandle

=for Pod::Coverage .+

=head1 SYNOPSIS

 use colorize::handle \*STDERR, "yellow";

Also see the more convenient subclass L<colorize::stderr> for colorizing STDERR.


=head1 DESCRIPTION

This is a thin wrapper over L<PerlIO::via::ANSIColor>.

Caveat: although this module provides C<unimport()>, this code does not do what
you expect it to do:

 {
     use colorize::stderr;
     warn "colored warning!";
 }
 warn "back to uncolored";

Because C<no colorize::stderr> will be run at compile-time. You can do this
though:

 use colorize::stderr ();

 {
     colorize::stderr->import;
     warn "colored warning!";
     colorize::stderr->unimport;
 }
 warn "back to uncolored";


=head1 SEE ALSO

L<PerlIO::via::ANSIColor>

=cut
