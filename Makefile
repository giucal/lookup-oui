PREFIX ?= ~/.local

# Hope it will stay up...
OUI_DATABASE_BASE_URL ?= https://standards-oui.ieee.org/oui

all: oui-lookup.sh

install: $(PREFIX)/bin/oui-lookup

$(PREFIX)/bin/oui-lookup: oui-lookup.sh
	install $< $@

# Create the actual script with the database appended.
oui-lookup.sh: oui-lookup.blueprint.sh oui.tsv
	# Creating a self-contained $@ script...
	cat oui-lookup.blueprint.sh oui.tsv > $@
	chmod +x $@

# Create a greppable (and readable) database from oui.csv.
oui.tsv: oui.csv dsv.awk
	printf 'BEGIN { RS = "\\r\\n"; OFS = "\\t" } NR == 1 { next } { print $$2, $$3 }' | awk -f dsv.awk -f- $< > $@

# CSV-parsing dependency.
dsv.awk:
	curl -L 'https://github.com/giucal/dsv.awk/raw/main/dsv.awk' > $@.part && mv $@.part $@

# Download the raw oui.csv dataset.
oui.csv:
	# Trying to retrieve a fresh version of $@...
	curl $(OUI_DATABASE_BASE_URL)/$@ > $@.part && mv $@.part $@
