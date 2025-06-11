package    # hide from PAUSE
    DBIx::Squirrel::v2::dr;

=head1 NAME

DBIx::Squirrel::v2::dr

=cut

use v5.38;
use parent -norequire => qw(DBI::dr);

use DBI       ();
use Ref::Util qw( &is_blessed_ref &is_plain_hashref );

use DBIx::Squirrel::v2::error qw(&E_BAD_DB_HANDLE);

use namespace::clean;

=head1 EXPORTS

None.

=cut

=head1 CLASS METHODS

=cut


=head2 RootClass

The root-class of the DBI subclass.

    $root = DBIx::Squirrel::v2::dr->RootClass;

When called in Scalar-context, the root namespace of the DBI subclass is
returned. In our example, this would be C<DBIx::Squirrel::v2>.

    %hash = DBIx::Squirrel::v2::dr->RootClass(%attr);

When called in List-context, a hash is returned. In our example, this would
resemble the structure below:

    ('RootClass' => 'DBIx::Squirrel::v2', %attr)

The latter variation is simply a convenience for when the root-class needs
to be included attributes passed to a database connection or statement
handle.

=cut


sub RootClass ( $class, %attr ) {
    ( $class = ref($class) // $class // __PACKAGE__ ) =~ s/::[^:]+$//;
    return wantarray ? ( 'RootClass' => $class, %attr ) : $class;
}


=head2 connect

Establish a connection with a datasource.

=cut


sub connect ( $class, @args ) {
    $class = ref($class) // $class;
    my %attr = do {
        if ( @args > 1 && is_plain_hashref( $args[$#args] ) ) {
            $class->RootClass( pop(@args)->%* );
        }
        else {
            $class->RootClass();
        }
    };
    if ( @args && is_blessed_ref( $args[0] ) ) {
        E_BAD_DB_HANDLE
            unless $args[0]->isa('DBI::db');
        $args[0]->clone( \%attr );
    }
    return DBI::connect( $class, @args, \%attr );
}


=head2 connect_cached

Get the last connection established using the same parameters (if it is
still valid), or establish a new one.

=cut


sub connect_cached ( $class, @args ) {
    $class = ref($class) // $class;
    my %attr = do {
        if ( @args > 1 && is_plain_hashref( $args[$#args] ) ) {
            $class->RootClass( pop(@args)->%* );
        }
        else {
            $class->RootClass();
        }
    };
    return DBI::connect_cached( $class, @args, \%attr );
}


=head1 AUTHORS

=over

=item Iain Campbell <cpanic@cpan.org>

=back

=cut

1;
