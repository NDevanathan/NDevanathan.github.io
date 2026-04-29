DOCS = index papers repos espresso
HTML = $(addprefix build/, $(addsuffix .html, $(DOCS)))

JEMDOC ?= ./jemdoc

.PHONY: all clean
all: $(HTML) build/jemdoc-cvx.css build/fonts

build/%.html: %.jemdoc MENU | build
	$(JEMDOC) -o $@ $<

build/jemdoc-cvx.css: jemdoc-cvx.css | build
	cp $< $@

build/fonts: fonts | build
	rm -rf $@
	cp -r $< $@

build:
	mkdir -p build

clean:
	rm -rf build
