export PROJECT_NAME ?= project
export OUTPUT_DIR ?= $(abspath ./)
export OUTPUT = $(OUTPUT_DIR)/$(PROJECT_NAME)

.PHONY: all materials main appendix clean distclean

-include Makefile.local

all : main appendix materials

main : $(OUTPUT) $(OUTPUT)/abstract.txt $(OUTPUT)/main.pdf

$(OUTPUT) :
	mkdir -p $@

appendix : $(OUTPUT)/appendix.pdf

materials : $(OUTPUT)/materials.tar.gz

$(OUTPUT)/materials.tar.gz :: materials/*
	tar --owner=anon --group=anon --exclude .gitmodules --exclude .gitignore --exclude .git --exclude-backups --exclude-caches-all -czf $@ materials/

$(OUTPUT)/abstract.txt :: abstract.tex
	detex $< > $@

# This is only on wjb's machine
ifeq (,$(wildcard ~/iCloud/wilbowma.bib))
else
wilbowma.bib : ~/iCloud/wilbowma.bib
	cp $< $@
endif

$(OUTPUT)/%.pdf :: %.tex *.tex *.bib Makefile
	latexrun -O=$(OUTPUT) -o $@ $<

clean :
	latexrun -O=$(OUTPUT) --clean-all $<

distclean :
	latexrun -O=$(OUTPUT) --clean-all $<
	rm $(OUTPUT)/materials.tar.gz
