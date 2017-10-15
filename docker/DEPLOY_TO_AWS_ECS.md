# AWS ECSへのデプロイ

RDSを外部に立てた状態での、ECSのデプロイ方法です。

## RDS構築

ポイントとしては、DBの文字コードを `utf8mb4` に対応させておくことと、
Indexのサイズもそれに伴い増やしておく必要があることです。

### DB Cluster Parameter Group

下記の通り設定する。

- character_set_client: utf8mb4
- character_set_connection: utf8mb4
- character_set_database: utf8mb4
- character_set_results: utf8mb4
- character_set_server: utf8mb4
- character_set_filesystem: utf8mb4

### DB Parameter Group

下記の通り設定する。

- innodb_file_format: Barracuda
- innodb_large_prefix: 1

## デプロイ

### docker-compose.production.yml

`docker-compose.production.yml` を作成し、環境変数とログの設定を行います。

下記の例を参考に、必要な値を追加及び上書きしてください。

```yml
version: '2'

services:
  nginx:
    image: <Your ECR image name>
    logging:
      driver: awslogs
      options:
        awslogs-group: lodge-nginx
        awslogs-region: ap-northeast-1

  solr:
    image: <Your ECR image name>
    logging:
      driver: awslogs
      options:
        awslogs-group: lodge-solr
        awslogs-region: ap-northeast-1

  rails:
    image: <Your ECR image name>
    environment:
      DB_HOST: <Your database's hostname>
      DB_USERNAME: <Your database's username>
      DB_PASSWORD: <Your database's password>
      SECRET_KEY_BASE: <Some random string>
      DEVISE_SECRET_KEY: <Some random string>
      LODGE_DOMAIN: <Your lodge domain>
      MAIL_SENDER: <Your email address>
      SMTP_ADDRESS: <Your smtp server address>
      SMTP_USERNAME: <Your smtp username>
      SMTP_PASSWORD: <Your smtp password>

      DELIVERY_METHOD: smtp
      RAILS_ENV: production
      SMTP_PORT: 587
      SOLR_URL: http://solr:8983/solr/production
      GOOGLE_CLIENT_ID: 
      GOOGLE_CLIENT_SECRET: 
      SMTP_AUTH_METHOD: plain
      SMTP_ENABLE_STARTTLS_AUTO: 'true'
      SMTP_OPENSSL_VERIFY_MODE: none
      LODGE_THEME: lodge
      SYNTAX_HIGHLIGHT_THEME: pastie
    logging:
      driver: awslogs
      options:
        awslogs-group: lodge-rails
        awslogs-region: ap-northeast-1

```

### ecs-cli によるデプロイ

ecs-cliを利用して下記のようにデプロイします。

#### Build

docker-composeを利用してビルドします。

```bash
docker-compose -f docker-compose.yml -f docker-compose.production.yml build
```

#### ECRへのPush

ECRに下記のようにpushします。

```bash
ecs-cli push <Your Nginx repository name>:<Revision>
ecs-cli push <Your Rails repository name>:<Revision>
ecs-cli push <Your Solr repository name>:<Revision>
```

#### デプロイ

```bash
ecs-cli compose \
  --project-name <Your task definition name> \
  --task-role-arn <Your task role name> \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  up
```

## 初回Deploy準備

初回の場合は、上記では起動しないため少し特殊な手順が必要。

### ECSの対象インスタンス内へSSH

まずはECSのコンテナインスタンス内へsshします。

### コンテナ内から各種コマンドを実行

インスタンス内から、下記のようにコンテナIDを調べてbashをEndpointとして起動します。

```bash
# RailsのイメージIDを調べる
docker images

docker run -it <RailsのイメージID> bash
```


下記コマンドを実行することで、DBの整備が行われ、Lodgeが利用可能になります。

```bash
# 環境変数でDB情報を設定
export RAILS_ENV=production
export DB_HOST=<Your database hostname>
export DB_USERNAME=<Your database username>
export DB_PASSWORD=<Your database password>

# DBの準備
bundle exec rake db:create
```

上記で改めてECSのデプロイをすることで、コンテナが立ち上がるようになりますので、
再度SSHし、今度は下記の要領で最後の処理を行います。

```bash
# RailsのコンテナIDを調べる
docker ps

# 起動中のコンテナにログイン
docker exec -it <RailsのイメージID> bash
```

```
# DBのマイグレーションと絵文字の追加
bundle exec rake db:migrate
bundle exec rake emoji
```

上記で準備完了となります。
