PREFIX ?= ~/.local

# Hope it will stay up...
OUI_DATABASE_URL ?= http://standards-oui.ieee.org/oui/oui.txt

all: lookup-oui.sh

install: $(PREFIX)/bin/lookup-oui

$(PREFIX)/bin/lookup-oui: lookup-oui.sh
	install $< $@

# Create the actual script with the database appended.
lookup-oui.sh: lookup-oui.blueprint.sh oui.tsv
	# Creating a self-contained $@ script...
	cat lookup-oui.blueprint.sh oui.tsv > $@
	chmod +x $@

# Create a suitable database from oui.txt.
oui.tsv: oui.txt
	# Creating a tab-separated prefix/organization database...
	awk '/(hex)/ { $$2 = "\t"; print $0 }' $< | sed 's/ *\t */\t/' > $@

# Download the raw oui.txt dataset.
oui.txt:
	# Trying to retrieve a fresh version of $@...
	curl $(OUI_DATABASE_URL) > $@
