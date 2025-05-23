package    # hide from PAUSE
    DBIx::Squirrel::v2::util::message;
use v5.38;
use experimental 'for_list';
use parent 'Exporter';

our %EXPORT_TAGS;
our @EXPORT_OK;
our %MESSAGE;


BEGIN {
    no strict 'refs';

    $EXPORT_TAGS{ERROR} = [];

    for my( $k, $m ) (
        E_BAD_DBI_DB_HANDLE => qq(bad 'DBD::db' handle),
    ) {
        $MESSAGE{$k} = $m;
        *{ $k } = \$MESSAGE{$k};
        push $EXPORT_TAGS{ERROR}->@*, '$' . $k;
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{ERROR}->@*,
        qw(
            %MESSAGE
        ),
    );
}

1;
