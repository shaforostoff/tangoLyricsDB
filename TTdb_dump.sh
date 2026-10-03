#!/usr/bin/env bash
# Monthly database backup, run from cron on the VM:
#   0 3 1 * * /home/ubuntu/tangoLyricsDB/TTdb_dump.sh
# Dumps are ~200 KB each, so all of them are kept.
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p backup
docker exec tangolyricsdb-db-1 pg_dump -U ttdb --format=c ttdb_production > backup/TDB_$(date +%Y-%m-%d).dump
