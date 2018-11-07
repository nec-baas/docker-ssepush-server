NECモバイルバックエンド基盤 Dockerfile
====================================

NECモバイルバックエンド基盤サーバ (SSEPushサーバ)用のDockerfile

以下イメージを含む。

* necbaas/ssepush-server

起動例
------

    $ docker pull necbaas/ssepush-server
    $ docker run -d -p 8080:8080 -e JAVA_OPTS="-Xmx2048m" -e AMQP_URI=amqp://rabbitmq:rabbitmq@rabbitmq1.example.com:5672 necbaas/ssepush-server

なお、動作検証に、RabbitMQ サーバが必要の場合は、Docker Hub のオフィシャルコンテナーを利用してください。

RabbitMQ サーバ コンテナーの起動方法

    $ docker run -d --hostname baas-rabbitmq --name baas-rabbitmq-server -e RABBITMQ_DEFAULT_USER=rabbitmq -e RABBITMQ_DEFAULT_PASS=rabbitmq rabbitmq:3-alpine

ssepush-server　の環境変数 AMQP_URI にある hostname　を 下記のコマンドで取得した IPAddress に置き換えます。

    $ docker inspect --format="{{ .NetworkSettings.IPAddress }}" baas-rabbitmq-server

環境変数
--------

SSEPUSH サーバ 実行時には以下の環境変数が参照される。

### Java 関連

* JAVA_OPTS : Java VM オプション (default: なし)

### Tomcat 関連

* TOMCAT_MAX_THREADS: Tomcat最大スレッド数 (default: 2000)
* TOMCAT_MAX_CONNECTIONS: Tomcat最大コネクション数 (default: 2000)
* TOMCAT_SCHEME: Tomcat HTTP connector scheme (default: http)
* TOMCAT_SECURE: Tomcat HTTP connector secure (default: false)
* TOMCAT_PROXY_PORT: Tomcat Proxyポート (default: なし)


### SSEPush Server 関連

* AMQP_URI : AMQP URI (default: amqp://rabbitmq:rabbitmq@rabbitmq.local:5672)
* HEART_BEAT_INTERVAL_SEC : SSE ハートビート間隔(秒) (default: 30)

### ロギング
* LOG_LEVEL: ログレベル (default: INFO)

制限事項
---------

現在の設定では、スケールアウト(コンテナ数増加)ができないという 問題あります。

これは、クラスタリングに使用している Hazelcast(インメモリ データグリッド)がデフォルトではマルチキャストを使用しているためです。
OpenShift/Kubernetes では通常マルチキャストが通らない ので、クラスタを正常に組むことができません。
