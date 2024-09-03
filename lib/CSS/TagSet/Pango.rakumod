unit class CSS::TagSet::Pango;

use CSS::TagSet :&load-css-tagset;
also does CSS::TagSet;

use CSS::Module;
use CSS::Module::CSS3;
use CSS::Properties;
use CSS::Units;

has CSS::Module $.module = CSS::Module::CSS3.module;
has CSS::Properties %!props;
has %!tags;

constant %BaseTags is export(:PangoTags) = load-css-tagset(%?RESOURCES<pango.css>);

submethod TWEAK {
    my %CustomProps = %(
        rise => '-pango-rise' => %(
            :synopsis<integer>,
            :default(0),
            :coerce(-> Int:D() $num { :$num }),
        ),
        fallback => '-pango-fallback' => %(
            :synopsis('True | False'),
            :default<False>,
            :coerce(-> Str:D $att { my $num = ($att ~~ /:i 'True'/) ?? 1 !! 0; :$num }),
        ),
        size => 'font-size' => %(
            # map Pango `size` attribute to CSS `font-size` property
            :like<font-size>,
            :synopsis("<num> | xx-small | x-small | small | medium | large | x-large | xx-large | smaller | larger"),
            :coerce(
                -> $_ {
                    when CSS::Units:D {
                        $_;
                    }
                    when .lc ∈ set <xx-small x-small small medium large x-large xx-large smaller larger> {
                        :keyw(.lc);
                    }
                    default {
                        # size in thousandths of a point
                        my $pt = .Numeric / 1000;
                        :$pt
                    }
                }),
        ),
        variant => 'font-variant' => %(
            :like<font-variant>,
            :synopsis("normal | smallcaps"),
            :coerce(
                -> Str:D $att {
                    my $keyw = $att.lc;
                    $keyw ~~ s/smallcaps/small-caps/;
                    :$keyw
                        if $keyw ∈ set <normal small-caps>;
                    }),
        ),
        strikethrough => 'text-decoration' => %(
            :like<text-decoration>,
            :synopsis("true | false"),
            :coerce(
                -> $_ {
                    if $_ ~~ CSS::Units {
                        $_;
                    }
                    else {
                        :keyw(
                            /:i true/ ?? 'line-through' !! 'none'
                        )
                    }
                }
            ),
        ),
    );

    for %CustomProps.pairs {
        my $att := .key;
        my Str  $name := .value.key;
        my Hash $meta := .value.value;
        $!module.extend(:$name, |$meta);
        %!SpanProp{$att} = $name;
    }
    %!tags = %BaseTags;
}

method declarations { %!tags }

method base-style(Str $tag) {
    %!props{$tag} //= CSS::Properties.new(:$!module, declarations => %!tags{$tag}) // [];
}

# mapping of Pango attributes to CSS properties
has %!SpanProp = %(
    background => 'background-color',
    'face'|'font_family' => 'font-family',
    foreground => 'color',
    stretch => 'font-stretch',
    style => 'font-style',
    weight => 'font-weight',
);

# Builds CSS properties from an element from a tag name and attributes
multi method tag-style('span', *%attrs) {
    my CSS::Properties $css = self.base-style('span').clone;

    for %attrs.keys {
        if %!SpanProp{$_}:exists {
            my $name = %!SpanProp{$_};
            $css."$name"() = %attrs{$_};
        }
        else {
            warn "ignoring 'style' attribute: '$_'";
        }
    }

    $css;
}

multi method tag-style($tag) {
    self.base-style($tag).clone;
}

=begin pod

=head2 Name

CSS::TagSet::Pango

=head2 Description

adds Pango specific styling based on tags and attributes.

=head2 Methods

=head3 method tag-style

    method tag-style(Str $tag, *%atts) returns CSS::Properties

Adds any further styling based on the tag and additional attributes.

For example the Pango `tt` tag implies `font-family: mono`.

=end pod
