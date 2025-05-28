package    # hide from PAUSE
    DBIx::Squirrel::v2::dr;
use v5.38;
use parent -norequire => qw(DBI::dr);

use DBI       ();
use Ref::Util qw(
    is_blessed_ref
    is_plain_hashref
);

use DBIx::Squirrel::v2::util 'RootClass';
use DBIx::Squirrel::v2::util::error 'E_BAD_DBI_DB_HANDLE';

use namespace::clean;


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
        my $clonable = shift(@args);
        E_BAD_DBI_DB_HANDLE
            unless $clonable->isa('DBI::db');
        return $clonable->clone( \%attr );
    }
    return DBI::connect( $class, @args, \%attr );
}


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

1;
