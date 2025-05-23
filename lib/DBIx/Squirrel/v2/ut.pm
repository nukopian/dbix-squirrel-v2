package    # hide from PAUSE
    DBIx::Squirrel::v2::ut;
use v5.38;
use parent 'Exporter';

use Ref::Util qw(
    is_arrayref
    is_blessed_ref
    is_coderef
    is_hashref
);

our @EXPORT_OK = qw(
    is_arrayref
    is_blessed_ref
    is_coderef
    is_hashref
);

1;
