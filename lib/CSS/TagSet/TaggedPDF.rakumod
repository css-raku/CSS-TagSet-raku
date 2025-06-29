unit class CSS::TagSet::TaggedPDF;

use CSS::TagSet :&load-css-tagset;
also does CSS::TagSet;

use CSS::Media;
use CSS::Module;
use CSS::Module::CSS3;
use CSS::Properties;
use CSS::Units :pt;

has CSS::Media $.media .= new: :type<print>;

submethod TWEAK(IO() :$style-sheet) {
    my %CustomProps = %(
        '-pdf-space-before'|'-pdf-space-after'|'-pdf-start-indent'|'-pdf-end-indent' => %(
            :synopsis<number>,
            :default(0e0),
            :coerce(-> Num:D() $num { :$num }),
        ),
    );

    for %CustomProps.pairs {
        $!module.extend(:name(.key), |.value);
    }

    self.load-stylesheet(%?RESOURCES<tagged-pdf.css> );
    self.load-stylesheet($_) with $style-sheet;
}

method load-stylesheet(IO() $_) {
    load-css-tagset($_, :xml, :$!media, :%!tags )
}

method declarations { %!tags }

sub snake-case($s) {
    $s.split(/<?after .><?before <[A..Z]>>/)».lc.join: '-'
}

# mapping of Tagged PDF attributes to CSS properties
our %Layout = %(
    'FontFamily'|'FontSize'|'FontStyle'|'FontWeight'|'FontVariant'|'FontStretch'
                  => ->  Str $prop, $v { snake-case($prop) => $v ~ 'pt' },
    # IS0 32000-1 Table 343 – Standard layout attributes common to all standard structure types
    'Placement'   => :display{ 'Block'|'Before'|'Start'|'End' => 'block', :Inline<inline> },
    'WritingMode' => :direction{ :LrTb<ltr>, :RlTb<rtl> },
    'BackgroundColor'|'BorderColor'|'Color' => -> $_, $c {
        .&snake-case => '#' ~ $c.split(' ').map({sprintf("%02x", (.Num * 255).round)}).join;
    },
    'BorderStyle' => -> Str $prop, Str $s {
        snake-case($prop) => [ $s.split(' ')>>.lc ];
    },
    'BorderThickness'|'Padding' => -> Str $prop, Str $s {
        snake-case($prop) => [ $s.split(' ').map: -> $pt { :$pt } ];
    },
    'TextIdent'|'Width'|'Height'|'LineHeight' => -> Str $prop, Num() $pt {
        # approximate
        snake-case($prop) => :$pt;
    },
    'TextAlign' => -> Str $prop, Str $s {
        snake-case($prop) => $s.lc;
    },
    'TextDecorationType' => -> Str $, Str $s {
        text-decoration => $s.lc;
    },
    # Custom properties which don't map well to CSS standard properties
    'SpaceBefore'|'SpaceAfter'|'StartIndent'|'EndIndent' => -> Str $prop, Num() $pt {
        my Str:D $margin = {
            :SpaceBefore<top>,
            :SpaceAfter<bottom>,
            :StartIndent<left>,
            :EndIndent<right>,
        }{$prop};
        ('margin-' ~ $margin) => :$pt;
    },
    # Todo: BBox BlockAlign InlineAlign TBorderStyle TPadding TextDecorationColor TextDecorationThickness RubyAlign RubyPosition GlyphOrientationVertical
);

my subset HashMap of Pair where .value ~~ Associative;
# Builds CSS properties from an element from a tag name and attributes
method tag-style($tag, *%attrs --> CSS::Properties:D) {
    my CSS::Properties $css = self.base-style($tag).clone;

    for %attrs.keys.grep({%Layout{$_}:exists}) -> $key {
        my $value := %attrs{$key};
        given %Layout{$key} {
            when Str {
                $css."$_"() = $value;
            }
            when HashMap {
                given .key -> $prop {
                    $css."{$prop}"() = $_ with .value{$value};
                }
            }
            when Code {
                with .($key, $value) -> $kv {
                    $css."{$kv.key}"() = $_ with $kv.value;
                }
            }
            default {
                die "can't map attribute {$key} to {.raku}";
            }
        }
    }

    $css;
}

=begin pod

=head2 Name

CSS::TagSet::TaggedPDF

=head2 Description

add CSS Styling to Tagged PDF structured documents.

=head2 Methods

=head3 method tag-style

    method tag-style(Str $tag, *%atts) returns CSS::Properties

Adds any further styling based on the tag and additional attributes.


=end pod
