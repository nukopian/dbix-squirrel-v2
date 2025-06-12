package    # hide from PAUSE
    DBIx::Squirrel::v2::error;

=head1 NAME

DBIx::Squirrel::v2::error

=cut

use v5.38;
use experimental qw(builtin);
use builtin      qw(true);
use parent 'Exporter';

use Carp      qw(&confess     &croak);
use Ref::Util qw(&is_arrayref &is_blessed_ref);
use Sub::Name qw(&subname);

use DBIx::Squirrel::v2::message qw(:E &get_msg);

our @EXPORT_OK;
our %EXPORT_TAGS;

=head1 PACKAGE GLOBALS

=head2 $DBIx::Squirrel::v2::error::THROW_EXCEPTIONS

True by default, this flag determines whether errors are thrown as
exception objects. When false, errors are reported as message strings.

=head2 $DBIx::Squirrel::v2::error::THROW_WITH_TRACE

True by default, this flag determines whether or not errors are accompanied
by a stack-trace.

=cut

our $THROW_EXCEPTIONS = true;
our $THROW_WITH_TRACE = true;

=head1 EXPORTS

=head2 Default exports

None.

=cut


{
    no strict 'refs';

    $EXPORT_TAGS{ERROR} = $EXPORT_TAGS{E} = [
        $DBIx::Squirrel::v2::message::EXPORT_TAGS{E}->@*,
    ];

    for my $id (map(substr($_, 1), $EXPORT_TAGS{E}->@*)) {
        my $except = 'DBIx::Squirrel::v2::Exception::' . $id;
        *{ "$except\::ISA" }     = ['DBIx::Squirrel::v2::Exception::Class'];
        *{ "$except\::id" }      = subname id      => sub { $_[0]{id} };
        *{ "$except\::format" }  = subname format  => sub { $_[0]{format} };
        *{ "$except\::message" } = subname message => sub { $_[0]{message} };
        *{ "$except\::trace" }   = subname trace   => sub { $_[0]{trace} };
        *{ "$except\::new" }     = subname new     => sub {
            my $class   = shift;
            my $format  = get_msg($id);
            my $message = get_msg($id, @_);
            my $trace   = Carp::longmess($message . ', stopped');
            my $self    = bless {
                format  => $format,
                id      => $id,
                message => $message,
                trace   => $trace,
            }, $class;
            return $self;
        };
        *{ $id } = subname $id => sub {
            local @_ = do {
                if ($THROW_EXCEPTIONS) {
                    $except->new(@_);
                }
                else {
                    get_msg($id, @_);
                }
            };
            goto &confessf if $THROW_WITH_TRACE;
            goto &croakf;
        };
        $EXPORT_TAGS{$id} = [map($_ . $id, '&', '$')];
        push $EXPORT_TAGS{E}->@*, '&' . $id;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{E}->@*,
        qw(&confessf &croakf),
    );
}


=head2 confessf

Raise an error with a stack-trace.

=cut


sub confessf {
    local @_ = do {
        if (@_) {
            if (is_blessed_ref($_[0])) {
                @_;
            }
            else {
                my $format = do {
                    if (is_arrayref($_[0])) {
                        join(' ', shift->@*);
                    }
                    else {
                        shift;
                    }
                };
                if (length($format)) {
                    if (@_) {
                        sprintf($format . ', stopped', @_);
                    }
                    else {
                        $format . ', stopped';
                    }
                }
                else {
                    join(' ', @_) . ', stopped';
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
            if (is_blessed_ref($_[0])) {
                @_;
            }
            else {
                my $format = do {
                    if (is_arrayref($_[0])) {
                        join(' ', shift->@*);
                    }
                    else {
                        shift;
                    }
                };
                if (length($format)) {
                    if (@_) {
                        sprintf($format . ', stopped', @_);
                    }
                    else {
                        $format . ', stopped';
                    }
                }
                else {
                    join(' ', @_) . ', stopped';
                }
            }
        }
        else {
            $@ || 'Unknown error';
        }
    };
    goto &croak;
}


package    # hide from PAUSE
    DBIx::Squirrel::v2::Exception::Class;
use overload '""' => sub {
    $DBIx::Squirrel::v2::error::THROW_WITH_TRACE
        ? $_[0]->trace
        : $_[0]->message;
};

=head1 AUTHORS

=over

=item Iain Campbell <cpanic@cpan.org>

=back

=cut

1;
