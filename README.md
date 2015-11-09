# Rex::Plenv::Base

A Rex module to install plenv (perl binary manager) and cpanm.

# USAGE

```perl
include qw/Rex::Plenv::Base/;

task prepare => sub {
  Rex::Plenv::Base::prepare();
};

auth for => 'prepare' => user => 'root';

task setup => sub {
  Rex::Plenv::Base::setup();
};
```

## meta.yml

In the folder for the rex service you're creating, add a `meta.yml` file with something that looks like the following.

```perl
Name: Some frontend service
Description: The frontend service for something
Author: Paul Williams <kwakwaATcpan.org>
Require:
  Rex::Plenv::Base:
    git: https://github.com/kwakwaversal/rex-plenv-base.git
    branch: master
```

Once all your dependencies are configured for the service, run `rexify --resolve-deps` to bundle the module.

# See also
 * [Rex::NTP::Base](https://github.com/krimdomu/rex-ntp-base.git)
 * [Rex::OS::Base](https://github.com/krimdomu/rex-os-base.git)
 * [Example of a complete Rex code infrastructure](http://www.rexify.org/docs/rex_book/infrastructure/example_of_a_complete_rex_code_infrastructure.html)
