
[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS::TagSet]](https://css-raku.github.io/CSS-TagSet-raku)

CSS::TagSet
---------

Example
-------
```raku
# interrogate styling rules for various XHTML tags and attributes
use CSS::TagSet::XHTML;
my CSS::TagSet::XHTML $tag-set .= new;

# show styling for various XHTML tags
say $tag-set.tag-style('i');  # font-style:italic;
say $tag-set.tag-style('b');  # font-weight:bolder;
say $tag-set.tag-side('th');  # display:table-cell;

# styling for <img width="200px" height="250px"/>
say $tag-set.tag-style('img', :width<200px>, :height<250px>);
# height:250px; width:200px;
```

Description
----------
This module implements document specific styling rules for several markup languages, including XHTML, Pango and Tagged-PDF.

TagSet classes perform the role CSS::TagSet and implement the follow methods, to
define how stylesheets are associated with documents and how CSS styling is
determined from document content, including the extraction of stylesheets
and applying styling to nodes in the document. The methods that need to
be implemented are:

Method | Description
-------|----------
`stylesheet-content($doc)` | Extracts and returns stylesheets for a document
`tag-style(Str $tag, :$hidden, *%attrs)` | Computes styling for a node with a given tag-name and attributes
`inline-style-attribute()` | Returns inline styling attribute. Defaults to style

In the case of XHTML (CSS::TagSet::XHTML):

- The `stylesheet-content($doc)` method extracts `<style>...</style>` tags or externally linked via `<link rel="stylesheet href=.../>` tags,
- for example `$.tag-style('b')` returns a CSS::Properties object `font-weight:bolder;`

The default styling for given tags can be adjusted via the `base-style` method:

```raku
say $tag-set.tag-style('small'); # font-size:0.83em;
$tag-set.base-style('small').font-size = '0.75em';
say $tag-set.tag-style('small'); # font-size:0.75em;
```

`base-style` can also be used to define styling for simple new tags:
```raku
$tag-set.base-style('shout').text-transform = 'upppercase';
say $tag-set.tag-style('shout');  # text-transform:upppercase;
```

Classes
---------
  * [CSS::TagSet](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet) - CSS TagSet Role

  * [CSS::TagSet::XHTML](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/XHTML) - Implements XHTML specific styling

  * [CSS::TagSet::Pango](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/Pango) - Implements Pango styling

  * [CSS::TagSet::TaggedPDF](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/TaggedPDF) - (*UNDER CONSTRUCTION*) Implements Tagged PDF styling


