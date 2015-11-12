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
  Rex::Plenv::Base::prepare();
};

auth for => 'prepare' => user => 'root';

task setup => sub {
  Rex::Plenv::Base::setup();
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

# See also
 * [Rex::NTP::Base](https://github.com/krimdomu/rex-ntp-base.git)
 * [Rex::OS::Base](https://github.com/krimdomu/rex-os-base.git)
 * [Example of a complete Rex code infrastructure](http://www.rexify.org/docs/rex_book/infrastructure/example_of_a_complete_rex_code_infrastructure.html)
