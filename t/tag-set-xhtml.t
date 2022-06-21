use v6;
use Test;

use CSS::TagSet::XHTML;
my CSS::TagSet::XHTML $tag-set .= new;

is $tag-set.tag-style('i'), 'font-style:italic;', '<i/>';
is $tag-set.tag-style('b'), 'font-weight:bolder;', '<b>';
is $tag-set.tag-style('td'), 'display:table-cell; vertical-align:inherit;', '<td/>';
is $tag-set.tag-style('td', :width<200px>), 'display:table-cell; vertical-align:inherit; width:200px;', '<td/>';
is $tag-set.tag-style('img', :width<200px>, :height<250px>), 'height:250px; width:200px;', '<img width=... height=...>';

is $tag-set.tag-style('small'), 'font-size:0.83em;';
$tag-set.base-style('small').font-size = '0.75em';
is $tag-set.tag-style('small'), 'font-size:0.75em;';

$tag-set.base-style('blah').font-weight = 'bold';
is $tag-set.tag-style('blah'), 'font-weight:bold;';

done-testing();
