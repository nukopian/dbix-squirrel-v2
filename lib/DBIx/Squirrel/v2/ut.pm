package    # hide from PAUSE
    DBIx::Squirrel::v2::ut;
use v5.38;
use parent 'Exporter';

use Carp qw(
    carp
    confess
    croak
);
use Ref::Util qw(
    is_arrayref
    is_blessed_ref
    is_coderef
    is_hashref
    is_scalarref
    is_plain_arrayref
    is_plain_coderef
    is_plain_hashref
);

our @EXPORT_OK = qw(
    carp
    confess
    croak
    is_arrayref
    is_blessed_ref
    is_coderef
    is_hashref
    is_scalarref
    is_plain_arrayref
    is_plain_coderef
    is_plain_hashref
    RootClass
);


sub RootClass ( $class, %attr ) {
    ( $class = ref($class) // $class // __PACKAGE__ ) =~ s/::[^:]+$//;
    return $class unless wantarray;
    return 'RootClass' => $class, %attr;
}

1;
