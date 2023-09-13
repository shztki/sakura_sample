# AWS接続オプションを使い、AWS とさくらのクラウドを接続する

## AWS側環境構築
TransitGatewayで接続する環境を用意するサンプル

### DirectConnectGateway
* ASN は他とかぶらないように注意(特に接続する TransitGateway と)。さくらで使用不可としているものも設定しない。

### TransitGateway
* デフォルトルートテーブルアソシエーションと、デフォルトルートテーブルプロパゲーションは無効にする。
* ASN は他とかぶらないように注意(特に接続する DirectConnectGateway と)。さくらで使用不可としているものも設定しない。
* VPC には、TransitGateway接続用の Subnet を作り、それにアタッチすること。
* TransitGatewayルートテーブルをひとつ作って、そこに今回接続する VPC と DirectConnectGateway(TransitVIF)を関連付け、ルートを設定する。
	* `Terraform の AWS Provider の仕様上、DirectConnectGateway を TransitGateway に関連付けると自動でアタッチメントが作られてしまいタグの設定もできない。`
	* 仕方なく `Data Source: aws_ec2_transit_gateway_attachment` にて DirectConnectGateway とのアタッチメントを抽出して、それにルートテーブルを関連付けるようにしている。
	* ただし、もし同じ TransitGateway に複数の DirectConnectGateway を紐づけていた場合、この条件では正しく抽出できないため、完全に自動化するのは諦めて、部分的に手作業した方が安全な可能性あり。
	* 伝播でも問題無いが、今回は手動で制御できるように静的にルートを設定している

### DirectConnectGateway と TransitGateway の関連付け
* ここで設定する許可されたプレフィックスがオンプレ側に広報される。

### VPC
* 接続したいサーバがあるサブネット用のルートテーブルにのみ、TransitGateway へのルートを設定する。
* NetworkACL/SecurityGroup には、オンプレ側ネットワークからのアクセスを許可する設定をする。

### 参考
https://dev.classmethod.jp/articles/how-to-migrate-from-private-vif-to-transit-vif/  
https://blog.serverworks.co.jp/tech/2020/07/01/asn-with-dx-transitgateway/  
