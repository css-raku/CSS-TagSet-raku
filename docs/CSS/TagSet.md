[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-TagSet]](https://css-raku.github.io/CSS-TagSet-raku)
 / [CSS::TagSet](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet)

Name
----

CSS::TagSet

Description
-----------

A role to perform tag-specific stylesheet loading, and styling based on tags and attributes.

This is the base role for tag-sets, including [CSS::TagSet::XHTML](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/XHTML), [CSS::TagSet::Pango](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/Pango), and [CSS::TagSet::TaggedPDF](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/TaggedPDF).

Methods
-------

### method stylesheet

    method stylesheet(LibXML::Document $doc) returns CSS::Stylesheet;

An abstract method to build the stylesheet associated with a document; both from internal styling elements and linked stylesheets.

This method currently only extracts self-contained internal style-sheets. It neither currently processes `@include` at-rules or externally linked stylesheets.

### method inline-style

    method inline-style(Str $tag, Str :$style) returns CSS::Properties;

Default method to parse an inline style associated with the tag, typically the inline style is computed from the `style` attribute.

### method tag-style

    method tag-style(Str $tag, Str *%atts) returns CSS::Properties

Abstract method to compute a specific style, based on a tag-name and any additional tag attributes. This method must be implemented, by the class instance.

By convention, this method vivifies a new empty [CSS::Properties](https://css-raku.github.io/CSS-Properties-raku/CSS/Properties) object, if the tag was previously unknown.

### method base-style

    method tag-style(str $tag) returns CSS::Properties

Abstract rule to 

