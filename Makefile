# Makefile zum Erzeugen des PDF-Berichts
#
# Ziele:
#   make            -> baut den PDF-Bericht (Standard)
#   make pdf         -> baut den PDF-Bericht
#   make diagram     -> erzeugt das Diagramm (PNG) aus der Mermaid-Quelle
#   make clean       -> loescht LaTeX-Hilfsdateien
#   make distclean   -> loescht zusaetzlich das PDF und das erzeugte PNG
#   make view        -> baut und oeffnet das PDF (macOS)

BERICHT_DIR := bericht
MAIN        := main
PDF         := $(BERICHT_DIR)/$(MAIN).pdf
TEX         := $(BERICHT_DIR)/$(MAIN).tex
BIB         := $(BERICHT_DIR)/bibliography.bib

# Alle Mermaid-Quellen automatisch finden und die passenden PNG-Ziele ableiten.
MMD         := $(wildcard assets/*.mmd)
PNG         := $(MMD:.mmd=.png)
MMDCONFIG   := mermaid.config.json
# Skalierungsfaktor fuer eine hochaufloesende (scharfe) PNG-Ausgabe.
MMDSCALE    := 3

LATEXMK     := latexmk
LATEXMKFLAGS := -pdf -interaction=nonstopmode -halt-on-error -cd

.PHONY: all pdf diagram clean distclean view

all: diagram pdf

pdf: $(PDF)

$(PDF): $(TEX) $(BIB) $(PNG)
	$(LATEXMK) $(LATEXMKFLAGS) $(TEX)

# Alle Mermaid-Diagramme nach PNG konvertieren.
diagram: $(PNG)

# Musterregel: jede .mmd-Datei wird in die gleichnamige .png-Datei konvertiert.
assets/%.png: assets/%.mmd $(MMDCONFIG)
	mmdc -c $(MMDCONFIG) -i $< -s $(MMDSCALE) -o $@

clean:
	$(LATEXMK) -cd -c $(TEX)

distclean:
	$(LATEXMK) -cd -C $(TEX)
	rm -f $(PNG)

view: pdf
	open $(PDF)
