use v6;
use Test;

use CSS::TagSet::XHTML;
my CSS::TagSet::XHTML $tag-set .= new;

is $tag-set.tag-style('i'), 'font-style:italic;', '<i/>';
is $tag-set.tag-style('b'), 'font-weight:bolder;', '<b>';
is $tag-set.tag-style('img', :width<200px>, :height<250px>), 'height:250px; width:200px;', '<img width=... height=...>';

done-testing();
