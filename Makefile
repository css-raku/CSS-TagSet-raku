DocProj=css-raku.github.io
DocRepo=https://github.com/css-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku

all : doc

test :
	@prove -e"raku -I ." t

loudtest :
	@prove -e"raku -I ." -v t

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

Pod-To-Markdown-installed :
	@raku -M Pod::To::Markdown -c

doc : $(DocLinker) Pod-To-Markdown-installed docs/index.md docs/CSS/TagSet.md docs/CSS/TagSet/XHTML.md docs/CSS/TagSet/Pango.md docs/CSS/TagSet/TaggedPDF.md

docs/index.md : README.md
	cp $< $@

docs/%.md : lib/%.rakumod
	@raku -I . -c $<
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n $(DocLinker) \
         > $@

