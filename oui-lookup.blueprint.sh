#!/bin/sh

# MAC address OUI lookup.
#
# Greps THIS file for a matching MAC address prefix or organization name.
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
    echo "$(basename "$0"): error: $*"
    exit 1
}

# Validate a MAC address prefix.
valid_prefix() {
    printf '%s' "$1" | grep -qE '^([0-9A-Fa-f]{2}[:.-]?){0,5}[0-9A-Fa-f]{0,2}$'
}

# Parse arguments.

# Reverse search?
reverse=false

# Options.
while getopts 'hO' flag; do
    case $flag in
    (O) reverse=true ;;
    (*) usage ;;
    esac
done

# Discard parsed flags and their arguments.
shift $(( OPTIND - 1 ))

# Require an argument.
[ $# -ne 1 ] && usage

if $reverse; then
    # Search for an organization.
    # Prefix the search expression with a tab to make sure we only ever match
    # against the second field. (This file does not use tabs for indentation.)
    exec grep -iE "\t($1)" "$0"
fi

# Searching for a MAC address prefix.
# Don't permit regexps and whatnot; just plain prefixes.
valid_prefix "$1" || error "Not a valid prefix: '$1'."

# Extract and normalize the MAC address prefix.
# - Strip off '-'s, ':'s and '.'s.
# - Use upper-case hex digits.
# - Only cover the first 3 bytes of the address; thus,
#   trim to the first 6 characters.
prefix=$(printf '%s' "$1" \
            | tr -d ':-.' \
            | tr 'a-f' 'A-F' \
            | head -c 6)

exec grep -E "^$prefix" "$0"

# An OUI database follows (which is ignored by the interpreter, as the previous
# instruction is exec).

# === OUI database ===========================================================
