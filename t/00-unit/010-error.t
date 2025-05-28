use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::util::error qw( $E_BAD_DB_HANDLE &E_BAD_DB_HANDLE );

like dies { E_BAD_DB_HANDLE }, qr($E_BAD_DB_HANDLE), 'dispatch error';

done_testing();
