use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
     'NAME'         => 'Captcha::Stateless::Text',
     'DISTNAME'     => 'Captcha-Stateless-Text',
     'VERSION_FROM' => 'lib/Captcha/Stateless/Text.pm',
     'LICENSE'      => 'artistic_2',
     'AUTHOR'       => 'Lester Hightower <hightowe@cpan.org>',
     'dist'         => {'COMPRESS'=>'zip', 'SUFFIX' => '.zip'}
);

print "\n";
print "Do a 'make test' to test the module before installation\n";
print "Do a 'make install' to install the module.\n";

