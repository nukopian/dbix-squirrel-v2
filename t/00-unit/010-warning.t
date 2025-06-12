use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::warning qw(:W_DUMMY);

like(warning { +W_DUMMY }, qr($W_DUMMY), 'warning dispatch');

done_testing();
