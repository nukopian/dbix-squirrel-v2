package    # hide from PAUSE
    DBIx::Squirrel::v2::util::error;
use v5.38;
use parent 'Exporter';

use Carp qw(
    confess
    croak
);
use Ref::Util 'is_arrayref';
use Sub::Name 'subname';

use DBIx::Squirrel::v2::util::message qw(
    :ERROR
    %MESSAGE
    message
);

our %EXPORT_TAGS;
our @EXPORT_OK;
our $ENABLE_STACK_TRACE;


BEGIN {
    no strict 'refs';

    $EXPORT_TAGS{ERROR}
        = [ $DBIx::Squirrel::v2::util::message::EXPORT_TAGS{ERROR}->@* ];

    for my $k ( map( substr( $_, 1 ), $EXPORT_TAGS{ERROR}->@* ) ) {
        *{ $k } = subname(
            $k,
            sub : prototype(;@) {
                local @_ = message( $k, @_ );
                goto &croakf unless $ENABLE_STACK_TRACE;
                goto &confessf;
            },
        );
        push $EXPORT_TAGS{ERROR}->@*, '&' . $k;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{ERROR}->@*,
        qw(
            confessf
            croakf
        ),
    );
}


sub confessf : prototype(;@) {
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
                    || 'Unknown error';
            }
        }
        else {
            $@ || 'Unknown error';
        }
    };
    goto &confess;
}


sub croakf : prototype(;@) {
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
                    || 'Unknown error';
            }
        }
        else {
            $@ || 'Unknown error';
        }
    };
    goto &croak;
}

1;
