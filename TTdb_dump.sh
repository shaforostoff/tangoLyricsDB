#!/usr/bin/env bash
# Nightly database backup, run from cron on the VM
set -euo pipefail
cd "$(dirname "$0")"

NOW=$(date +"%Y-%m-%d")
docker compose exec -T db pg_dump -U ttdb --format=c ttdb_production > backup/TDB_${NOW}.dump

echo cleanup
python3 purgeFiles/purgeFiles.py --age=1,2,3,4,5,6,7,8,16,32,64,128,256,384,512,640,768,896,1024,1152,1280,1408,1536,1664,1792,1920,2048 --directory=backup --pattern="*.dump" --force
