package    # hide from PAUSE
    DBIx::Squirrel::v2::db;
use v5.38;
use parent -norequire => qw(DBI::db);

use DBIx::Squirrel::v2 ();
use namespace::clean;

1;
