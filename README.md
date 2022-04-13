# WAN SEARCH (ワン サーチ)
現在地周辺のペット可のお店を検索し、GOOGLE MAP上に表示するアプリケーションです。

## URL
https://wan-search.com

## なぜ作ったのか
愛犬と散歩に行って一休憩...と思いきや意外とペット可のお店を知りませんでした。  
グルメ検索サイトで調べようと思っても条件設定を開いて設定しなければならず、検索しても検索結果は基本リスト表示です。  
そこで、MAPで直感的に現在地周辺のペット化のお店が調べられたらと思いWAN SEARCHを作成しました。  

## ゲストログイン
新規登録画面またはログイン画面から「ゲストログイン」ボタンを押下してください。

## 使用技術
- Ruby 3.1.0
- Ruby on Rails 6.1.4.4
- MySQL 8.0
- Nginx
- Puma
- AWS
  - VPC
  - ECS
  - Fargate
  - ECR
  - RDS
  - Route53
  - S3
  - ALB
  - Code Deploy
  - Code Build
  - Code Pipeline
- Docker/Docker-compose
- RSpec
- Google Maps API
- ホットペッパーグルメサーチAPI

## AWS構成図  
![AWS構成図](docs/images/aws-networking.png)  

### CI/CD
- Githubにてプルリクエストが出された時、またはプルリクエストが更新されたときにCodebuildによってRSpecが自動で実行されます。
- 開発ブランチがmasterブランチにマージされると、DockerイメージのPushとBlue/Greenデプロイが自動で実行されます。

## ER図  
![ER図](docs/images/cafeapp-er.png)  

## 機能一覧
- 現在地周辺のショップ検索機能
  - ホットペッパーグルメAPIのデータベースを利用
  - GOOGLE MAPに現在地とショップにピンを立てる  
![現在地周辺のショップ検索機能](docs/images/howto_search.gif)  
- ユーザー登録、ログイン機能(devise)
- お気に入り機能(Ajax)　　  
![お気に入り機能](docs/images/howto_favorite.gif)  
- レビュー機能(Ajax)  
![レビュー機能](docs/images/howto_review.gif)  
- マイページ
  - アイコン画像、名前、メールアドレス、パスワード変更可能
  - 自分のお気に入り一覧(Ajax通信で削除可能)
  - マイレビュー一覧(Ajax通信で編集・削除可能)

## テスト
### RSpec
- 単体テスト(Model Spec)
- 結合テスト(Request Spec)
- システムテスト(Feature Spec)

## 実装予定の機能
- キーワード検索（ex.駅名で検索）
