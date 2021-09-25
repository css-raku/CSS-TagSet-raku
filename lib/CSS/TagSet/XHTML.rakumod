use v6;

use CSS::TagSet :&load-css-tagset;

class CSS::TagSet::XHTML does CSS::TagSet {
    use CSS::Module;
    use CSS::Module::CSS3;
    use CSS::Properties;
    use URI;

    has CSS::Properties %!props;
    has SetHash %!link-pseudo;
    has CSS::Module $.module = CSS::Module::CSS3.module;

    constant %Tags is export(:Tags) = load-css-tagset(%?RESOURCES<xhtml.css>);

    method declarations { %Tags }

    method base-style(Str $prop) {
        %!props{$prop} //= CSS::Properties.new(:$!module, declarations => %Tags{$prop} // []);
    }

    # mapping of HTML attributes to CSS properties
    constant %AttrProp = %(
        align         => '-xhtml-align',
        background    => 'background-image',
        bgcolor       => 'background-color',
        border        => 'border',
        color         => 'color',
        colspan       => '-xhtml-colspan',
        dir           => 'direction',
        height        => 'height',
        rowspan       => '-xhtml-rowspan',
    );

    # mapping of HTML attributes to containing tags
    constant %AttrTags = %(
        align               => 'applet'|'caption'|'col'|'colgroup'|'hr'|'iframe'|'img'|'table'|'tbody'|'td'|'tfoot'|'th'|'thead'|'tr',
        background          => 'body'|'table'|'td'|'th', # obsolete in HTML5
        bgcolor             => 'body'|'col'|'colgroup'|'marquee'|'table'|'tbody'|'tfoot'|'td'|'th'|'tr',  # obsolete in HTML5
        border              => 'img'|'object'|'table',   # obsolete in HTML5
        color               => 'basefont'|'font'|'hr',   # obsolete in HTML5
        bdo                 => 'bidi-override',
        dir                 => Str, # applicable to all
        'height'|'width'    => 'canvas'|'embed'|'iframe'|'img'|'input'|'object'|'video',
        'colspan'|'rowspan' => 'td'|'th',
    );

    method xpath-init($xpath-context) {
        $xpath-context.registerFunction(
            'link-pseudo',
            -> $name, $node-set {
                my $elem = $node-set.first;
                ? ($elem.tag ~~ 'a'|'link'|'area' && self.link-pseudo($name, $elem));
            });
    }
    submethod TWEAK(:$xpath-context) {
        my %CustomProps = %(
            '-xhtml-align' => %(
                :like<text-align>,
            ),
            '-xhtml-colspan'|'-xhtml-rowspan' => %(
                :synopsis<integer>,
                :default(1),
                :coerce(-> Int() $num { :$num }),
            ),
        );

        for %CustomProps.pairs {
            $!module.extend(:name(.key), |.value);
        }
    }

    # any additional CSS styling based on HTML attributes
    multi sub tweak-style('bdo', $css) {
        $css.unicode-bidi //= :keyw<bidi-override>;
    }
    multi sub tweak-style($, $,) is default {
    }

    sub matching-media($media, $query) {
        !$media.defined || !$query.defined || $query ~~ $media;
    }

    method stylesheet-content($doc, :$media, :$links) {
        my URI() $base-url;
        my @content;
        for $doc.findnodes('html/head/*') -> $e  {
            given $e.tag {
                when 'style' {
                    @content.push: $e.textContent;
                }
                when 'link' {
                    $base-url //= $doc.?URI // './';
                    with $e.getAttribute('rel') {
                        when .lc eq 'stylesheet' {
                            with $e.getAttribute('href') -> URI() $_ {
                                if matching-media($media, $e.getAttribute('media')) {
                                    if $links {
                                        my URI $url = .rel2abs($base-url.directory);
                                        my CSS::URI $uri .= new: :$url;
                                        @content.push: $_ with $uri.get;
                                    }
                                    else {
                                        warn "ignoring {$e.Str} - use :links option to enable";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        @content;
    }

    # Builds CSS properties from an element from a tag name and attributes
    method tag-style(Str $tag, :$hidden, *%attrs) {
        my CSS::Properties $css = self.base-style($tag).clone;
        $css.display = :keyw<none> with $hidden;

        for %attrs.keys.grep({%AttrTags{$_}:exists && $tag ~~ %AttrTags{$_}}) {
            my $name = %AttrProp{$_} // $_;
            $css."$name"() = %attrs{$_};
        }
        tweak-style($tag, $css);
        $css;
    }

    multi method link-pseudo(Str() $type, $node) is rw {
        $.link-pseudo($type, $node.nodePath);
    }

    multi method link-pseudo('link', Str $path) is rw {
        Proxy.new(
            FETCH => { ! %!link-pseudo{$path} },
            STORE => { %!link-pseudo{$path}:delete },
        );
    }

    multi method link-pseudo(Str $type, Str $path) is rw is default {
        Proxy.new(
            FETCH => { do with %!link-pseudo{$path} { .{$type.lc} } else { False } },
            STORE => -> $, Bool() $v {
                (%!link-pseudo{$path} //= SetHash.new){$type.lc} = $v
            },
        );
    }

}

=begin pod

=head2 Name

CSS::TagSet::XHTML

=head2 Description

adds XHTML specific styling based on tags and attributes.

=head2 Methods

=head3 method inline-style

    method inline-style(Str $tag, :$style, *%atts) returns CSS::Properties

Parses an inline style as a CSS Property list.

=head3 method tag-style

    method tag-style(Str $tag, *%atts) returns CSS::Properties

Adds any further styling based on the tag and additional attributes.

For example the XHTML `i` tag implies `font-style: italic`.

=head3 method link-pseudo

    method link-pseudo(
        Str() $state,              # typically: 'active', 'focus', 'hover' or 'visited'
        $elem, # XML element
    )
By default, all tags of type `a`, `link` and `area` match against the `link` pseudo.

This method can be used to set individual links to a state of `active`, `focus`, `hover` or `visited`
to simulate other interactive states for styling purposes. For example:

    # simulate clicking the first element that matches <a id="foo"/>
    my CSS::TagSet::XHTML $tag-set .= new;
    my $some-visited-link = $doc.first('//a[@id="foo"]');
    $tag-set.link-pseudo('visited', $some-visited-link) = True;
    my $css .= new: :$doc, :$tag-set;

    # this query now returns the above element
    $doc.first('//*:visited');

=head3 stylesheet-content

       method stylesheet-content(
           $doc,                # document to process
           Bool :$links,        # whether to follow stylesheet links
           CSS::Media :$media,  # optional CSS::Media object
       ) returns Array[Str]

This method extracts internal stylesheet content from <style>...</style>
blocks in the HTML head block.

If the `:$links` flag is True, stylesheet links of the form <link rel="stylesheet" href="<url>"/>` will also be followed. In this case an optional `:$media` object may also be passed for filtering of links with a `media="<query>" media selection.

=end pod
