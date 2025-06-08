package    # hide from PAUSE
    DBIx::Squirrel::v2::message;

=head1 NAME

DBIx::Squirrel::v2::message

=cut


use v5.38;
use experimental 'for_list';
use parent 'Exporter';

use Ref::Util qw(&is_arrayref);

our @EXPORT_OK;
our %EXPORT_TAGS;

=head1 PACKAGE GLOBALS

=cut


our @CATALOG = (
    E_BAD_DB_HANDLE => q(bad 'DBI::db' handle),
    W_DUMMY         => q(a dummy warning),
);

our %MSG;

=head1 EXPORTS

=cut


{
    no strict 'refs';

    my %tags = (
        D => 'DEBUG',
        E => 'ERROR',
        I => 'INFO',
        W => 'WARNING',
    );

    for ( keys %tags ) {
        $EXPORT_TAGS{$_} = [];
        $EXPORT_TAGS{ $tags{$_} } = $EXPORT_TAGS{$_};
    }

    for my( $id, $text ) (@CATALOG) {
        ( my $prefix = $id ) =~ tr/_/-/;
        $MSG{$id} = "$prefix $text";
        *{ $id } = \$MSG{$id};
        my $tag = substr $id, 0, 1;
        push $EXPORT_TAGS{$tag}->@*, '$' . $id;
    }

    @EXPORT_OK = (
        map( $EXPORT_TAGS{$_}->@*, keys %tags ),
        qw(&msg),
    );
}

=head2 msg

=cut


sub msg ( $id, @args ) {
    return                         unless defined $id;
    return join( ' ', $id, @args ) unless exists $MSG{$id};
    return @args > 0 ? sprintf( $MSG{$id}, @args ) : $MSG{$id};
}

1;
