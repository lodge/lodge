# Docker Composeによるインストール(β)

v0.13.0より、Docker Composeでのセットアップが試験的に可能となりました。
下記手順で、構築、デプロイ/実行できます。

※ 開発環境用にはページ下部を参照。

## 環境準備

### 必要なソフトウェアのインストール

事前準備として以下が必要ですので、インストールしておきます。

- Docker(17.06以上)
- Docker Compose(標準で入っていない場合のみ、最新版で。)

### MySQL設定

utf8mb4に対応させる為、my.cnfの設定を下記のようにしておきます。

```
[mysql]
default-character-set=utf8mb4

[mysqld]
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
innodb_file_format = Barracuda
innodb_file_per_table = 1
innodb_large_prefix
```

## 環境別設定

※ 便宜上、Lodgeのルートディレクトリ(このREADMEがあるディレクトリ) を ${LODGE_ROOT} と呼びます。

`${LODGE_ROOT}/docker/docker-compose.yml` をテキストエディタ等で開き、
`service.rails.environment` 内の各値を編集します。

```yml
services:

  # 〜 中略 〜

  rails:

    # 〜 中略 〜

    environment:
      DATABASE_URL: <Your database's url> # MySQLのEndpoint
      MYSQL_USERNAME: <Your database's username> # MySQLのユーザ名
      MYSQL_PASSWORD: <Your database's password> # MySQLのパスワード
      SECRET_KEY_BASE: <Some random string> # `bundle exec rake secret` 等で生成したランダムな文字列
      DEVISE_SECRET_KEY: <Some random string> # `bundle exec rake secret` 等で生成したランダムな文字列
      LODGE_DOMAIN: <Your lodge domain> # デプロイ先のURL
      MAIL_SENDER: <Your email address> # ユーザ新規登録時に送信者として設定するメールアドレス
      SMTP_ADDRESS: <Your smtp server address> # SMTPサーバのアドレス
      SMTP_USERNAME: <Your smtp username> # SMTPサーバのユーザ名
      SMTP_PASSWORD: <Your smtp password> # SMTPサーバのパスワード

# 〜 以下略 〜
```

## ビルド

下記コマンドでビルドします。

```bash
docker-compose build
```

## デプロイ

下記コマンドでコンテナ内の環境設定を行います。

```bash
docker-compose run rails bundle exec rake db:create
docker-compose run rails bundle exec rake db:migrate
docker-compose run rails bundle exec rake emoji
```

下記コマンドで起動します。

```bash
docker-compose up -d
```

# 開発者向け(developmentモード)

開発モードでは、MySQLも設定等を含めて起動されるため、単体で起動が可能です。

## ビルド

下記コマンドでビルドします。

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml build
```

## デプロイ

下記コマンドでコンテナ内の環境設定を行います。

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run rails bundle exec rake db:create
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run rails bundle exec rake db:migrate
docker-compose -f docker-compose.yml -f docker-compose.dev.yml run rails bundle exec rake emoji
```

下記コマンドで開発モードで起動します。

```bash
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```
