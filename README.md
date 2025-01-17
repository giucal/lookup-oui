MAC address OUI lookup script
=============================

Recipe for a self-contained script to look up OUIs.

Simply:

    make

This will create a `oui-lookup.sh` script. The script comes with a greppable OUI
database appended to itself and requires no external dependencies to run, aside
from standard Unix utilities.

To generate the script and also install it locally as `oui-lookup`:

    make install                    # will install at ~/.local/bin

To choose a custom install prefix:

    PREFIX=/usr/local make install  # will install at /usr/local/bin

Usage
-----

To search for a prefix, use hexadecimal notation. Regexps are _not_ accepted.

    % oui-lookup 001122
    001122  CIMSYS Inc

The prefix needs not be 3 octets long. It can be shorter, which will match many
entries. Or it can be longer, so you can mindlessly pass full addresses.

    # Full address search.
    % oui-lookup 001122334455
    001122  CIMSYS Inc

    # Shorter prefix search.
    % oui-lookup 001 | sort | head
    001000  CABLE TELEVISION LABORATORIES, INC.
    001001  Citel
    001002  ACTIA
    001003  IMATRON, INC.
    001004  THE BRANTLEY COILE COMPANY,INC
    001005  UEC COMMERCIAL
    001006  Thales Contact Solutions Ltd.
    001007  Cisco Systems, Inc
    001008  VIENNA SYSTEMS CORPORATION
    001009  HORANET

The format accepts common separators between any two octets.

    % oui-lookup 00-11-22-33-44-55
    001122  CIMSYS Inc
    % oui-lookup 00:11:22:33:44:55
    001122  CIMSYS Inc
    % oui-lookup 0011.2233.4455
    001122  CIMSYS Inc
    % oui-lookup 0011.22-3344:55
    001122  CIMSYS Inc

You can also search by organization. Regexps are accepted in this case, and
they are implicitly case-insensitive and left-anchored.

    % oui-lookup -O xerox | sort | head -n3
    000000  XEROX CORPORATION
    000001  XEROX CORPORATION
    000002  XEROX CORPORATION

    % oui-lookup -O corp
    8427CE  Corporation of the Presiding Bishop of The Church of Jesus Christ of Latter-day Saints
    28CCFF  Corporacion Empresarial Altra SL
    00C0B5  CORPORATE NETWORK SYSTEMS,INC.

    # Explicitly right-anchored using .* and $.
    % oui-lookup -O '.*[ ]spa$' | sort | head -n3
    00020A  Gefran Spa
    000313  Access Media SPA
    000350  BTICINO SPA

Update the OUI database
-----------------------

To update the script to the latest OUI database available from the Internet:

    make -B

To update and reinstall in one step:

    make -B install

Pre-compiled
------------

You can find a pre-compiled but not up-to-date copy of `oui-lookup.sh` in
the [releases] page.

[releases]: https://github.com/giucal/oui-lookup/releases

Copying
-------

Public Domain.
