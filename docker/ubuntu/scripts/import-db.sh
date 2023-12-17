#!/usr/bin/env bash

set -e


if [[ ! -f /shared/mbdump.tar.bz2 ]]; then
    date
    echo "Getting database files..."
    version="$(curl -SsL https://data.metabrainz.org/pub/musicbrainz/data/fullexport/LATEST)"

    url="https://data.metabrainz.org/pub/musicbrainz/data/fullexport/${version}/mbdump.tar.bz2"

    curl -SL "$url" -o /shared/mbdump.tar.bz2
fi

mkdir -p /shared/mbdump
cd /shared/mbdump

date
echo "Extracting archive..."

# bzip2 -tv /shared/mbdump.tar.bz2 
bzip2 --decompress --stdout /shared/mbdump.tar.bz2  | tar xv

date
echo "Importing database..."

cat /shared/mbdump/mbdump/* | PGPASSWORD="$POSTGRES_PASSWORD" pgcli  --dbname "$POSTGRES_DB" --host postgres --user "$POSTGRES_USER"