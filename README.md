# template-azd-terraform
azd-terraformのテンプレートレポジトリ

## APM (Agent Package Manager) での利用

このリポジトリの `apm.yml` は `catalog/skills` 配下の skills と、API Center の MCP レジストリに登録済みの MCP サーバーを配布します。各 MCP サーバーのエントリには `registry:` として API Center のレジストリ URL を埋め込んでいるため、利用者側でレジストリ設定を行う必要はありません。

1. [APM](https://microsoft.github.io/apm/) をインストール
2. 依存関係をインストール
   ```bash
   apm install
   ```

注意: API Center のこのエンドポイントは Entra ID 認証が必要です。認証ヘッダーを APM が付与できない場合は、レジストリ側を匿名読み取り可能にするか、認証を肩代わりするプロキシ経由で `registry:` の値を指定してください。
