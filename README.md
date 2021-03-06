# Rex::Plenv::Base

A Rex module to install [plenv](https://github.com/tokuhirom/plenv) (perl binary
manager) which automatically runs `plenv install-cpanm` after setup is complete.

You probably don't want to install plenv as the root user, so the tasks which
require root permission, and those that do not, have been split into the
`Rex::Plenv::Base::prepare()` and the `Rex::Plenv::Base::setup()` functions
respectively.

*N.B., This doesn't prevent you from installing as root, it just makes it easier
when you are not.*

# USAGE

## Rexfile

```perl
include qw/Rex::Plenv::Base/;

# prepare holds root-specific commands that need running first
task prepare => sub {
  Rex::Plenv::Base::prepare(@_);  # @_ required for Rex::Ext::ParamLookup
};

auth for => 'prepare' => user => 'root';

task setup => sub {
  Rex::Plenv::Base::setup(@_);    # @_ required for Rex::Ext::ParamLookup
};
```

Once you have your service's Rexfile created, you need to run your tasks.

```bash
ssh-copy-id root@yourhost.org
rex -H yourhost.org prepare   # will run this as -u root automatically
ssh-copy-id someuser@yourhost.org
rex -H yourhost.org -u someuser setup
```

## meta.yml

In the folder for the Rex service you're creating, add a `meta.yml` file with
something that looks like the following.

```perl
Name: Some frontend service
Description: The frontend service for something
Author: Paul Williams <kwakwa@cpan.org>
Require:
  Rex::Plenv::Base:
    git: https://github.com/kwakwaversal/rex-plenv-base.git
    branch: master
```

Once all your dependencies are configured for the service, run `rexify
--resolve-deps` to bundle the module.

## Options

If you want to install a specific version of Perl, you can pass the optional
task parameter `--perl_version=5.20.0`.

```bash
ssh-copy-id someuser@yourhost.org
rex -H yourhost.org -u someuser setup --perl_version=5.22.0
```

# Additional configuration

If you have a firewall, and need to punch a hole in it to be able to install
plenv, the configuration below might/should help.

## iptables

```bash
-A FORWARD -o eth0 -j PLENV-ENV
-A PLENV-ENV -m state --state ESTABLISHED,RELATED -j ACCEPT
-A PLENV-ENV -d 192.30.252.0/22 -p tcp -m tcp --dport 22    -m comment --comment "ssh://github.com" -j ACCEPT
-A PLENV-ENV -d 192.30.252.0/22 -p tcp -m tcp --dport 443   -m comment --comment "https://github.com" -j ACCEPT
-A PLENV-ENV -d 192.30.252.0/22 -p tcp -m tcp --dport 9418  -m comment --comment "git://github.com" -j ACCEPT
-A PLENV-ENV -d 207.171.7.91    -p tcp -m tcp --dport 80    -m comment --comment "cpan.org" -j ACCEPT
-A PLENV-ENV -d 94.242.223.198  -p tcp -m tcp --dport 80    -m comment --comment "cpan.org" -j ACCEPT
```

# See also
 * [Rex::NTP::Base](https://github.com/krimdomu/rex-ntp-base.git)
 * [Rex::OS::Base](https://github.com/krimdomu/rex-os-base.git)
 * [Example of a complete Rex code infrastructure](http://www.rexify.org/docs/rex_book/infrastructure/example_of_a_complete_rex_code_infrastructure.html)
