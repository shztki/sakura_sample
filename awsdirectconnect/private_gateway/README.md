# AWS接続オプションを使い、AWS とさくらのクラウドを接続する

## AWS側環境構築
Virtual Private Gateway で接続する環境を用意するサンプル

### Virtual Private Gateway
* すでに存在するので、そちらを利用して VPC にアタッチする

### VPC
* 接続したいサーバがあるサブネット用のルートテーブルにのみ、VGW の伝播を有効にする
* NetworkACL/SecurityGroup には、オンプレ側ネットワークからのアクセスを許可する設定をする


