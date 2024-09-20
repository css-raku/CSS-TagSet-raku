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

is $tag-set.tag-style('p'), 'display:block; margin-bottom:1.12em; margin-top:1.12em; unicode-bidi:embed;';
my $hidden = '';
is $tag-set.tag-style('p', :$hidden), 'display:none; margin-bottom:1.12em; margin-top:1.12em; unicode-bidi:embed;';

$tag-set.base-style('blah').font-weight = 'bold';
is $tag-set.tag-style('blah'), 'font-weight:bold;';

is $tag-set.tag-style('kbd'), 'font-family:monospace;', 'Base kbd style';

$tag-set .= new: :style-sheet<t/xhtml-extra.css>;
is $tag-set.tag-style('kbd'), 'font:0.85em monospace;', 'Extended kbd style';

done-testing();
