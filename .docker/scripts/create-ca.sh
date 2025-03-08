CATOP=/etc/pki

has_cert=false

if [ -e "$CATOP/private/$ca_privkey_name.pem" ]; then
    echo "[Info] $CATOP/private/$ca_privkey_name.pem を確認しました。"
    has_cert=true
fi

if [ -e "$CATOP/$ca_cert_name.pem" ]; then
    echo "[Info] $CATOP/$ca_cert_name.pem を確認しました。"
    has_cert=true
fi

if ! $has_cert; then
    echo -e "[Info] CA証明書を作成します。"

    # 出力用のディレクトリを作成する
    mkdir -p $CATOP/private

    # 秘密鍵を生成して自己署名証明書を発行する
    openssl req -new \
        -keyout     $CATOP/private/$ca_privkey_name.pem \
        -out        $CATOP/$ca_cert_name.pem \
        -passout    env:pass \
        -subj       "/C=$countryName/ST=$stateOrProvinceName/L=$localityName/O=$organizationName/OU=$organizationalUnitName/CN=$common_name" \
        -x509 -days $ca_expiration_days \
        -pkeyopt    rsa_keygen_bits:$rsa_keygen_bits \
        -extensions v3_ca \
        -sha256

    echo -e "\n\n[$CATOP/$ca_cert_name.pem]\n"

    # 証明書の中身を確認する
    openssl x509 -text -noout -in $CATOP/$ca_cert_name.pem

    # 秘密鍵のパーミッションを変更する
    chmod 0400 $CATOP/private/$ca_privkey_name.pem

    # 証明書の拡張子を変更する
    openssl x509 -inform PEM -outform DER -in $CATOP/$ca_cert_name.pem -out $CATOP/$ca_cert_name.der

fi