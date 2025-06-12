use v5.38;
use Test2::V0;
use DBIx::Squirrel::v2::error qw(:E_DUMMY);

like dies { +E_DUMMY }, qr($E_DUMMY),
    'error dispatch';

like DBIx::Squirrel::v2::Exception::E_DUMMY, qr($E_DUMMY),
    'exception stringification';

like DBIx::Squirrel::v2::Exception::E_DUMMY->message, qr($E_DUMMY),
    'exception stringification';

like DBIx::Squirrel::v2::Exception::E_DUMMY->trace, qr($E_DUMMY),
    'exception stringification';

done_testing();
