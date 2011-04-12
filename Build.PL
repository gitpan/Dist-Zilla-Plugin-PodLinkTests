
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0.96'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Deprecated',
  'dist_author' => [
    'Randy Stauner <rwstauner@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-Plugin-PodLinkTests',
  'dist_version' => '1.006',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::Plugin::PodLinkTests',
  'recommends' => {
    'Test::Pod::No404s' => '0.01'
  },
  'recursive_test_files' => 1,
  'requires' => {
    'Dist::Zilla::Plugin::InlineFiles' => '0',
    'Moose' => '0',
    'Moose::Util::TypeConstraints' => '1.01',
    'Test::Pod::LinkCheck' => '0.004',
    'perl' => '5.006'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
