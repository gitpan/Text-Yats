#---------------------------------------------------------------------
# Yats.pm
# Last Modification: 2001/12/20 (hdias@esb.ucp.pt)
#
# Copyright (c) 2001 Henrique Dias. All rights reserved.
# This module is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#---------------------------------------------------------------------
package Text::Yats;
use strict;
require Exporter;
use vars qw($VERSION @ISA @EXPORT);
@ISA = qw(Exporter DynaLoader);
$VERSION = 0.01;
require 5;

sub new {
	my $proto = shift;
	my $class = ref($proto) || $proto;
	my $self  = {
		section => [],
		level   => 0,
		file    => "",
		text    => "",
		base    => '\\d+',
		pattern => '\\d+',
		@_,
	};
	bless ($self, $class);

	$self->{text} = &get_text($self->{'file'}) if($self->{file});
	my $sections = ($self->{level} > 0) ? $self->wrapper() : [];
	if($#{$sections} > 0) {
		$self->{level}--;
		$self->{pattern} .= '\\.' . $self->{base};
		for(0 .. $#{$sections}) {
			$self->{section}->[$_] = $self->new(
				'level'   => $self->{level},
				'pattern' => $self->{pattern},
				'text'    => $sections->[$_]);
		}
	}
	return($self);
}

sub section { $_[0]->{'section'}; }

sub replace {
	my $self = shift;
	my $param = {@_};

	my $text = "";
	my $max = 0;
	my $i = 0;
	my $pattern = '\$(\w+) *<!--\(((?:(?!\)-->).)+)\)-->';
	LOOP: while(1) {
		my $tmp = $self->{text};
		while($tmp =~ s/$pattern/\$$1/o) {
			$self->{text} = $tmp;
			$param->{$1} = [eval($2)];
		}
		for(keys(%{$param})) {
			if(ref($param->{$_}) eq "HASH") {
				my @matched = ();
				my $match = "";
				for my $e (@{$param->{$param->{$_}->{array}}}) {
					$match = ($e eq $param->{$_}->{match}) ? $param->{$_}->{value} : "";
					push(@matched, $match);
					last if($match);
				}
				$param->{$_} = \@matched;
			}
			if(ref($param->{$_}) eq "ARRAY") {
				my $maxtmp = $#{$param->{$_}};
				$max = $maxtmp unless($i && ($maxtmp <= $max));
				$param->{$_}->[$i] = "" if($i > $maxtmp);
				$tmp =~ s/\$$_\b/$param->{$_}->[$i]/g;
				$tmp =~ s/ +>/>/g;
			} else { $tmp =~ s/\$$_\b/$param->{$_}/g; }
		}
		$text .= $tmp;
		last LOOP if($i == $max);
		$i++;
	}
	return($text);
}

sub text {
	my $self = shift;
	return($self->{text});
}

sub wrapper {
	my $self = shift;
	my $pattern = '<!--{' . $self->{pattern} . '}-->\n*';
	my $re = qr/$pattern/;
	my @sections = split(/$re/, $self->{text});
	return(\@sections);
}

sub get_text {
	my $filename = shift;

	local $/ = undef;
	local *FILE;
	open (FILE, "<$filename") || die "Can't open $filename: $!\n";
	my $text = <FILE>;
	close(FILE);
	return($text);
}

1;

__END__
