use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::util::error qw(:ERROR);

like dies { E_BAD_DBI_DB_HANDLE }, qr($E_BAD_DBI_DB_HANDLE), q(error dispatch);

done_testing();
