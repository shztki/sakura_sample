# AWS接続オプションを使い、AWS とさくらのクラウドを接続する

## AWS側環境構築
TransitGatewayで接続する環境を用意するサンプル

### DirectConnectGateway
* ASN は他とかぶらないように注意(特に接続する TransitGateway と)。さくらで使用不可としているものも設定しない。

### TransitGateway
* デフォルトルートテーブルアソシエーションと、デフォルトルートテーブルプロパゲーションは無効にする。
* ASN は他とかぶらないように注意(特に接続する DirectConnectGateway と)。さくらで使用不可としているものも設定しない。
* VPC には、TransitGateway接続用の Subnet を作り、それにアタッチすること。
* TransitGateway用ルートテーブルを個別に作って、アタッチメントごとにルートを制御する。
	* `Terraform の AWS Provider の仕様上、DirectConnectGateway を TransitGateway に関連付けると自動でアタッチメントが作られてしまいタグの設定もできない。`
	* 仕方なく `Data Source: aws_ec2_transit_gateway_attachment` にて DirectConnectGateway とのアタッチメントを抽出して、それにルートテーブルを紐づけるようにしている。
	* この参照関係の問題のせいか、全削除したときに一度エラーで一部リソースが残るが、もう一度 terraform destroy すれば削除できる。

### DirectConnectGateway と TransitGateway の関連付け
* ここで設定する許可されたプレフィックスがオンプレ側に広報される。

### VPC
* 接続したいサーバがあるサブネット用のルートテーブルにのみ、TransitGateway へのルートを設定する。
* NetworkACL/SecurityGroup には、オンプレ側ネットワークからのアクセスを許可する設定をする。

### 参考
https://dev.classmethod.jp/articles/how-to-migrate-from-private-vif-to-transit-vif/  
https://blog.serverworks.co.jp/tech/2020/07/01/asn-with-dx-transitgateway/  
