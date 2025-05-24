package    # hide from PAUSE
    DBIx::Squirrel::v2::util;
use v5.38;
use parent 'Exporter';

our @EXPORT_OK;


BEGIN {
    @EXPORT_OK = ( qw(
        RootClass
    ) );
}


sub RootClass ( $class, %attr ) {
    ( $class = ref($class) // $class // __PACKAGE__ ) =~ s/::[^:]+$//;
    return $class unless wantarray;
    return 'RootClass' => $class, %attr;
}

1;
