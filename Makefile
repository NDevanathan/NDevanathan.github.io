DOCS = index papers repos espresso blog
HTML = $(addprefix build/, $(addsuffix .html, $(DOCS)))

BLOG_SRC  = $(wildcard blog/*.jemdoc)
BLOG_HTML = $(patsubst blog/%.jemdoc,build/blog/%.html,$(BLOG_SRC))

JEMDOC ?= ./jemdoc

.PHONY: all clean
all: $(HTML) $(BLOG_HTML) build/jemdoc-cvx.css build/blog.css build/fonts

build/%.html: %.jemdoc MENU jemdoc.conf | build
	$(JEMDOC) -c jemdoc.conf -o $@ $<

build/blog/%.html: blog/%.jemdoc MENU build/blog.conf | build/blog
	$(JEMDOC) -c build/blog.conf -o $@ $<

# jemdoc accepts only one -c, so merge the site-wide conf (analytics) with the
# blog-specific overrides (defaultcss paths + blog.css) into a single file. The
# blank line keeps the trailing block in jemdoc.conf from absorbing the first
# block in blog.conf.
build/blog.conf: jemdoc.conf blog.conf | build
	{ cat jemdoc.conf; printf '\n\n'; cat blog.conf; } > $@

build/jemdoc-cvx.css: jemdoc-cvx.css | build
	cp $< $@

build/blog.css: blog.css | build
	cp $< $@

build/fonts: fonts | build
	rm -rf $@
	cp -r $< $@

build:
	mkdir -p build

build/blog: | build
	mkdir -p build/blog

clean:
	rm -rf build
