use strict;
use warnings;
use Math::LongDouble qw(:all);

use Test::More;

if(Math::LongDouble->new('1e-298') == Math::LongDouble->new(10) ** -298 ||
   Math::LongDouble::_use_powq() == 1) {

   for my $p(1..4955) {
      cmp_ok(Math::LongDouble->new("1e$p"), '==', Math::LongDouble->new(10) ** $p, "10 ** $p ok");
      cmp_ok(Math::LongDouble->new("1e-$p"), '==', Math::LongDouble->new(10) ** -$p, "10 ** -$p ok");
   }

}
else {
  is(1, sqrt(1));
  warn "Skipping all tests for exactness because:\n 1) the C library function powl() is buggy;\n and\n 2) the powq() function is either unavailable or was explicitly rejected .\n\n";
}

done_testing();
