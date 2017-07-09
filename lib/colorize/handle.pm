package colorize::handle;

# DATE
# VERSION

use strict;
use warnings;
use PerlIO::via::ANSIColor;

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
        print "POP\n";
        binmode($handle, ':pop');
    }

    undef $colorized{$handle};
}


1;
# ABSTRACT: Colorize a filehandle

=for Pod::Coverage .+

=head1 SYNOPSIS

 use colorize::handle \*STDERR, "yellow";
 ...
 no colorize::handle \*STDERR;

But commonly used via L<colorize::stderr> or L<colorize::stdout>.


=head1 DESCRIPTION

This is a thin wrapper over L<PerlIO::via::ANSIColor>.


=head1 SEE ALSO

L<PerlIO::via::ANSIColor>

=cut
