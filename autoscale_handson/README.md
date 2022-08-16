# さくらのクラウド オートスケール勉強会用環境構築について

複数アカウントに、オートスケール動作確認用の環境を構築します。  
Terraform と usacloud がインストールされた Linux環境を準備し、本リポジトリをクローンします。  

## 手順

1. さくらのクラウド コントロールパネルのホーム画面で、必要な数のアカウントを作成します
1. さくらのクラウド コントロールパネルのホーム画面で、各アカウント毎に APIキーを作成します
1. 上記 APIキー作成時に、同時に Linux環境側でも usacloud用プロファイルの登録作業を実施します  
    ```
    usacloud config create --name handson1
    ```
    * 特に必須ではありませんが、名前はアカウント名とそろえるとわかりやすいです
    * 名前の末尾は 0埋めしない数字の連番にするのがよいです
    * アクセストークンとアクセストークンシークレット以外の項目は一切入力せず、Enter を押し続けて登録を完了させてください
1. APIキー作成後の URL には `apiKeyId=**********` が表示されていますので、このリソースID をコピーし、 `api_key_id.txt` というファイルに 1行に 1つずつ記載しておきます
   * プロファイル名の末尾の数字が、そのまま行番号になるようにしてください 
1. 上記 2～4 の作業を必要なアカウント数で実行したら、以下のようにして Terraform の workspace をまとめて作成します  
    ```fish
    for i in (seq 1 5); terraform workspace new handson$i; terraform workspace list; end
    ```
    * shell は fish 利用のため、bash の場合は以下のようになるので注意してください
    ```shell
    for i in `seq 1 5`; do terraform workspace new handson$i; terraform workspace list; done
    ```
1. あとはたとえば以下のような形で、各 workspace をまとめて構築、削除可能です
    * 全 workspace でまとめて init/plan/apply/output/destroy
    ```fish
    for i in (seq 1 5); set -x TF_VAR_api_key_id (cat api_key_id.txt | head -$i | tail -1); terraform workspace select handson$i; terraform workspace list; terraform init; end
    for i in (seq 1 5); set -x TF_VAR_api_key_id (cat api_key_id.txt | head -$i | tail -1); terraform workspace select handson$i; terraform workspace list; terraform plan; end
    for i in (seq 1 5); set -x TF_VAR_api_key_id (cat api_key_id.txt | head -$i | tail -1); terraform workspace select handson$i; terraform workspace list; terraform apply -auto-approve; end
    for i in (seq 1 5); set -x TF_VAR_api_key_id (cat api_key_id.txt | head -$i | tail -1); terraform workspace select handson$i; terraform workspace list; terraform output -json; end
    for i in (seq 1 5); set -x TF_VAR_api_key_id (cat api_key_id.txt | head -$i | tail -1); terraform workspace select handson$i; terraform workspace list; terraform destroy -auto-approve; end
    ```
    * shell は fish 利用のため、bash の場合は以下のようになるので注意してください(planを例にしたサンプル)
    ```shell
    for i in `seq 1 5`; do export TF_VAR_api_key_id=`cat api_key_id.txt | head -$i | tail -1`; terraform workspace select handson$i; terraform workspace list; terraform plan; done
    ```

## Tips 

* Linux環境では環境変数に以下の設定が必要です。

```
TF_VAR_default_password=**************************** → サーバに設定する rootパスワード
```

* workspace をまとめて削除する場合は、以下のように実施します

```fish
terraform workspace select default
for i in (seq 1 5); terraform workspace delete handson$i; terraform workspace list; end
```

* スケールアップ/ダウンするとリソースID が変わってしまうため、継続して Terraform で管理する場合、適宜 workspace を切り替えて、以下のような対応が必要です

```
terraform state rm sakuracloud_server.server02
terraform import sakuracloud_server.server02[0] ************
terraform import sakuracloud_server.server02[1] ************

terraform state rm sakuracloud_proxylb.elb01
terraform import sakuracloud_proxylb.elb01 ************
```

## 注意事項
* オートスケールに耐えうる構成とする場合、起動テンプレートとなるようなマスターイメージの管理や、ログ等の外部保存、ステートレスな設計など、システムの構成を事前に十分検討する必要があります。  

* オートスケール設定で指定する名前やプレフィックスには十分注意してください。部分一致のものなどもあり、短い名前にしてしまうと、想定外のリソースも巻き込まれる危険性があります。

* オートスケールは初期設定をすれば終わりというものではないので、運用を通して都度改善を実施することが重要です。

* スケールアウト用の yamlファイルにはサーバのパスワードをそのまま記載することになり、あまり好ましくありません。本サンプルではあえて記載はしておりませんので、適宜修正してください。
  * もうひとつの [autoscale サンプル](https://github.com/shztki/sakura_sample/blob/main/autoscale/autoscale.tf) では、config は jsonencode して渡す形にしてあるので、そちらの方がコード上は安全です。
