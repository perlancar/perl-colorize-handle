package colorize::stderr;

# DATE
# VERSION

use strict;
use warnings;

use colorize::handle ();

sub import {
    my ($pkg, $color) = @_;
    $color = "yellow" unless defined $color;

    colorize::handle->import(\*STDERR, $color);
}

sub unimport {
    my ($pkg) = @_;

    colorize::handle->unimport(\*STDERR);
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
