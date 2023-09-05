# デザインパターン 07 (DB+VPCルータ+ローカルルータ構成)
さくらのクラウドで、AWS接続オプションを使って、AWS側環境と連携する場合の、さくらのクラウド側環境を作成するためのコードです。  
残念ながら AWS接続オプションの作成と、そちら側でのローカルルータとのピア接続設定は、手作業になります。  
AWS接続オプションのリソースID とシークレットキーが発行されたら、環境変数に登録して、コメントにしているローカルルータのコード内のピア接続設定を使って、ローカルルータ側のピア接続設定は可能です。    

## サンプル構成図
![](img/sample_07.drawio.svg)

## 概算見積もり
[料金シミュレーション](https://cloud.sakura.ad.jp/payment/simulation/#/?state=e3N6OiJ0azFiIixzdDp7InVuaXQiOiJtb250aGx5IiwidmFsdWUiOjF9LHNpOiIiLGl0OntzZTpbe3A6MSxxOjEsZGk6W3twOjUscToxfV0sIm9zIjpudWxsLGxhOm51bGwsd2E6bnVsbCxpcGhvOmZhbHNlfV0sc3c6W3twOjEscToxfV0sbG86W3twOjEscToxfV0sdnA6W3twOjEscToxLHdhOm51bGx9XX19)  
※AWS接続オプションの費用は含まれないのと、転送量費用も別途かかるのでご注意ください。  

## 利用方法
```
$ cd ~/work/sakura_design_pattern/07_shared_internet_db_vpc_localrouter/
$ terraform init
$ terraform plan
$ make apply ※通常は terraform apply だが、初回のみ SSH用鍵ファイル作成のため
$ terraform destroy ※全リソース削除
```

## 備考
* サーバは SSH鍵認証で入ることとしており、利用する鍵は Terraform で作成しています。  
Makefile を用意していますので、 `terraform apply` ではなく、 `make apply` としていただくことで、フォルダ内に .ssh フォルダを作成し、秘密鍵と公開鍵を作成します。  
作成後は `vpc_router01_ip` が出力されますので、そのグローバルIPアドレスに対して SSH接続できることをご確認ください。  
VPCルータにてポートフォワーディングを設定していますので、DBサーバ側にはそれでログインします。
```
$ ssh -p 10022 -i .ssh/sshkey sakura-user@VPCルータのグローバルIPアドレス
```

## 参考
https://manual.sakura.ad.jp/cloud/network/aws-connect.html  
https://manual.sakura.ad.jp/cloud/network/localrouter.html  