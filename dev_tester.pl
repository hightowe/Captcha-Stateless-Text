#!/usr/bin/perl

use strict;
use lib './lib';
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
use Captcha::Stateless::Text;

my $captcha = Captcha::Stateless::Text->new();
$captcha->set_iv('gkbx5g9hsvhqrosg');                  # Must be 16 bytes / 128 bits
$captcha->set_key('tyDjb39dQ20pdva0lTpyuiowWfxSSwa9'); # 32 bytes / 256 bits (AES256)
my $ep_pre = $captcha->get_ep_pre();

my $qa={};
foreach my $type (qw(chars math)) {
  $qa->{$type} = get_QA_array($type);
}
$qa->{chars_small} = $captcha->getQA_chars(2,6);
print Dumper($qa)."\n";


sub get_QA_array($$) {
  my $type = shift @_;
  my $funcname = 'getQA_'.$type;
  {
    no strict 'refs';
    return $captcha->$funcname();
  }
}

my $tests = {
  'chars_invalid' => {
    'a' => 'GVS',
      'enc_payload' => $ep_pre.'qctvYSVBfjzYh1V0DfrZ23Yd_-nmOHbJdC7JUlUKMfZ6I13qt2R5vSePdWS0vAJS1Z3WgeK-q1s5U3BOv2F8XqYmnoCjfHX8f5Q83AjexhO_FRAi_3rl40PPdx2RR6rf',
      'q' => 'Provide the second, third, and sixth characters from B-G-Q-E-O-S',
      'a_real' => 'GQS',
    },
  'math_invalid' => {
    'a' => 6,
      'enc_payload' => $ep_pre.'HjSg-HEJJMMIj55rDfyLOehzmhzpepwvZU8kOePW5Sk',
      'q' => '7 + 3',
      'a_real' => '10',
    },
  'chars' => {
    'a' => 'GQS',
      'enc_payload' => $ep_pre.'qctvYSVBfjzYh1V0DfrZ23Yd_-nmOHbJdC7JUlUKMfZ6I13qt2R5vSePdWS0vAJS1Z3WgeK-q1s5U3BOv2F8XqYmnoCjfHX8f5Q83AjexhO_FRAi_3rl40PPdx2RR6rf',
    },
  'math' => {
    'a' => 10,
      'enc_payload' => $ep_pre.'HjSg-HEJJMMIj55rDfyLOehzmhzpepwvZU8kOePW5Sk',
    },
  };

foreach my $test (sort keys %{$tests}) {
  my $this_test = $tests->{$test};
  my $is_valid = $captcha->validate($this_test->{a}, $this_test->{enc_payload});
  print "$test is_valid=$is_valid: ".Dumper($this_test)."\n";
}

