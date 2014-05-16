package Catmandu::Fix::get_json;
#ABSTRACT: get JSON data from an URL as fix function

use Catmandu::Sane;
use Moo;
use Catmandu::Fix::Has;
use Catmandu::Importer::getJSON;

with "Catmandu::Fix::Base";

has url => (fix_arg => 1);
has path => (fix_opt => 1, default => sub {""});
has dry => (fix_opt => 1);
has importer => (is => 'ro', lazy => 1, builder => 1);

sub _build_importer {
	my $self = shift;
	Catmandu::Importer::getJSON->new(
        from => $self->url,
        dry  => $self->dry,
    );
}

sub emit {
    my ($self, $fixer) = @_;
    my $path = $fixer->split_path($self->path);
    my $generator_var = $fixer->capture($self->importer->generator);

    $fixer->emit_create_path($fixer->var, $path, sub {
        my $var = shift;
        "${var} = ${generator_var}->();";
    });
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::Fix::get_json - get JSON data from an URL as fix function

=head1 VERSION

version 0.40

=head1 SYNOPSIS

	# returns the hash
	get_json("http://example.com/json")

	# stores the in path.key
	get_json("http://example.com/json", path: path.key)

=head1 DESCRIPTION

This L<Catmandu::Fix> provides a method to fetch JSON data from an URL. The
response is added as new item or to a field of the current item.

By now the only additional option of L<Catmandu::Importer::getJSON> supported
by this fix function is C<dry>. Future releases will also support setting the
URL to a field value of the current item.

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
