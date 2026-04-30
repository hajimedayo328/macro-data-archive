#!/usr/bin/env bash
# スナップショットのマニフェストをsnapshots.logに追記
# Usage: manifest.sh YYYY-MM-DD
set -euo pipefail

ISO="${1:?usage: $0 YYYY-MM-DD}"
LOG="snapshots.log"

WB_FILES=$(find data/worldbank -type f -name "*.json" 2>/dev/null | wc -l)
IMF_FILES=$(find data/imf -type f -name "*.json" 2>/dev/null | wc -l)
TOTAL_BYTES=$(du -sb data/ 2>/dev/null | awk '{print $1}')

{
  echo "---"
  echo "snapshot: ${ISO}"
  echo "  worldbank_files: ${WB_FILES}"
  echo "  imf_files: ${IMF_FILES}"
  echo "  total_bytes: ${TOTAL_BYTES}"
  echo "  commit_sha: ${GITHUB_SHA:-local}"
} >> "${LOG}"

cat "${LOG}" | tail -20
