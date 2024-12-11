# powl() is generally buggy (in the underlying math library C implementation) to the extent
# that it returns incorrect results for some arguments.
# Using powq() works much better - so we use it in overloading of '**' and '**=' operations
# if it's available (in which case USE_POWQ will be defined) && if it has been requested
# ( which is done by providing a command line argument of ALLOW_POWQ_OLOAD to the
# 'perl Makefile.PL' step).
# See the powq_LD documentation for additional info.
# A number of these "overloading" tests would generally FAIL if powl() is used in the overloading.

use strict;
use warnings;
use Math::LongDouble qw(:all);

use Test::More;

if( Math::LongDouble::_use_powq() && Math::LongDouble::_allow_powq_oload) {
  my($rop1, $rop2) = (Math::LongDouble->new(10), Math::LongDouble->new(10));
  for my $p(1..4955) {
     cmp_ok(Math::LongDouble->new("1e$p"), '==', Math::LongDouble->new(10) ** $p, "10 ** $p ok");
     cmp_ok(Math::LongDouble->new("1e-$p"), '==', Math::LongDouble->new(10) ** -$p, "10 ** -$p ok");

     $rop1 **= $p;
     cmp_ok(Math::LongDouble->new("1e$p"), '==', $rop1, "10 **= $p ok");

     $rop2 **= -$p;
     cmp_ok(Math::LongDouble->new("1e-$p"), '==', $rop2, "10 **= -$p ok");

     $rop1 = UVtoLD(10);
     $rop2 = UVtoLD(10);
  }

}
elsif(Math::LongDouble::_use_powq()) {
  my $ld = Math::LongDouble->new('10');
  powq_LD($ld, $ld, Math::LongDouble->new('-298'));
  like("$ld", qr/^9.99999999999999999985e-299$/i, 'powq_LD evaluates 10 ** -298 correctly');

}
else {
  is(1, sqrt(1));
  warn "\nSkipping all tests for exactness because USE_POWQ and ALLOW_POWQ_OLOAD was not defined.\n";
}

done_testing();
