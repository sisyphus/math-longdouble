## This file generated by InlineX::C2XS (version 0.22) using Inline::C (version 0.5002)
package Math::LongDouble;
use warnings;
use Config;
use strict;
use POSIX;

require Exporter;
*import = \&Exporter::import;
require DynaLoader;

use overload
  '+'     => \&_overload_add,
  '*'     => \&_overload_mul,
  '-'     => \&_overload_sub,
  '/'     => \&_overload_div,
  '**'    => \&_overload_pow,
  '+='    => \&_overload_add_eq,
  '*='    => \&_overload_mul_eq,
  '-='    => \&_overload_sub_eq,
  '/='    => \&_overload_div_eq,
  '**='   => \&_overload_pow_eq,
  '=='    => \&_overload_equiv,
  '""'    => \&_overload_string,
  '!='    => \&_overload_not_equiv,
  'bool'  => \&_overload_true,
  '!'     => \&_overload_not,
  '='     => \&_overload_copy,
  '<'     => \&_overload_lt,
  '<='    => \&_overload_lte,
  '>'     => \&_overload_gt,
  '>='    => \&_overload_gte,
  '<=>'   => \&_overload_spaceship,
  'abs'   => \&_overload_abs,
  'int'   => \&_overload_int,
  'sqrt'  => \&_overload_sqrt,
  'log'   => \&_overload_log,
  'exp'   => \&_overload_exp,
  'sin'   => \&_overload_sin,
  'cos'   => \&_overload_cos,
  'atan2' => \&_overload_atan2,
  '++'    => \&_overload_inc,
  '--'    => \&_overload_dec,
;

use constant LITTLE_ENDIAN          => $Config{byteorder} =~ /^1/ ? 1 : 0;
use constant MLD_HP                 => LITTLE_ENDIAN ? 'h*' : 'H*';

use subs qw(
            LD_DBL_DIG LD_LDBL_DIG LD_DBL_MANT_DIG LD_LDBL_MANT_DIG

            LD_DBL_MIN_EXP LD_DBL_MAX_EXP LD_DBL_MIN_10_EXP LD_DBL_MAX_10_EXP
            LD_DBL_MAX LD_DBL_MIN LD_DBL_EPSILON LD_DBL_DENORM_MIN

            LD_LDBL_MIN_EXP LD_LDBL_MAX_EXP LD_LDBL_MIN_10_EXP LD_LDBL_MAX_10_EXP
            LD_LDBL_MAX LD_LDBL_MIN LD_LDBL_EPSILON LD_LDBL_DENORM_MIN

            M_El M_LOG2El M_LOG10El M_LN2l M_LN10l M_PIl M_PI_2l M_PI_4l
            M_1_PIl M_2_PIl  M_2_SQRTPIl M_SQRT2l M_SQRT1_2l
            );

our $VERSION = '0.27';
#$VERSION = eval $VERSION;

Math::LongDouble->DynaLoader::bootstrap($Math::LongDouble::VERSION);

my @tagged = qw(
    InfLD NaNLD ZeroLD UnityLD is_NaNLD is_InfLD is_ZeroLD STRtoLD LDtoSTR NVtoLD UVtoLD IVtoLD
    LDtoNV LDtoLD cmp_NV
    ld_set_prec ld_get_prec LDtoSTRP
    LD_DBL_DIG LD_LDBL_DIG LD_DBL_MANT_DIG LD_LDBL_MANT_DIG

    LD_DBL_MIN_EXP LD_DBL_MAX_EXP LD_DBL_MIN_10_EXP LD_DBL_MAX_10_EXP
    LD_DBL_MAX LD_DBL_MIN LD_DBL_EPSILON LD_DBL_DENORM_MIN

    LD_LDBL_MIN_EXP LD_LDBL_MAX_EXP LD_LDBL_MIN_10_EXP LD_LDBL_MAX_10_EXP
    LD_LDBL_MAX LD_LDBL_MIN LD_LDBL_EPSILON LD_LDBL_DENORM_MIN

    M_El M_LOG2El M_LOG10El M_LN2l M_LN10l M_PIl M_PI_2l M_PI_4l
    M_1_PIl M_2_PIl  M_2_SQRTPIl M_SQRT2l M_SQRT1_2l

    ld_max_orig_len ld_min_inter_prec ld_bytes

    llrint_LD llround_LD lrint_LD lround_LD frexp_LD nan_LD remquo_LD
    acos_LD acosh_LD asin_LD asinh_LD atan_LD atanh_LD atan2_LD cbrt_LD ceil_LD
    copysign_LD cosh_LD cos_LD erf_LD erfc_LD exp_LD expm1_LD finite_LD fabs_LD
    fdim_LD floor_LD fma_LD fmax_LD fmin_LD fmod_LD hypot_LD isinf_LD
    ilogb_LD isnan_LD ldexp_LD lgamma_LD  log_LD log10_LD
    log2_LD log1p_LD modf_LD nearbyint_LD nextafter_LD
    pow_LD powq_LD remainder_LD  rint_LD round_LD scalbln_LD scalbn_LD signbit_LD
    sincos_LD sinh_LD sin_LD sqrt_LD tan_LD tanh_LD tgamma_LD trunc_LD
    );
@Math::LongDouble::EXPORT = ();
@Math::LongDouble::EXPORT_OK = @tagged;
%Math::LongDouble::EXPORT_TAGS = (all => \@tagged);

my $fmt = "a" . Math::LongDouble::_get_actual_ldblsize();

sub dl_load_flags {0} # Prevent DynaLoader from complaining and croaking

sub _overload_string {

    if(is_ZeroLD($_[0])) {
      return '-0' if is_ZeroLD($_[0]) < 0;
      return '0';
    }

    if(is_NaNLD($_[0])) {return 'NaN'}
    my $inf = is_InfLD($_[0]);
    return '-Inf' if $inf < 0;
    return 'Inf'  if $inf > 0;

    my @p = split /e/i, LDtoSTR($_[0]);
    while(substr($p[0], -1, 1) eq '0' && substr($p[0], -2, 1) ne '.') {
      chop $p[0];
    }
    return $p[0] . 'e' . $p[1];
}

sub new {

    # This function caters for 2 possibilities:
    # 1) that 'new' has been called OOP style - in which
    #    case there will be a maximum of 2 args
    # 2) that 'new' has been called as a function - in
    #    which case there will be a maximum of 1 arg.
    # If there are no args, then we just want to return a
    # Math::LongDouble object that's a NaN.

    if(!@_) {return NaNLD()}

    if(@_ > 2) {die "More than 2 arguments supplied to new()"}

    # If 'new' has been called OOP style, the first arg is the string
    # "Math::LongDouble" which we don't need - so let's remove it. However,
    # if the first arg is a Math::LongDouble object (which is a possibility),
    # then we'll get a fatal error when we check it for equivalence to
    # the string "Math::LongDouble". So we first need to check that it's
    # not an object - which we'll do by using the ref() function:
    if(!ref($_[0]) && $_[0] eq "Math::LongDouble") {
      shift;
      if(!@_) {return NaNLD()}
      }

    if(@_ > 1) {die "Too many arguments supplied to new() - expected no more than 1"}

    my $arg = shift;
    my $type = _itsa($arg);

    return UVtoLD ($arg) if $type == 1;    # UV
    return IVtoLD ($arg) if $type == 2;    # IV
    return NVtoLD ($arg) if $type == 3;    # NV
    return STRtoLD($arg) if $type == 4;    # PV
    return LDtoLD ($arg) if $type == 96;   # Math::LongDouble object

    die "Bad argument given to new()";
}

sub LD_DBL_DIG		() {return _DBL_DIG()}
sub LD_DBL_MANT_DIG	() {return _DBL_MANT_DIG()}
sub LD_DBL_MAX		() {return _DBL_MAX()}
sub LD_DBL_MIN		() {return _DBL_MIN()}
sub LD_DBL_EPSILON	() {return _DBL_EPSILON()}
sub LD_DBL_DENORM_MIN	() {return _DBL_DENORM_MIN()}
sub LD_DBL_MIN_EXP	() {return _DBL_MIN_EXP()}
sub LD_DBL_MAX_EXP	() {return _DBL_MAX_EXP()}
sub LD_DBL_MIN_10_EXP	() {return _DBL_MIN_10_EXP()}
sub LD_DBL_MAX_10_EXP	() {return _DBL_MAX_10_EXP()}

sub LD_LDBL_DIG		() {return _LDBL_DIG()}
sub LD_LDBL_MANT_DIG	() {return _LDBL_MANT_DIG()}
sub LD_LDBL_MAX		() {return _LDBL_MAX()}
sub LD_LDBL_MIN		() {return _LDBL_MIN()}
sub LD_LDBL_EPSILON	() {return _LDBL_EPSILON()}
sub LD_LDBL_DENORM_MIN	() {return _LDBL_DENORM_MIN()}
sub LD_LDBL_MIN_EXP	() {return _LDBL_MIN_EXP()}
sub LD_LDBL_MAX_EXP	() {return _LDBL_MAX_EXP()}
sub LD_LDBL_MIN_10_EXP	() {return _LDBL_MIN_10_EXP()}
sub LD_LDBL_MAX_10_EXP	() {return _LDBL_MAX_10_EXP()}

sub M_El		() {return _M_El()}
sub M_LOG2El		() {return _M_LOG2El()}
sub M_LOG10El		() {return _M_LOG10El()}
sub M_LN2l		() {return _M_LN2l()}
sub M_LN10l		() {return _M_LN10l()}
sub M_PIl		() {return _M_PIl()}
sub M_PI_2l		() {return _M_PI_2l()}
sub M_PI_4l		() {return _M_PI_4l()}
sub M_1_PIl		() {return _M_1_PIl()}
sub M_2_PIl		() {return _M_2_PIl()}
sub M_2_SQRTPIl		() {return _M_2_SQRTPIl()}
sub M_SQRT2l		() {return _M_SQRT2l()}
sub M_SQRT1_2l		() {return _M_SQRT1_2l()}

sub ld_min_inter_prec {
    die "Wrong number of args to mpfr_min_inter_prec()" unless @_ == 3;
    my $ob = shift; # base of original representation
    my $op = shift; # precision (no. of base $ob digits in mantissa) of original representation
    my $nb = shift; # base of new representation
    my $np;         # min required precision (no. of base $nb digits in mantissa) of new representation

    my %h = (2 => 1, 4 => 2, 8 => 3, 16 => 4, 32 => 5, 64 => 6,
             3 => 1, 9 => 2, 27 => 3,
             5 => 1, 25 => 2,
             6 => 1, 36 => 2,
             7 => 1, 49 => 2);

    return $op
      if $ob == $nb;

    if(_bases_are_power_of_same_integer($ob, $nb)) {
      $np = POSIX::ceil($op * $h{$ob} / $h{$nb});
      return $np;
    }

    $np = POSIX::ceil(1 + ($op * log($ob) / log($nb)));
    return $np;
}

sub ld_max_orig_len {
    die "Wrong number of args to maximum_orig_length()" if @_ != 3;
    my $ob = shift; # base of original representation
    my $nb = shift; # base of new representation
    my $np = shift; # precision (no. of base $nb digits in mantissa) of new representation
    my $op;         # max precision (no. of base $ob digits in mantissa) of original representation

    my %h = (2 => 1, 4 => 2, 8 => 3, 16 => 4, 32 => 5, 64 => 6,
             3 => 1, 9 => 2, 27 => 3,
             5 => 1, 25 => 2,
             6 => 1, 36 => 2,
             7 => 1, 49 => 2);

    return $np
      if $ob == $nb;

    if(_bases_are_power_of_same_integer($ob, $nb)) {
      $op = POSIX::floor($np * $h{$nb} / $h{$ob});
      return $op;
    }

    $op = POSIX::floor(($np - 1) * log($nb) / log($ob));
    return $op;
}

sub _bases_are_power_of_same_integer {

  # This function currently doesn't get called if $_[0] == $_[1]
  # Return true if:
  # 1) Both $_[0] and $_[1] are in the range 2..64 (inclusive)
  #    &&
  # 2) Both $_[0] and $_[1] are powers of the same integer - eg 8 & 32, or 9 & 27, or 7 & 49, ....
  # Else return false.

  return 1
    if( ($_[0] == 2 || $_[0] == 16 || $_[0] == 8 || $_[0] == 64 || $_[0] == 32 || $_[0] == 4)
           &&
        ($_[1] == 2 || $_[1] == 16 || $_[1] == 8 || $_[1] == 64 || $_[1] == 32 || $_[1] == 4) );

  return 1
    if( ($_[0] == 3 || $_[0] == 9 || $_[0] == 27)
           &&
        ($_[1] == 3 || $_[1] == 9 || $_[1] == 27) );

  return 1
    if( ($_[0] == 5 || $_[0] == 25)
           &&
        ($_[1] == 5 || $_[1] == 25) );

  return 1
    if( ($_[0] == 6 || $_[0] == 36)
           &&
        ($_[1] == 6 || $_[1] == 36) );

  return 1
    if( ($_[0] == 7 || $_[0] == 49)
           &&
        ($_[1] == 7 || $_[1] == 49) );

  return 0;
}

sub ld_bytes {
  my $ret = unpack MLD_HP, pack $fmt, _ld_bytes($_[0]);
  return scalar reverse $ret if LITTLE_ENDIAN;
  return $ret;
}

1;

__END__

