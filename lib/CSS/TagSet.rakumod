use v6;

# interface role for tagsets
role CSS::TagSet:ver<0.0.22> {
    use CSS::Properties;
    use CSS::Stylesheet;

    sub load-css-tagset($tag-css, |c) is export(:load-css-tagset) {
        my %asts;
        with $tag-css {
            # Todo: load via CSS::Stylesheet?
            my CSS::Module $module = CSS::Module::CSS3.module;
            my $actions = $module.actions.new: |c;
            my $p = $module.grammar.parsefile(.absolute, :$actions);
            my %ast = $p.ast;

            for %ast<stylesheet>.list {
                with .<ruleset> {
                    my $declarations = .<declarations>;
                    for .<selectors>.list {
                        for .<selector>.list {
                            for .<simple-selector>.list {
                                with .<qname><element-name> -> $elem-name {
                                    %asts{$elem-name}.append: $declarations.list;
                                }
                            }
                        }
                    }
                }
            }
        }
        else {
            note "running with 'raku --doc', I hope"
        }
       
        %asts;
    }

    method xpath-init($) {} # override me
    method stylesheet-content($) { [] } # override me
    method module { ... }
    method stylesheet($doc, |c --> CSS::Stylesheet) {
        my @styles = @.stylesheet-content($doc);
        CSS::Stylesheet.new(|c).parse(@styles.join: "\n");
    }

    # attribute that contains inline styling
    method inline-style-attribute { 'style' }

    # method to extract inline styling
    method inline-style(Str $, Str :$style) {
        CSS::Properties.new(:$.module, :$style);
    }

    # method to extract intrinsic styling information from tags and attributes
    method tag-style($tag, *%attrs --> CSS::Properties) {
        CSS::Properties.new;
    }

    method base-style(|c) { ... }

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

Abstract method to compute a specific style, based on a tag-name and any additional tag attributes. This method must be implemented, by the class instance.

By convention, this method vivifies a new empty L<CSS::Properties> object, if the tag was previously unknown.

=head3 method base-style

    method tag-style(str $tag) returns CSS::Properties

Abstract rule to 

=end pod
