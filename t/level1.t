use Text::Yats;

print "1..5\n";

print "ok 1\n";

my $tpl = Text::Yats->new(
		level => 1,
		file  => "templates/form.html") or print "not ";

print "ok 2\n";

$tpl->section->[0]->replace(
		title      => "Yats",
		version    => "0.01", ) or print "not ";

print "ok 3\n";

$tpl->section->[1]->replace(
		list       => ['hdias','anita','cubitos'],
		selected   => { value => "selected",
				array => "list",
				match => "anita", }) or print "not ";

print "ok 4\n";

$tpl->section->[2]->text or print "not ";

print "ok 5\n";

undef $tpl;
