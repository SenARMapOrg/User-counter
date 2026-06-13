# リダイレクトカウンター

URLへのアクセス数をカウントしながらリダイレクトするツール。
一時的なデータ集計用に用いるために設計したので、セキュリティや設計に問題がある可能性があります

## 使い方

### リダイレクト

```
GET /redirect?name=<名前>&url=<リダイレクト先>
```

- `name`: カウントに使うラベル（省略可）
- `url`: リダイレクト先URL（省略時はトップページ）

例：
```
/redirect?name=campaign_a&url=https://example.com
```

### 管理画面

```
GET /redirect/control
```

カウント数の確認・リセット、追跡する名前の管理ができる。

## 起動

```bash
docker compose up
```

アプリは `http://localhost:3000` で起動する。
