#
# AUTHOR: Paul Williams <kwakwa@cpan.org>
# REQUIRES: build-essential, curl, git
# LICENSE: Apache License 2.0
#
# A Rex module to install plenv and cpanm on your Server.

package Rex::Plenv::Base;

use Rex -base;
use Rex::Ext::ParamLookup;

our %version_map = (
  debian => "5.24.0",
  ubuntu => "5.24.0",
  centos => "5.24.0",
  redhat => "5.24.0",
);

# The prepare task needs root privileges. Run as root.
task prepare => make {
  pkg [qw/build-essential curl git/], ensure => "latest";
};

task setup => make {
  my $perl_version = param_lookup "perl_version",
    $version_map{ lc get_operating_system };

  # Commands taken from
  #
  # http://weblog.bulknews.net/post/58079418600/plenv-alternative-for-perlbrew
  # https://github.com/tokuhirom/plenv#readme

  # Check out plenv into ~/.plenv
  run 'ls ~/.plenv';
  if ($? == 0) {
    Rex::Logger::info "plenv has already been installed";
  }
  else {
    run 'git clone git://github.com/tokuhirom/plenv.git ~/.plenv';
  }

  # Add ~/.plenv/bin to your $PATH for access to the plenv command-line utility.
  # Add plenv init to your shell to enable shims and autocompletion.
  run 'touch ~/.bash_profile';
  append_if_no_such_line '~/.bash_profile', 'export PATH="$HOME/.plenv/bin:$PATH"';
  append_if_no_such_line '~/.bash_profile', 'eval "$(plenv init -)"';

  # Install perl-build, which provides a plenv install command that simplifies
  # the process of installing new Perl versions.
  run 'ls ~/.plenv/plugins/perl-build/';
  if ($? == 0) {
    Rex::Logger::info "perl-build has already been installed";
  }
  else {
    run 'git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/';
  }

  # Additional commands to make plenv more perlbrew-like
  # run 'git clone git://github.com/miyagawa/plenv-contrib.git ~/.plenv/plugins/plenv-contrib/';

  # Add ~/plenv/bin to the Rex $PATH so it will be used for plenv commands
  my @new_path;
  push(@new_path, '$HOME/.plenv/bin');
  push(@new_path, Rex::Config->get_path);
  Rex::Config->set_path(\@new_path);

  # Install perl!
  run "plenv versions |grep $perl_version";    # this is probably a bug
  if ($? == 0) {
    Rex::Logger::info "perl-$perl_version has already been installed";
  }
  else {
    run "plenv install $perl_version";
  }

  # Because all perl-based scripts (prove, plackup etc.) are also wrapped as
  # shims, you have to run plenv rehash after installing CPAN modules that have
  # scripts. But if you run plenv install-cpanm to bootstrap cpanminus, it will
  # be automatically taken care of.
  run "plenv rehash";

  run "PLENV_VERSION=$perl_version plenv which cpanm";
  if ($? == 0) {
    Rex::Logger::info "cpanm has already installed for perl-$perl_version";
  }
  else {
    run "PLENV_VERSION=$perl_version plenv install-cpanm";
  }
};

1;
