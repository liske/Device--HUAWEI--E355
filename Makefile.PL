use ExtUtils::MakeMaker;
WriteMakefile(
  NAME      => q{Device::HUAWEI::E355},
  VERSION_FROM => q{lib/Device/HUAWEI/E355.pm},
  PREREQ_PM => {
                 strict            => 0,
                 vars              => 0,
                 Exporter          => 0,
                 XML::TreePP       => 0,
               },
               ($] >= 5.005 ? 
                 (
                   ABSTRACT_FROM => 'lib/Device/HUAWEI/E355.pm',
                 ) : ()
               ),
             );
