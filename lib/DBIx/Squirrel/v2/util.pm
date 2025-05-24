package    # hide from PAUSE
    DBIx::Squirrel::v2::util;
use v5.38;
use parent 'Exporter';

use Sub::Name 'subname';

use DBIx::Squirrel::v2::util::error qw(
    :ERROR
    confessf
    croakf
);

our %EXPORT_TAGS;
our @EXPORT_OK;


BEGIN {
    @EXPORT_OK = ( qw(
        confessf
        croakf
        RootClass
    ) );
}


sub RootClass ( $class, %attr ) {
    ( $class = ref($class) // $class // __PACKAGE__ ) =~ s/::[^:]+$//;
    return $class unless wantarray;
    return 'RootClass' => $class, %attr;
}

1;
