#!/bin/sh

# MAC address OUI lookup.
#
# Author:  Giuseppe Calabrese
# Copying: Public Domain

if ! [ -f "$0" ]; then
    echo >&2 "Error: This script is not running from disk, " \
             "and thus cannot be grep'ed."
    exit 1
fi

usage() {
    echo >&2 "Usage: $(basename "$0") [-h] <address-prefix>"
    echo >&2 "       $(basename "$0") [-h] -O <organization>"
    exit 2
}

error() {
    echo "$(basename "$0"): error: $@"
    exit 1
}

# Validate a MAC address prefix.
valid_prefix() {
    printf '%s' "$1" | grep -qE '^([0-9A-Fa-f]{2}[:-]){0,5}[0-9A-Fa-f]{0,2}$'
}

# Parse arguments.

# Options.
while getopts 'hO:' flag; do
    case $flag in
    (O) regexp="\t$OPTARG" ;;
    (*) usage ;;
    esac
done

# Discard parsed flags and their arguments.
shift $(( OPTIND - 1 ))

if [ -z "$regexp" ]; then
    # Not searching for an organization; require the <address-prefix> argument.
    [ $# -ne 1 ] && usage

    # Don't permit regexps and whatnot; just plain prefixes.
    valid_prefix "$1" || error "Not a valid prefix: '$1'."

    # Prepare a MAC address prefix regexp.
    # - Left-anchor to the beginning of line.
    # - Use '-'s in place of ':'.
    # - Use upper-case hex digits.
    # - Only cover the first 3 bytes of the address; thus,
    #   trim to the first 8 characters (12-45-78).
    regexp=$(printf '^%s' "$1" \
                | tr ':' '-' \
                | tr '[a-f]' '[A-F]' \
                | head -c 8)
fi

# Grep THIS file for a match.
exec grep -E "$regexp" "$0"

# An OUI database follows (which is ignored by the interpreter, as the previous
# instruction is exec).

# === OUI database ===========================================================
