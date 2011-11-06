package My::App;
use Moose;

with 'MooseX::Getopt';

has 'server'    => (is => 'rw', isa => 'Str', required => 1);
has 'username'  => (is => 'rw', isa => 'Str', required => 1);
has 'password'  => (is => 'rw', isa => 'Str', required => 1);

use Test::More;
use DBI;
use Test::Deep;
use Data::Dumper;

my $app = My::App->new_with_options();
note "server "   . $app->server;
note "username " . $app->username;

my $dsn = sprintf("dbi:%s:server=%s;","Sybase",$app->server);
note "dsn $dsn";
my $dbh = DBI->connect($dsn, $app->username, $app->password, { ChopBlanks => 1 } ) or die "oops: $@ $!\n";

my $before_insert = _get_table_counts();
diag "do db changes";
my $wait = <>;
my $after_insert = _get_table_counts();
#The only changes should be ..
#$before_insert->{...}++;
is_deeply($after_insert, $before_insert);# or diag explain $have;
done_testing();
exit;

sub _get_table_counts {
        my %tables;
        my @tables = $dbh->tables(); 
        foreach my $table (@tables) {
                my $query = "SELECT count(*) as table_count FROM $table";
                my $sth = $dbh->prepare ($query) or die "prepare failed\n";
                $sth->execute() or die "unable to execute query $query   error $DBI::errstr";
                my $row = $sth->fetchrow_hashref();
                $tables{$table} = $row->{table_count};
        }
        return \%tables;
}


