# Rex::Plenv::Base

A Rex module to install plenv (perl binary manager) and cpanm.

# USAGE

```perl
include qw/Rex::Rex::Base/;

task setup => make {
  Rex::Rex::Base::setup();
};
```

# See also

http://www.rexify.org/docs/rex_book/infrastructure/example_of_a_complete_rex_code_infrastructure.html
