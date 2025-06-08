package    # hide from PAUSE
    DBIx::Squirrel::v2::error;
use v5.38;
use parent 'Exporter';

use Carp      qw( &confess &croak );
use Ref::Util qw(&is_arrayref);
use Sub::Name qw(&subname);

use DBIx::Squirrel::v2::message qw( :E &msg );

our @EXPORT_OK;
our %EXPORT_TAGS;

our $ENABLE_STACK_TRACE = !!1;


{
    no strict 'refs';

    $EXPORT_TAGS{ERROR} = $EXPORT_TAGS{E} = [
        $DBIx::Squirrel::v2::message::EXPORT_TAGS{E}->@*,
    ];


    for my $id ( map( substr( $_, 1 ), $EXPORT_TAGS{E}->@* ) ) {
        *{ $id } = subname(
            $id,
            sub : prototype(;@) {
                local @_ = msg $id, @_;
                goto &confessf if $ENABLE_STACK_TRACE;
                goto &croakf;
            },
        );
        $EXPORT_TAGS{$id} = [ map( $_ . $id, '&', '$' ) ];
        push $EXPORT_TAGS{E}->@*, '&' . $id;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{E}->@*,
        qw( &confessf &croakf ),
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
