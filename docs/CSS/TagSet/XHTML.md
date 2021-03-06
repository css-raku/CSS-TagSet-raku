[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS-TagSet]](https://css-raku.github.io/CSS-TagSet-raku)
 / [CSS::TagSet](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet)
 :: [XHTML](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/XHTML)

Name
----

CSS::TagSet::XHTML

Description
-----------

adds XHTML specific styling based on tags and attributes.

Methods
-------

### method inline-style

    method inline-style(Str $tag, :$style, *%atts) returns CSS::Properties

Parses an inline style as a CSS Property list.

### method tag-style

    method tag-style(Str $tag, *%atts) returns CSS::Properties

Adds any further styling based on the tag and additional attributes.

For example the XHTML `i` tag implies `font-style: italic`.

### method link-pseudo

    method link-pseudo(
        Str() $state,              # typically: 'active', 'focus', 'hover' or 'visited'
        $elem, # XML element
    )

By default, all tags of type `a`, `link` and `area` match against the `link` pseudo.

This method can be used to set individual links to a state of `active`, `focus`, `hover` or `visited` to simulate other interactive states for styling purposes. For example:

    # simulate clicking the first element that matches <a id="foo"/>
    my CSS::TagSet::XHTML $tag-set .= new;
    my $some-visited-link = $doc.first('//a[@id="foo"]');
    $tag-set.link-pseudo('visited', $some-visited-link) = True;
    my $css .= new: :$doc, :$tag-set;

    # this query now returns the above element
    $doc.first('//*:visited');

### stylesheet-content

    method stylesheet-content(
        $doc,                # document to process
        Bool :$links,        # whether to follow stylesheet links
        CSS::Media :$media,  # optional CSS::Media object
    ) returns Array[Str]

This method extracts internal stylesheet content from <style>...</style> blocks in the HTML head block.

If the `:$links` flag is True, stylesheet links of the form <link rel="stylesheet" href="<url>"/>` will also be followed. In this case an optional `:$media` object may also be passed for filtering of links with a `media="<query>" media selection.

