#!/usr/bin/env bash
# World Bank Indicators API から月次スナップショットを取得
# Usage: fetch_worldbank.sh YYYY MM
set -euo pipefail

YYYY="${1:?usage: $0 YYYY MM}"
MM="${2:?usage: $0 YYYY MM}"
OUTDIR="data/worldbank/${YYYY}/${MM}"
mkdir -p "$OUTDIR"

# 取得する指標（必要に応じて追加）
# 命名規則は World Bank Indicators API のID
INDICATORS=(
  "NY.GDP.MKTP.CD"        # GDP (current US$)
  "NY.GDP.PCAP.CD"        # GDP per capita
  "SP.POP.TOTL"           # Population, total
  "FP.CPI.TOTL.ZG"        # Inflation, CPI (annual %)
  "SL.UEM.TOTL.ZS"        # Unemployment (% of labor force)
  "NE.EXP.GNFS.ZS"        # Exports of goods and services (% of GDP)
  "NE.IMP.GNFS.ZS"        # Imports of goods and services (% of GDP)
  "GC.DOD.TOTL.GD.ZS"     # Central gov debt, total (% of GDP)
  "EG.USE.ELEC.KH.PC"     # Electric power consumption per capita
  "IT.NET.USER.ZS"        # Individuals using the Internet (% of pop)
)

DATE_RANGE="1960:${YYYY}"

for ind in "${INDICATORS[@]}"; do
  echo ">>> fetching $ind ..."
  curl -fsSL --retry 3 --retry-delay 5 \
    "https://api.worldbank.org/v2/country/all/indicator/${ind}?format=json&per_page=20000&date=${DATE_RANGE}" \
    -o "${OUTDIR}/${ind}.json"
  sleep 1
done

echo "Done: ${OUTDIR}"
ls -la "${OUTDIR}"
