#!/usr/bin/env bash
# IMF SDMX 2.1 API から月次スナップショットを取得
# Usage: fetch_imf.sh YYYY MM
set -euo pipefail

YYYY="${1:?usage: $0 YYYY MM}"
MM="${2:?usage: $0 YYYY MM}"
OUTDIR="data/imf/${YYYY}/${MM}"
mkdir -p "$OUTDIR"

# IMF SDMX 2.1: dataflow + key + period
# 例: IFS (International Financial Statistics) の年次GDPやCPIなど
# データセット: IFS, BOP, GFS, WEO 等
# https://datahelp.imf.org/knowledgebase/articles/667681-using-json-restful-web-service

BASE="http://dataservices.imf.org/REST/SDMX_JSON.svc/CompactData"

# 取得対象（必要に応じて追加）
# Dataset/Frequency.Country.Indicator
TARGETS=(
  "IFS/A..NGDP_R_XDC"       # Real GDP (national currency, annual)
  "IFS/A..PCPI_IX"          # CPI Index (annual)
  "IFS/A..LUR_PT"           # Unemployment rate
  "IFS/A..ENDA_XDC_USD_RATE" # Exchange rate (period average)
  "BOP/A..BCA_BP6_USD"      # Current account balance (BPM6)
)

i=0
for target in "${TARGETS[@]}"; do
  safe_name="${target//\//_}"
  safe_name="${safe_name//./_}"
  echo ">>> fetching $target ..."
  curl -fsSL --retry 3 --retry-delay 5 \
    "${BASE}/${target}" \
    -o "${OUTDIR}/${safe_name}.json" || echo "WARN: $target failed (continuing)"
  i=$((i+1))
  # IMFは10reqごとにpause推奨
  if (( i % 5 == 0 )); then sleep 3; else sleep 1; fi
done

echo "Done: ${OUTDIR}"
ls -la "${OUTDIR}"
