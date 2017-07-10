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
# ABSTRACT: Colorize STDERR

=for Pod::Coverage .+

=head1 SYNOPSIS

 use colorize::stderr;
 warn "blah!"; # will be printed in yellow

If you want to customize color:

 use colorize::stderr 'red on_white';
 warn "blah!";


=head1 DESCRIPTION

This is a convenience wrapper over L<colorize::handle> for colorizing STDERR.

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

L<colorize::handle>

=cut
