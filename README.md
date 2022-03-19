# メイプルストーリー防御率無視計算ツール
オンラインゲーム「MapleStory」に登場する MOB に与えられるダメージを計算するツールです。

以前 Gulp + TypeScript で作成した計算ツールの Flutter 版  
[Gulp + TypeScript 版](https://github.com/rimanem18/maplestory-ignore-guard)

## ツール概要

1. 仮想的をドロップダウンリストから選択
1. 自身のキャラクターの防御率無視の値を入力
1. 防御率無視に関連するその他オプションにチェック
1. 防御率が設定されている MOB に対してダメージが何 % 通るか確認できます。

## デプロイ
AWS の学習も兼ね、デプロイ先は AWS になっています。  
Amazon S3 にリソースを配置し、CloudFront から配信、HTTPS にするための証明書は ACM で取得しています。  

詳しいところは以下の記事で解説しています。  
[CloudFront+Amazon S3 で 親ドメインを移行せずに Web アプリをデプロイした](https://rimane.net/aws-cloudfront-s3-subdomain/)
