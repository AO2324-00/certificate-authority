# certificate-authority
独自認証局の構築と署名を行う

## 自己署名証明書(CA証明書)の発行

`ca-cert/options.env`の認証局情報を編集し、下記コマンドを実行するとCA証明書が発行されます。
```bash
$ docker compose up
```

CA証明書とその秘密鍵は下記の構成で生成されます。
> ca-cert/<br>
>  ├ CA証明書.pem<br>
>  ├ CA証明書.der<br>
>  └ private/<br>
>     └ CA証明書の秘密鍵.pem

※ すでにCA証明書が存在する場合は新規作成は行われません。

## サーバー証明書署名要求の作成

`server-cert/options.env`のサーバー情報を編集し、下記コマンドを実行するとサーバー証明書署名要求が発行されます。
```bash
$ docker compose --profile create-csr up
```

サーバー証明書署名要求は下記の構成で生成されます。
> server-cert/<br>
>  ├ サーバー証明書署名要求.csr<br>
>  └ サーバー証明書拡張コンフィグ.txt

## サーバー証明書への署名

**前提**
> * `ca-cert/`ディレクトリにCA証明書が、`ca-cert/private/`ディレクトリにCA証明書の秘密鍵が配置されている
> * `server-cert/`ディレクトリにサーバー証明書署名要求が配置されている

下記のコマンドでサーバー証明書への署名を行います。
```bash
$ docker compose up
```

サーバー証明書とその秘密鍵は下記の構成で生成されます。
> server-cert/<br>
>  ├ サーバー証明書.crt<br>
>  └ private/<br>
>     └ サーバー証明書の秘密鍵.pem

## 署名の検証
下記のコマンドを実行し、署名が正常に機能するかを確認します。
```bash
$ env DNS=${DNS} CA_CERT_PATH=${CA証明書} CERT_PATH=${サーバ証明書} PRIVKEY_PATH=${サーバ証明書秘密鍵} docker compose -f test.yaml up
```