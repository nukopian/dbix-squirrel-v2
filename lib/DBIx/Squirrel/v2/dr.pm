package    # hide from PAUSE
    DBIx::Squirrel::v2::dr;
use v5.38;
use parent -norequire => qw(DBI::dr);

use DBI ();

use DBIx::Squirrel::v2::ut qw(
    is_blessed_ref
    is_hashref
);

use namespace::clean;


sub RootClass ($class) {
    ( $class = ref($class) // $class // __PACKAGE__ ) =~ s/::[^:]+$//;
    return ( RootClass => $class ) if wantarray;
    return $class;
}


sub connect ( $class, @args ) {
    $class = ref($class) // $class;
    my $clonable = shift(@args)
        if @args && is_blessed_ref( $args[0] );
    my %attrs = do {
        if ( @args && is_hashref( $args[$#args] ) ) {
            ( $class->RootClass, pop(@args)->%* );
        }
        else {
            ( $class->RootClass );
        }
    };
    return $clonable->clone( \%attrs ) if $clonable;
    return DBI::connect( $class, @args, \%attrs );
}


sub connect_cached ( $class, @args ) {
    $class = ref($class) // $class;
    my %attrs = do {
        if ( @args && is_hashref( $args[$#args] ) ) {
            ( $class->RootClass, pop(@args)->%* );
        }
        else {
            ( $class->RootClass );
        }
    };
    return DBI::connect_cached( $class, @args, \%attrs );
}

1;
