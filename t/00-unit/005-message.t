use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::util::message qw(
    %MESSAGE
    message
);

like message('E_BAD_DBI_DB_HANDLE'), q(bad 'DBI::db' handle), q(message);

done_testing();
