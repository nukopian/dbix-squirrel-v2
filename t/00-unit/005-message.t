use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::message qw($E_BAD_DB_HANDLE &get_msg);

like(get_msg('E_BAD_DB_HANDLE'), $E_BAD_DB_HANDLE, 'get message');

done_testing();
