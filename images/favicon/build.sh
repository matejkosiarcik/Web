#!/bin/sh
set -euf
cd "$(dirname "${0}")"

mkdir -p 'artifacts'
node 'build.js'

optimize() {
    tmpfile="$(mktemp)"
    pngquant --strip --speed 1 --skip-if-larger --quality 0-90 --force "${1}" --output "${1}"
    # pngcrush -brute "${1}" "${tmpfile}"
    # mv "${tmpfile}" "${1}"
    optipng -force -strip all -o7 -zm1-9 "${1}" -out "${1}"
    # zopflipng -y --iterations=100 --filters=01234mepb --lossy_8bit --lossy_transparent "${1}" "${1}"
    rm -f "${tmpfile}"
}

optimize 'artifacts/.favicon-16.png'
optimize 'artifacts/.favicon-32.png'
optimize 'artifacts/.favicon-48.png'
optimize 'artifacts/.favicon-64.png'
optimize 'artifacts/.favicon-96.png'
optimize 'artifacts/.favicon-128.png'
optimize 'artifacts/.favicon-256.png'

cp 'artifacts/.favicon-64.png' 'artifacts/favicon.png'

png2ico 'artifacts/favicon.ico' --colors 16 'artifacts/.favicon-16.png' 'artifacts/.favicon-32.png'