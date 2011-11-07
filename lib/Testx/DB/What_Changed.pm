=pod

=head1 NAME

Testx::DB::What_Changed - Inventory a database, make a change, inventory database a secondtime, confirm what changed.

=head1 VERSION

version 0.01

=head1 EXAMPLES

prove -v t :: --server SERVER --username USERNAME --password PASSWORD --changer Change_DB

=cut

package Testx::DB::What_Changed;
use lib './lib';
use Moose;
use DBI;
use Data::Dumper;

with 'MooseX::Getopt';

has 'server'    => (is => 'rw', isa => 'Str', required => 1);
has 'username'  => (is => 'rw', isa => 'Str', required => 1);
has 'password'  => (is => 'rw', isa => 'Str', required => 1);
has 'changer'   => (is => 'rw', isa => 'Str', required => 1);
has 'dbh'       => (is => 'rw', isa => 'DBI', required => 0);

sub change_db {
    	my $self = shift;
	with $self->changer;
	$self->do_db_change();
	return 1;
}

sub connectdb {
    	my $self = shift;
	my $dsn = sprintf("dbi:%s:server=%s;","Sybase",$self->server);
	my $dbh = DBI->connect($dsn, "" . $self->username, $self->password, { ChopBlanks => 1 } ) or die "oops: $@ $!\n";
	$self->{dbh} = $dbh;
	return 1;
}


sub get_table_counts {
    	my $self = shift;
	return {};
        my %tables;
        my @tables = $self->{dbh}->tables(); 
        foreach my $table (@tables) {
                my $query = "SELECT count(*) as table_count FROM $table";
                my $sth = $self->{dbh}->prepare ($query) or die "prepare failed\n";
                $sth->execute() or die "unable to execute query $query   error $DBI::errstr";
                my $row = $sth->fetchrow_hashref();
                $tables{$table} = $row->{table_count};
        }
        return \%tables;
}



1;
