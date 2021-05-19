use v6;
use Test;
use CSS::TagSet::Pango;
my CSS::TagSet::Pango $tag-set .= new;

is $tag-set.tag-style('i'), 'font-style:italic;', '<i/>';
is $tag-set.tag-style('b'), 'font-weight:bold;', '<b/>';
is $tag-set.tag-style('big'), 'font-size:larger;', '<big/>';
is $tag-set.tag-style('s'), 'text-decoration:line-through;', '<s/>';
is $tag-set.tag-style('sub'), 'font-size:0.83em; vertical-align:sub;', '<sub/>';
is $tag-set.tag-style('sup'), 'font-size:0.83em; vertical-align:super;', '<sup/>';
is $tag-set.tag-style('small'), 'font-size:smaller;', '<small/>';
is $tag-set.tag-style('tt'), 'font-family:monospace;', '<tt/>';
is $tag-set.tag-style('u'), 'text-decoration:underline;', '<u/>';

is $tag-set.tag-style('span'), '', '<span/>';

is $tag-set.tag-style('span', :rise<50>, :fallback<True>), '-pango-fallback:1; -pango-rise:50;','span fallback and rise';
is $tag-set.tag-style('span', :face<sans>), 'font-family:sans;', 'span font_family';
is $tag-set.tag-style('span', :face<sans>), 'font-family:sans;', 'span face';
is $tag-set.tag-style('span', :size<x-small>), 'font-size:x-small;', 'span size, named';
is $tag-set.tag-style('span', :size<9500>), 'font-size:9.5pt;', 'span size, numeric';
is $tag-set.tag-style('span', :variant<smallcaps>), 'font-variant:small-caps;', 'span variant';
is $tag-set.tag-style('span', :variant<normal>, :stretch<condensed>), 'font-stretch:condensed;', 'span stretch';
is $tag-set.tag-style('span', :foreground<#f00>), 'color:red;', 'span foreground';
is $tag-set.tag-style('span', :background<#0f0>), 'background:lime;', 'span background';
is $tag-set.tag-style('span', :rise<50>), '-pango-rise:50;', 'span rise';
is $tag-set.tag-style('span', :strikethrough<true>), 'text-decoration:line-through;', 'strikethrough="true"';
is $tag-set.tag-style('span', :strikethrough<false>), '', 'strikethrough="false"';

done-testing();
