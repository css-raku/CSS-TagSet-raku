use v6;
use Test;

use CSS::TagSet::TaggedPDF;

my CSS::TagSet::TaggedPDF $tag-set .= new;
is $tag-set.tag-style('P'), 'display:block; margin-bottom:1.12em; margin-top:1.12em; page-break-after:avoid; unicode-bidi:embed;', '<P/>';
is $tag-set.tag-style('H1'),              'display:block; font-size:2em; font-weight:bolder; margin-bottom:0.67em; margin-top:0.67em; page-break-after:avoid; page-break-before:always; text-decoration:underline; unicode-bidi:embed;', '<H1/>';
is $tag-set.tag-style('H2'),         'display:block; font-size:1.5em; font-weight:bolder; margin-bottom:0.75em; margin-top:0.75em; page-break-after:avoid; unicode-bidi:embed;', '<H2/>';
is $tag-set.tag-style('H3'),         'display:block; font-size:1.17em; font-weight:bolder; margin-bottom:0.83em; margin-top:0.83em; page-break-after:avoid; unicode-bidi:embed;', '<H3/>';
is $tag-set.tag-style('Code'),            'font:0.85em monospace; white-space:pre;', '<Code/>';
is $tag-set.tag-style('LI'),            'display:list-item; list-style:none; margin-left:40px; page-break-after:avoid;', '<LI/>';
is $tag-set.tag-style('Span', :BorderStyle<Dotted>),         'border:dotted;', '<Dotted/>';
is $tag-set.tag-style('Span', :SpaceBefore(5)),         'margin-top:5pt;', '<Span SpaceBefore=...>';

is $tag-set.tag-style('Code'), 'font:0.85em monospace; white-space:pre;', 'Base Code style';

$tag-set .= new: :style-sheet<t/pdf-extra.css>;
is $tag-set.tag-style('Code'), 'font:italic 0.7em monospace; white-space:pre;', 'Extended Code style';

$tag-set .= new;
$tag-set.load-stylesheet: 't/pdf-extra.css';
is $tag-set.tag-style('Code'), 'font:italic 0.7em monospace; white-space:pre;', 'Extended Code style';

done-testing();
