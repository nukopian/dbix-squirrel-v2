package    # hide from PAUSE
    DBIx::Squirrel::v2::warning;

=head1 NAME

DBIx::Squirrel::v2::warning

=cut

use v5.38;
use parent 'Exporter';

use Carp      qw( &carp &cluck );
use Ref::Util qw(&is_arrayref);
use Sub::Name qw(&subname);

use DBIx::Squirrel::v2::message qw( :W &get_msg );

our @EXPORT_OK;
our %EXPORT_TAGS;

=head1 PACKAGE GLOBALS

=head2 $DBIx::Squirrel::v2::warning::ENABLE_STACK_TRACE

True by default, this flag determines whether or not warning messages are
to be accompanied by a stack-trace.

=cut

our $ENABLE_STACK_TRACE = !!1;

=head1 EXPORTS

=head2 Default exports

None.

=cut

{
    no strict 'refs';

    $EXPORT_TAGS{WARNING} = $EXPORT_TAGS{W} = [
        $DBIx::Squirrel::v2::message::EXPORT_TAGS{W}->@*,
    ];


    for my $id ( map( substr( $_, 1 ), $EXPORT_TAGS{W}->@* ) ) {
        *{ $id } = subname $id => sub {
            local @_ = get_msg $id, @_;
            goto &cluckf if $ENABLE_STACK_TRACE;
            goto &carpf;
        };
        $EXPORT_TAGS{$id} = [ map( $_ . $id, '&', '$' ) ];
        push $EXPORT_TAGS{W}->@*, '&' . $id;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{W}->@*,
        qw( &carpf &cluckf ),
    );
}


=head2 carpf

Emit a warning without a stack-trace.

=cut


sub carpf : prototype(;@) {
    local @_ = do {
        if (@_) {
            my $format = do {
                if ( is_arrayref( $_[0] ) ) {
                    join( ' ', @{ +shift } );
                }
                else {
                    shift;
                }
            };
            if (@_) {
                sprintf( $format, @_ );
            }
            else {
                $format
                    || $@
                    || 'Unknown warning';
            }
        }
        else {
            $@ || 'Unknown warning';
        }
    };
    goto &carp;
}


=head2 cluckf

Emit a warning with a stack-trace.

=cut


sub cluckf : prototype(;@) {
    local @_ = do {
        if (@_) {
            my $format = do {
                if ( is_arrayref( $_[0] ) ) {
                    join( ' ', @{ +shift } );
                }
                else {
                    shift;
                }
            };
            if (@_) {
                sprintf( $format, @_ );
            }
            else {
                $format
                    || $@
                    || 'Unknown warning';
            }
        }
        else {
            $@ || 'Unknown warning';
        }
    };
    goto &cluck;
}


=head1 AUTHORS

=over

=item Iain Campbell <cpanic@cpan.org>

=back

=cut

1;
