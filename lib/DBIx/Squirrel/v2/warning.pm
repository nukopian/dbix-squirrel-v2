package    # hide from PAUSE
    DBIx::Squirrel::v2::warning;
use v5.38;
use parent 'Exporter';

use Carp      qw( &carp &cluck );
use Ref::Util qw(&is_arrayref);
use Sub::Name qw(&subname);

use DBIx::Squirrel::v2::message qw( :W &msg );

our @EXPORT_OK;
our %EXPORT_TAGS;

our $ENABLE_STACK_TRACE = !!1;


{
    no strict 'refs';

    $EXPORT_TAGS{WARNING} = $EXPORT_TAGS{W} = [
        $DBIx::Squirrel::v2::message::EXPORT_TAGS{W}->@*,
    ];


    for my $id ( map( substr( $_, 1 ), $EXPORT_TAGS{W}->@* ) ) {
        *{ $id } = subname(
            $id,
            sub : prototype(;@) {
                local @_ = msg $id, @_;
                goto &cluckf if $ENABLE_STACK_TRACE;
                goto &carpf;
            },
        );
        $EXPORT_TAGS{$id} = [ map( $_ . $id, '&', '$' ) ];
        push $EXPORT_TAGS{W}->@*, '&' . $id;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{W}->@*,
        qw( &carpf &cluckf ),
    );
}


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


1;
