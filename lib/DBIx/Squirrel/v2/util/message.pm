package    # hide from PAUSE
    DBIx::Squirrel::v2::util::message;
use v5.38;
use experimental 'for_list';
use parent 'Exporter';

our %EXPORT_TAGS;
our @EXPORT_OK;
our %MSG;


BEGIN {
    no strict 'refs';

    my %tags = (
        D => 'DEBUG',
        E => 'ERROR',
        I => 'INFO',
        W => 'WARN',
    );

    $EXPORT_TAGS{$_} = [] for keys %tags;

    for my( $k, $m ) (
        E_BAD_DB_HANDLE => qq(bad 'DBI::db' handle),
    ) {
        ( my $code = $k ) =~ tr/_/-/;
        $MSG{$k} = "$code $m";
        *{ $k } = \$MSG{$k};
        if ( my $tag = $tags{ substr( $k, 0, 1 ) } ) {
            push $EXPORT_TAGS{$tag}->@*, '$' . $k;
        }
    }

    @EXPORT_OK = (
        $EXPORT_TAGS{ERROR}->@*,
        qw(
            %MSG
            &MSG
        ),
    );
}


sub MSG ( $id, $args = undef ) {
    return           unless exists $MSG{$id};
    return $MSG{$id} unless defined $args;
    return sprintf $MSG{$id}, $args->@*;
}

1;
