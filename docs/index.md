[![Build Status](https://travis-ci.org/css-raku/CSS-TagSet-raku.svg?branch=master)](https://travis-ci.org/css-raku/CSS-TagSet-raku)

[[Raku CSS Project]](https://css-raku.github.io)
 / [[CSS::TagSet]](https://css-raku.github.io/CSS-TagSet-raku)

Raku CSS::TagSet
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

# styling for <image width="200px" height="250px"/>
say $tag-set.tag-style('img', :width<200px>, :height<250px>);
# height:250px; width:200px;
```
Description
----------
This module implements tag specific styling rules for several markup languages, including XHTML, Pango and Tagged-PDF.

The `tag-style` method returns a computed L<CSS::Properties> object based on a tag name plus any additional attributes.

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

  * [CSS::TagSet::TaggedPDF](https://css-raku.github.io/CSS-TagSet-raku/CSS/TagSet/TaggedPDF) - (*UNDER CONSTRUCTION*) Implements Taged PDF styling


