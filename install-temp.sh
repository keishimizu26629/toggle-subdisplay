#!/bin/bash

# toggle-subdisplay 一時インストールスクリプト
# 他人のシステムを汚さない方法

set -e

echo "🖥️  toggle-subdisplay 一時インストール"
echo "=================================="

# 一時ディレクトリを作成
TEMP_DIR=$(mktemp -d)
echo "📁 一時ディレクトリ: $TEMP_DIR"

# バイナリをダウンロード
echo "📥 バイナリをダウンロード中..."
curl -L -s https://github.com/keishimizu26629/toggle-subdisplay/releases/download/v0.1.0/toggle-subdisplay -o "$TEMP_DIR/toggle-subdisplay"

# 実行権限を付与
chmod +x "$TEMP_DIR/toggle-subdisplay"

echo "✅ インストール完了！"
echo ""
echo "🚀 使用方法:"
echo "  $TEMP_DIR/toggle-subdisplay -q    # 状態確認"
echo "  $TEMP_DIR/toggle-subdisplay       # モード切り替え"
echo ""
echo "🧹 使用後のクリーンアップ:"
echo "  rm -rf $TEMP_DIR"
echo ""

# オプション: PATHに一時追加
read -p "一時的にPATHに追加しますか？ (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    export PATH="$TEMP_DIR:$PATH"
    echo "✅ PATHに追加しました。このセッション中は 'toggle-subdisplay' で実行可能です。"
    echo "⚠️  ターミナルを閉じると自動的に削除されます。"
else
    echo "💡 フルパスで実行してください: $TEMP_DIR/toggle-subdisplay"
fi
