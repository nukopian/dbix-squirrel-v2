package DBIx::Squirrel::v2;
use v5.38;
use parent qw(DBI);

use DBIx::Squirrel::v2::db ();
use DBIx::Squirrel::v2::dr ();
use DBIx::Squirrel::v2::st ();
use namespace::clean;

our $VERSION = '2.0.0';

1;
