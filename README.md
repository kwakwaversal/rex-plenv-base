# Rex::Plenv::Base

A Rex module to install plenv (perl binary manager) and cpanm.

# USAGE

```perl
include qw/Rex::Plenv::Base/;

task setup => make {
  Rex::Plenv::Base::setup();
};
```

# See also
 * [Rex::NTP::Base](https://github.com/krimdomu/rex-ntp-base.git)
 * [Rex::OS::Base](https://github.com/krimdomu/rex-os-base.git)
 * [Example of a complete Rex code infrastructure](http://www.rexify.org/docs/rex_book/infrastructure/example_of_a_complete_rex_code_infrastructure.html)
