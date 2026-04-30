# macro-data-archive

マクロ経済指標の月次スナップショットアーカイブ。

**目的**: World Bank / IMF / UN のマクロ指標は静かに改訂される。改訂自体を追跡した研究はほぼ存在しない。今から月次で記録すれば、3年後に世界に他にないデータセットになる。

論文タイトル案: *"Silent Revisions: An Archaeology of Macro-economic Data Across the Global North-South Divide"*

## 仕組み

GitHub Actions cron で毎月1日 18:00 UTC（翌日 03:00 JST）に自動実行。
- `scripts/fetch_worldbank.sh`: World Bank Indicators API から取得
- `scripts/fetch_imf.sh`: IMF SDMX 2.1 API から取得
- `scripts/manifest.sh`: スナップショットの統計を `snapshots.log` に追記
- 差分があれば自動コミット

## ディレクトリ構成

```
data/
  worldbank/YYYY/MM/{indicator}.json
  imf/YYYY/MM/{dataset_freq_country_indicator}.json
snapshots.log
```

## 手動実行

GitHub Actions の `workflow_dispatch` で手動トリガ可。ローカル実行は:

```bash
bash scripts/fetch_worldbank.sh 2026 05
bash scripts/fetch_imf.sh 2026 05
bash scripts/manifest.sh 2026-05-01
```

## 規約

- World Bank: CC BY 4.0（帰属表示で商用・研究利用可）
- IMF: 利用規約に従う（研究利用は基本可、再配布は要確認）

## 取得指標

`scripts/fetch_*.sh` の `INDICATORS` / `TARGETS` 配列に定義。追加・削除はそこを編集。

## TODO
- [ ] UN Comtrade（要登録、subscription-key）追加
- [ ] UNdata SDGエンドポイント追加
- [ ] 改訂検知レポート（前月との差分要約）を Routines で月次生成
