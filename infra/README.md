# 初期化と適用

```
terraform init   # 初期化
terraform plan   # プランの確認
terraform apply -auto-approve # 実際にリソースを作成
```

# Terraform Destroy の手順

現在の設定を確認: Terraform の設定ファイル（例：main.tf）が正しいことを確認します。

破壊計画を確認: 破壊されるリソースを確認するためにプランを作成します。

```
terraform plan -destroy
```

破壊を実行: インフラストラクチャを破壊します。

```
terraform destroy -auto-approve
```

# エラー解消方法

## ログ出力

```
TF_LOG=DEBUG terraform plan
```
