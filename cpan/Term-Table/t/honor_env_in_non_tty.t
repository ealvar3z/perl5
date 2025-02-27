use strict;
use warnings;

BEGIN {
    if (eval 'use  Test2::Tools::Tiny 1.302097; 1; ' ) {
        print "# Using Test2::Tools::Tiny\n";
    }
    elsif (eval { require Test::More; Test::More->can('done_testing') ? 1 : 0 }) {
        print "# Using Test::More " . Test::More->VERSION . "\n";
        Test::More->import();
    }
    else {
        print "1..0 # SKIP Neither Test2::Tools::Tiny nor a sufficient Test::More is installed\n";
        exit(0);
    }
}

BEGIN {
    my $out = "";
    local *STDOUT;
    open(*STDOUT, '>', \$out) or die "Could not open a temp STDOUT: $!";
    ok(!-t *STDOUT, "STDOUT is not a term");

    require Term::Table::Util;
    Term::Table::Util->import(qw/term_size USE_TERM_READKEY USE_TERM_SIZE_ANY/);
}

ok(!USE_TERM_READKEY, "Not using Term::Readkey without a term");
ok(!USE_TERM_SIZE_ANY, "Not using Term::Size::Any without a term");

{
    local $ENV{TABLE_TERM_SIZE};
    is(term_size, Term::Table::Util->DEFAULT_SIZE, "Get default size without the var");
}

{
    local $ENV{TABLE_TERM_SIZE} = 1234;
    is(term_size, 1234, "Used the size in the env var");
}

done_testing;
