use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my @ppd;
if ($] >= 5.00503) {
	@ppd = (
		AUTHOR    => 'Henrique Dias <hdias@esb.ucp.pt>',
		ABSTRACT  => 'Yet Another Templete System'
	);
}

WriteMakefile(
	'NAME'      => "Text::Yats",
	'DISTNAME'  => "Text-Yats",
	'VERSION_FROM' => "Yats.pm", # finds $VERSION
	'dist' => {  
		COMPRESS => "gzip -9f",
		SUFFIX => "gz",
		},
	@ppd
);
