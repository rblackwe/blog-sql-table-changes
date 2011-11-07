use Module::Build;
my $build = Module::Build->new
    (
     module_name => 'Testx::DB::What_Changed',
     license  => 'perl',
     requires => {
                  'perl'          	=> '5.10.1',
                  'DBI'  		=> '>= 1.616',
                  'Moose' 		=> '>= 2.0007', 
                  'Data::Dumper' 	=> '>= 1.124',
                 },
    );
  $build->create_build_script;
