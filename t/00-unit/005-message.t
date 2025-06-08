use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::message qw( $E_BAD_DB_HANDLE &msg );

like( msg('E_BAD_DB_HANDLE'), $E_BAD_DB_HANDLE, 'get message' );

done_testing();
