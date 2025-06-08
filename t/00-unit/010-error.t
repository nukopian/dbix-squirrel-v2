use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::error qw(:E_BAD_DB_HANDLE);

like( dies { +E_BAD_DB_HANDLE }, qr($E_BAD_DB_HANDLE), 'error dispatch' );

done_testing();
