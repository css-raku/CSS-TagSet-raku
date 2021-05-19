use v6;
use Test;

use CSS::TagSet::TaggedPDF;

my CSS::TagSet::TaggedPDF $tag-set .= new;
is $tag-set.tag-style('P'), 'display:block; margin-bottom:1.12em; margin-top:1.12em; unicode-bidi:embed;', '<P/>';
is $tag-set.tag-style('H1'),              'display:block; font-size:2em; font-weight:bolder; margin-bottom:0.67em; margin-top:0.67em; unicode-bidi:embed;', '<H1/>';
is $tag-set.tag-style('H2'),         'display:block; font-size:1.5em; font-weight:bolder; margin-bottom:0.75em; margin-top:0.75em; unicode-bidi:embed;', '<H2/>';
is $tag-set.tag-style('H3'),         'display:block; font-size:1.17em; font-weight:bolder; margin-bottom:0.83em; margin-top:0.83em; unicode-bidi:embed;', '<H3/>';
is $tag-set.tag-style('Code'),            'font-family:monospace;', '<Code/>';
is $tag-set.tag-style('LI'),            'display:list-item; margin-left:40px;', '<LI/>';
is $tag-set.tag-style('Span', :BorderStyle<Dotted>),         'border:dotted;', '<Dotted/>';
is $tag-set.tag-style('Span', :SpaceBefore(5)),         '-pdf-space-before:5pt;', '<Span SpaceBefore=...>';

done-testing();
