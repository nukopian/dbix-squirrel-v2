use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::util::message qw( $E_BAD_DB_HANDLE %MSG &MSG );

like MSG('E_BAD_DB_HANDLE'), $E_BAD_DB_HANDLE, 'MSG';

done_testing();
