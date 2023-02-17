PREFIX ?= ~/.local

# Hope it will stay up...
OUI_DATABASE_URL ?= https://standards-oui.ieee.org/oui/oui.txt

all: oui-lookup.sh

install: $(PREFIX)/bin/oui-lookup

$(PREFIX)/bin/oui-lookup: oui-lookup.sh
	install $< $@

# Create the actual script with the database appended.
oui-lookup.sh: oui-lookup.blueprint.sh oui.tsv
	# Creating a self-contained $@ script...
	cat oui-lookup.blueprint.sh oui.tsv > $@
	chmod +x $@

# Create a suitable database from oui.txt.
oui.tsv: oui.txt
	# Creating a tab-separated prefix/organization database...
	awk '/\(hex\)/ { $$2 = "\t"; print $0 }' $< | sed 's/ *\t */\t/' > $@

# Download the raw oui.txt dataset.
oui.txt:
	# Trying to retrieve a fresh version of $@...
	curl $(OUI_DATABASE_URL) > $@.tmp && mv $@.tmp $@
