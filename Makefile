DOCS = index papers repos espresso notes
HTML = $(addprefix build/, $(addsuffix .html, $(DOCS)))

NOTES_SRC  = $(wildcard notes/*.jemdoc)
NOTES_HTML = $(patsubst notes/%.jemdoc,build/notes/%.html,$(NOTES_SRC))

JEMDOC ?= ./jemdoc

.PHONY: all clean
all: $(HTML) $(NOTES_HTML) build/jemdoc-cvx.css build/notes.css build/fonts

build/%.html: %.jemdoc MENU jemdoc.conf | build
	$(JEMDOC) -c jemdoc.conf -o $@ $<

build/notes/%.html: notes/%.jemdoc MENU build/notes.conf | build/notes
	$(JEMDOC) -c build/notes.conf -o $@ $<

# jemdoc accepts only one -c, so merge the site-wide conf (analytics) with the
# notes-specific overrides (defaultcss paths + notes.css) into a single file. The
# blank line keeps the trailing block in jemdoc.conf from absorbing the first
# block in notes.conf.
build/notes.conf: jemdoc.conf notes.conf | build
	{ cat jemdoc.conf; printf '\n\n'; cat notes.conf; } > $@

build/jemdoc-cvx.css: jemdoc-cvx.css | build
	cp $< $@

build/notes.css: notes.css | build
	cp $< $@

build/fonts: fonts | build
	rm -rf $@
	cp -r $< $@

build:
	mkdir -p build

build/notes: | build
	mkdir -p build/notes

clean:
	rm -rf build
