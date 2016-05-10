[![Gitter chat](https://badges.gitter.im/lodge/lodge.png)](https://gitter.im/lodge/lodge)
[![Build Status](https://travis-ci.org/lodge/lodge.svg?branch=release)](https://travis-ci.org/lodge/lodge)
[![Coverage Status](https://coveralls.io/repos/lodge/lodge/badge.png?branch=release)](https://coveralls.io/r/lodge/lodge?branch=release)
[![Code Climate](https://codeclimate.com/github/lodge/lodge/badges/gpa.svg)](https://codeclimate.com/github/lodge/lodge)

----

## これは何？

ロッジと呼びます。
__イントラネット限定でも使える、ナレッジ/ノウハウ情報共有サービス__です。
手軽に導入できて、チーム内全体の情報共有やナレッジ蓄積の手助けができることを目標としています。

## 主な特徴

以下のような特徴を持ちます。

- **無料、OSS、MIT License**
- イントラネット内での構築が可能なので、社外秘な情報を含むナレッジやノウハウの共有に利用可能。
- Markdown記法による直感的かつ簡単な記述でサクサク書ける
- コードのシンタックスハイライト機能
- 投稿前に確認できるプレビュー機能
- ストック機能により、お気に入りの記事やあとで見たい記事等を手軽に保存
- 記事に複数のタグをつけて管理
- タグをフォローすることによる個人ごとのフィードのカスタマイズ表示
- 全文検索や各種クエリなどを利用した高度な検索機能
- 導入までの手軽さ(すぐにインストールできます)
- コメント、Contribution、通知機能等によるコミュニケーションやナレッジ共有活動の活性化
- 編集履歴機能により記事の変更点を差分表示
- メールアドレスだけで誰でも簡単にアカウント作成が可能
- Gravatarと連携したユーザアイコン(登録メールアドレスから自動取得)

上記以外にもまだまだ新機能開発や改善を行っていく予定です。皆様のご協力をお願い致します。

## スクリーンショット

一覧画面

![一覧画面](./lodge01.png)

記事閲覧画面

![記事閲覧画面](./lodge02.png)

## インストール

1. 事前準備として以下が必要ですので、インストールしておきます。
    - Ruby 2.1以上
    - Gem 2.2以上
    - MySQL (MySQLを利用する場合)
    - sqlite3 (sqlite3を利用する場合)
    - Bundler

1. まずは本プロジェクトをcloneしてきます。

    ```bash
    git clone https://github.com/m-yamashita/lodge.git
    ```

1. カレントディレクトリを移動します

   ```
   cd lodge
   ```

1. Bundler をインストールします

   ```
   gem install bundler
   ```

1. `config/database.example.yml` を `config/database.yml` としてコピーし、以下のように編集します(SQLite3もしくはMySQLをご利用になる場合はコメントアウトを外して設定すると楽です)。

    ```yml
    default: &default
    #  # === sqlite3 ===
    #  adapter: sqlite3
    #  encoding: utf8
    #  pool: 5
    
      # === mysql ===
      adapter: mysql2
      host: localhost
      username: your_mysql_user_name
      password: your_mysql_password
      encoding: utf8
      pool: 5
    ```

1. `bundle install` を実行し、依存ライブラリをインストールします。
1. `.env.example` を `.env` としてコピーし、必要な環境変数を設定します。各コメントを参考に設定してください。最低限設定が必要な項目は以下の通りです。

    ```ruby
    ### アプリケーションのドメイン
    LODGE_DOMAIN      = example.com

    # Cookie 検証用キーの設定
    # productionモードで動かす場合に設定（`bundle exec rake secret` で生成する）
    SECRET_KEY_BASE   = __some_random_string__

    # 認証キーの設定
    # productionモードで動かす場合に設定（`bundle exec rake secret` で生成する）
    DEVISE_SECRET_KEY = __some_random_string__

    ### メールの設定

    # 外部 MTA (SMTPサーバ) を利用してメール送信する場合
    DELIVERY_METHOD   = smtp

    # DELIVERY_METHOD = smtp の場合のみ
    # 以下の設定が有効です（それ以外は無視されます）
    SMTP_ADDRESS      = smtp.gmail.com
    SMTP_PORT         = 587
    SMTP_USERNAME     = username
    SMTP_PASSWORD     = password
    SMTP_AUTH_METHOD  = plain
    SMTP_ENABLE_STARTTLS_AUTO = true

    # テーマを設定します。
    LODGE_THEME       = lodge
    ```
1. `bundle exec rake db:create RAILS_ENV=production` を実行し、データベースを作成します。
1. `bundle exec rake db:migrate RAILS_ENV=production` を実行し、テーブルを作成します。

## 絵文字の準備

[github/gemoji](https://github.com/github/gemoji)を利用して各種絵文字を利用できます。

絵文字をダウンロードする為、以下のコマンドを実行します。

```bash
bundle exec rake emoji
```

## 全文検索エンジンの準備

以下を実行し、全文検索エンジンのセットアップを行います。

```bash
./setup/sunspot-solr/setup-sunspot-solor.sh
```

上記により、solrの基本設定及び初回のIndex構築が行われます。

### インデックスの手動更新(再作成)について

新規構築から利用する場合は通常必要ありませんが、
既存のLodgeからのアップデートを行った場合のインデックス作成や、
何らかの原因で検索インデックスを再構築したくなることがあった場合は、
Solrサーバが起動した状態で下記コマンドを実行することで再構築することができます。

```bash
bin/rake sunspot:reindex RAILS_ENV=production
```

## Lodge(及びSolrサーバ)の起動

1. カレントディレクトリを移動します。
    
    ```bash
    cd <lodgeをクローンしたディレクトリ>
    ```
    
1. 全文検索用のSolrサーバを起動します。
    
    ```bash
    bin/rake sunspot:solr:start RAILS_ENV=production
    ```
    
    - もし上記で起動できない場合は…
        
        前回の起動プロセスなどが残っている可能性がありますので、
        
        ```bash
        bin/rake sunspot:solr:restart RAILS_ENV=production
        ```
        
        を何度か実行してみてください。
        
1. Railsサーバを起動します。
    * Unicorn を使う場合
        
        ```bash
        bundle exec unicorn -c config/unicorn.rb -E production
        ```
        
    * Thin を使う場合
        
        ```bash
        bundle exec rails server thin -e production
        ```
        
    * WEBrick を使う場合
        
        ```bash
        bundle exec rails server -e production
        ```
        
1. ブラウザで http://localhost:3000 にアクセスできたら起動成功です
1. ログファイルは以下の場所に吐き出されます
    * Unicorn の場合
        * `<lodgeをクローンしたディレクトリ>/log/unicorn.production.log`
    * Thin, WEBrick の場合
        * `<lodgeをクローンしたディレクトリ>/log/production.log`

### 注意

Solrサーバを起動することにより、ポート `8983` にSolrの管理コンソールが起動し、
ブラウザからアクセスできる状態となってしまいます。

その為、悪意あるユーザがアクセスしてしまうことが懸念される場合、
以下のような対応が必要となるでしょう。

#### nginxを利用

フロントにnginxなどを立てておき、リバースプロキシ等を設定しアクセスを制限する。

#### Solrサーバーを個別に立てる

Solrサーバを別のサーバや立てておき、そちらに接続しにいく形にします。
その場合は、[Sunspot公式サイト](https://github.com/sunspot/sunspot#configuration)に従い、
`config/sunspot.yml` を適切な値へ設定してください。

またこのようにSolrサーバを別に構築する場合は、膨大な記事数等がある場合に、
検索や記事作成/更新時のパフォーマンスが著しく低下してしまうような場合にも有効です。
(ただ、通常はそこまでの規模になることはほぼ無いであろうと考えられます。)

## Vagrant up

[VirtualBox](https://www.virtualbox.org/) と [Vagrant](http://www.vagrantup.com/) を使って、
``vagrant up`` することで、VM上に手早く開発環境を用意することができます。

### 手順

1. VirtualBox をインストール
1. Vagrant をインストール
1. ``vagrant plugin install vagrant-vbguest``
1. ``vagrant plugin install vagrant-librarian-chef``
1. ``vagrant plugin install vagrant-vmware-fusion``
1. ``vagrant plugin install vagrant-gatling-rsync``
1. ``vagrant plugin uninstall vagrant-vmware-fusion``
    * vagrant-gatling-rsync をインストールするために必要だが、VMWare のライセンスを持っていないとエラーになるため削除します
1. ``git clone https://github.com/m-yamashita/lodge``
1. ``cd lodge``
1. ``vagrant up``
1. VMが起動するまで待つ
1. ``vagrant gatling-rsync-auto``
    * ホスト上の ``git clone`` したソースコードを自動的にVM上の ``/vagrant`` に同期するために必要です
    * ``vagrant rsync-auto`` がなぜか ``rsync__exclude`` を使ってくれないため、 ``vagrant-gatling-rsync`` を利用します
    * [公式ドキュメントのNFSの項目](https://docs.vagrantup.com/v2/synced-folders/nfs.html) に書かれていますが、VirtualBox の共有フォルダはパフォーマンスが悪いため使用していません。

      > In some cases the default shared folder implementations (such as VirtualBox shared folders) have high performance penalties. 

1. http://localhost:3000/ にアクセスして Lodge の画面を見ることができたら成功です

### 諸々の情報

* アクセス URL
    * http://localhost:3000/
* DB
    * MySQL
* メールサーバ
    * VM 内の Postfix
* Lodge の起動スクリプト
    * ``/etc/init.d/lodge`` （Unicorn を起動）
* RAILS_ROOT
    * ``/vagrant``
* RAILS_ENV
    * ``development``
* ログ
    * ``/vagrant/log/unicorn.development.log``

## 最後に

### 開発にご協力頂ける方を募集しています。

まだまだ拙いLodgeの開発を手助けしていただける方を大募集中です。
新機能の開発や改善はもちろん、ソースのリファクタリングからテストの記述、
果てはマニュアル改善まで、どうぞ遠慮無くpull request頂ければと思います。
開発前に[開発ガイド](https://github.com/lodge/lodge/wiki/開発ガイド)に目を通して頂けると幸いです。
