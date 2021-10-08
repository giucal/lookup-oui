MAC address OUI lookup script
=============================

A simple self-contained script to look up OUIs.

The oui-lookup.sh script comes with a grep-friendly database of
prefix/organization entries appended to itself.

Update dataset
--------------

A copy of the datased is included in the repository. A fresh copy
should be available from the Internet:

    make oui.txt  # downloads a fresh dataset

Build
-----

To re-generate the script from scratch:

    make

Installation
------------

    make install                    # at ~/.local/bin
    PREFIX=/usr/local make install  # at /usr/local/bin

Copying
-------

Public Domain.
