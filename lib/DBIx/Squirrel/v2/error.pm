package    # hide from PAUSE
    DBIx::Squirrel::v2::error;

=head1 NAME

DBIx::Squirrel::v2::error

=cut

use v5.38;
use parent 'Exporter';

use Carp      qw( &confess     &croak );
use Ref::Util qw( &is_arrayref &is_blessed_ref );
use Sub::Name qw(&subname);

use DBIx::Squirrel::v2::message qw( :E &get_msg );

our @EXPORT_OK;
our %EXPORT_TAGS;

=head1 PACKAGE GLOBALS

=head2 $DBIx::Squirrel::v2::error::ENABLE_STACK_TRACE

True by default, this flag determines whether or not error messages are
to be accompanied by a stack-trace.

=cut

our $ENABLE_STACK_TRACE = !!1;

=head1 EXPORTS

=head2 Default exports

None.

=cut


{
    no strict 'refs';

    $EXPORT_TAGS{ERROR} = $EXPORT_TAGS{E} = [
        $DBIx::Squirrel::v2::message::EXPORT_TAGS{E}->@*,
    ];

    for my $id ( map( substr( $_, 1 ), $EXPORT_TAGS{E}->@* ) ) {
        eval( <<~"EOF" ) or confess $@;
            package DBIx\::Squirrel\::v2\::Exception\::$id;
            use v5.38;
            no strict 'refs';
            use Sub\::Name qw(\&subname);
            use DBIx\::Squirrel\::v2\::message qw(\&get_msg);
            use namespace\::clean;
            \@DBIx\::Squirrel\::v2\::Exception\::$id\::ISA = 'DBIx\::Squirrel\::v2\::Exception::Class';
            sub id : prototype() {'$id'}
            sub msg {\$_[0]{msg}}
            sub new {shift and bless { msg => get_msg('$id', \@_) }}
            *{'DBIx\::Squirrel\::v2\::Exception\::$id'} = subname(
                'DBIx\::Squirrel\::v2\::Exception\::$id' => sub {
                    return DBIx\::Squirrel\::v2\::Exception\::$id->new(@_);
                }
            );
            EOF
        *{ $id } = subname $id => sub {
            local @_ = get_msg( $id, @_ );
            goto &confessf if $ENABLE_STACK_TRACE;
            goto &croakf;
        };
        $EXPORT_TAGS{$id} = [ map( $_ . $id, '&', '$' ) ];
        push $EXPORT_TAGS{E}->@*, '&' . $id;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{E}->@*,
        qw( &confessf &croakf ),
    );
}


=head2 confessf

Raise an error with a stack-trace.

=cut


sub confessf {
    local @_ = do {
        if (@_) {
            if ( is_blessed_ref( $_[0] ) ) {
                @_;
            }
            else {
                my $format = do {
                    if ( is_arrayref( $_[0] ) ) {
                        join ' ', shift->@*;
                    }
                    else {
                        shift;
                    }
                };
                if ( length($format) ) {
                    if (@_) {
                        sprintf $format . ', stopped', @_;
                    }
                    else {
                        $format . ', stopped';
                    }
                }
                else {
                    join( ' ', @_ ) . ', stopped';
                }
            }
        }
        else {
            $@ || 'Unknown error';
        }
    };
    goto &confess;
}


=head2 croakf

Raise an error without a stack-trace.

=cut


sub croakf {
    local @_ = do {
        if (@_) {
            if ( is_blessed_ref( $_[0] ) ) {
                @_;
            }
            else {
                my $format = do {
                    if ( is_arrayref( $_[0] ) ) {
                        join ' ', shift->@*;
                    }
                    else {
                        shift;
                    }
                };
                if ( length($format) ) {
                    if (@_) {
                        sprintf $format . ', stopped', @_;
                    }
                    else {
                        $format . ', stopped';
                    }
                }
                else {
                    join( ' ', @_ ) . ', stopped';
                }
            }
        }
        else {
            $@ || 'Unknown error';
        }
    };
    goto &croak;
}


package DBIx::Squirrel::v2::Exception::Class;
use overload '""' => sub { $_[0]->msg };

=head1 AUTHORS

=over

=item Iain Campbell <cpanic@cpan.org>

=back

=cut

1;
