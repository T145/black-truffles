#!/usr/bin/env bash

#shopt -s extdebug     # or --debugging
set +H +o history     # disable history features (helps avoid errors from "!" in strings)
shopt -u cmdhist      # would be enabled and have no effect otherwise
shopt -s execfail     # ensure interactive and non-interactive runtime are similar
shopt -s extglob      # enable extended pattern matching (https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
set -euET -o pipefail # put bash into strict mode & have it give descriptive errors
umask 055             # change all generated file perms from 755 to 700

main() {
    mkdir -p dist

    # Translate DShield info into a legible format.
    curl -sSL https://dshield.org/block.txt |
        mawk '$1!~/^#/{printf "%s-%s\n", $1, $2}' |
        ipinfo range2cidr >'dist/dshield.txt'

    # Crashes at any earlier point cause this to be unreachable.
    echo "status=success" >>"$GITHUB_OUTPUT"
}

main
