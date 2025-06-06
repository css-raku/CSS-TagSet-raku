#| interface role for tagsets
unit role CSS::TagSet:ver<0.1.2>;

use CSS::Media;
use CSS::Properties;
use CSS::Stylesheet;
use CSS::Writer;
has CSS::Properties %.props;
has %.tags;
has CSS::Module $.module = CSS::Module::CSS3.module;

method media { ... }

sub load-css-tagset($tag-css, CSS::Media :$media!, :%tags!, |c) is export(:load-css-tagset) {
    my CSS::Stylesheet $style-sheet;
    with $tag-css {
        # Todo: load via CSS::Stylesheet?
        my $css = .IO.slurp;
        $style-sheet .= parse: $css, :$media, |c;

        for $style-sheet.rules {
            with .ast<ruleset> {
                my $declarations = .<declarations>;
                for .<selectors>.list {
                    given .<selector> {
                        my @path;
                        for .list {
                            for .<simple-selector>.list {
                                @path.push: $_
                                     with .<qname><element-name>;
                            }
                        }

                        my $key = @path == 1 ?? @path.head !! CSS::Writer.write: :selector($_);
                        %tags{$key}.append: $declarations.map: {:property($_)};
                    }
                }
            }
        }
    }
    else {
        note "running with 'raku --doc', I hope"
    }

    $style-sheet;
}

method xpath-init($) {} # override me
method stylesheet-content($) { [] } # override me
method module { ... }
method stylesheet($doc, CSS::Media :$media, Bool :$links = False, |c --> CSS::Stylesheet) {
    my @styles = @.stylesheet-content($doc, :$media, :$links);
    my CSS::Stylesheet $css .= new: :$media, |c;
    $css.parse($_) for @styles;
    $css;
}

# attribute that contains inline styling
method inline-style-attribute { 'style' }

# method to extract inline styling
method inline-style(Str $, Str :$style) {
    CSS::Properties.new(:$.module, :$style);
}

method base-style(Str $tag) {
    %.props{$tag} //= CSS::Properties.new: :$.module, declarations => %.tags{$tag} // [];
}

=begin pod

=head2 Name

CSS::TagSet

=head2 Description

A role to perform tag-specific stylesheet loading, and styling based on tags and attributes.

This is the base role for tag-sets, including L<CSS::TagSet::XHTML>, L<CSS::TagSet::Pango>, and  L<CSS::TagSet::TaggedPDF>.

=head2 Methods

=head3 method stylesheet

    method stylesheet(LibXML::Document $doc) returns CSS::Stylesheet;

An abstract method to build the stylesheet associated with a document; both from internal styling elements and linked stylesheets.

This method currently only extracts self-contained internal style-sheets. It neither currently processes `@include` at-rules or externally linked stylesheets.


=head3 method inline-style

    method inline-style(Str $tag, Str :$style) returns CSS::Properties;

Default method to parse an inline style associated with the tag, typically the inline style is computed
from the  `style` attribute.

=head3 method tag-style

    method tag-style(Str $tag, Str *%atts) returns CSS::Properties

Computes a specific style, based on a tag-name and any additional tag attributes. This method must be implemented, by the class instance.

By convention, this method vivifies a new empty L<CSS::Properties> object, if the tag was previously unknown.

=head3 method base-style

    method base-style(str $tag) returns CSS::Properties

Return the basic style for the tag.

=end pod
