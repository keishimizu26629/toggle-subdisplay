# 🖥️ toggle-subdisplay

macOS専用のディスプレイ拡張/ミラー切り替えCLIツール

## 📋 概要

`toggle-subdisplay` は、MacBook Pro + 外部ディスプレイ1台の環境で、拡張デスクトップとミラー表示を簡単に切り替えるためのCLIツールです。

### 主な特徴

- ✅ **シンプル**: 1コマンドで拡張 ⇄ ミラーを切り替え
- ✅ **安全**: 条件外（外部ディスプレイ0台・2台以上）では何もしない
- ✅ **軽量**: Swift + CoreGraphics のみ、外部依存なし
- ✅ **統合しやすい**: 状態確認API、明確な終了コード

## 🚀 インストール

### ビルド方法

```bash
# リポジトリをクローン
git clone https://github.com/keishimizu26629/toggle-subdisplay.git
cd toggle-subdisplay

# ビルド
swift build -c release

# 実行ファイルをパスの通った場所にコピー（オプション）
cp .build/release/toggle-subdisplay /usr/local/bin/
```

## 📖 使用方法

### 基本的な使用方法

```bash
# 状態確認
toggle-subdisplay -q    # → "on" / "off" / "none"
toggle-subdisplay --query

# モード切り替え
toggle-subdisplay       # 拡張 ⇄ ミラーをトグル
```

### 状態の説明

| 状態 | 説明 |
|------|------|
| `on` | ミラー表示中 |
| `off` | 拡張デスクトップ |
| `none` | 条件外（外部ディスプレイ0台または2台以上） |

### 動作条件

| ディスプレイ構成 | 動作 |
|------------------|------|
| 内蔵 + 外部1台 | ミラー ⇄ 拡張をトグル |
| 内蔵のみ | 何もしない（`none`を返す） |
| 外部2台以上 | 何もしない（`none`を返す） |

## 🔧 技術仕様

- **言語**: Swift 6.0+
- **対応OS**: macOS 10.15+
- **使用API**: CoreGraphics
- **外部依存**: なし

## 📝 終了コード

| コード | 説明 |
|--------|------|
| `0` | 正常終了（トグル成功または条件外） |
| `1` | エラー（CoreGraphics エラーなど） |

## 🧪 テスト

手動テストの実行方法：

```bash
# 1. 内蔵ディスプレイのみの状態で実行
toggle-subdisplay -q  # → "none" が表示されることを確認

# 2. 外部ディスプレイ1台接続状態で実行
toggle-subdisplay -q  # → "on" または "off" が表示されることを確認
toggle-subdisplay     # モードが切り替わることを確認

# 3. 外部ディスプレイ2台以上接続状態で実行
toggle-subdisplay -q  # → "none" が表示されることを確認
```

## 📄 ライセンス

MIT License

## 🤝 コントリビューション

Issue や Pull Request をお待ちしています。

## 📚 関連資料

- [MVP仕様書](https://drive.google.com/drive/folders/your-folder-id)
- [技術仕様書](https://drive.google.com/drive/folders/your-folder-id)
- [API仕様書](https://drive.google.com/drive/folders/your-folder-id)

---

**プロジェクト**: toggle-subdisplay
**作成日**: 2025-11-20
**バージョン**: 1.0
