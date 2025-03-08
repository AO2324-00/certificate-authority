CATOP=/etc/pki
SERVER_DIRECTORY=/server-cert

# 出力用のディレクトリを作成する
mkdir -p $SERVER_DIRECTORY

has_cert=true

if [ ! -e "$CATOP/private/$ca_privkey_name.pem" ]; then
    echo "[Error] $CATOP/private/$ca_privkey_name.pem が存在しません。"
    has_cert=false
fi

if [ ! -e "$CATOP/$ca_cert_name.pem" ]; then
    echo "[Error] $CATOP/$ca_cert_name.pem が存在しません。"
    has_cert=false
fi

if ! $has_cert; then
    exit 1
fi

for file in `find $SERVER_DIRECTORY -name '*.csr'`; do

    crt_file=${file/.csr/.crt}
    extfile=${file/.csr/.txt}

    if [ -e $extfile ]; then
        openssl x509 -req \
            -in         $file \
            -CA         $CATOP/$ca_cert_name.pem \
            -CAkey      $CATOP/private/$ca_privkey_name.pem \
            -out        $crt_file \
            -days       $server_expiration_days \
            -passin     env:pass \
            -extfile    $extfile \
            -CAserial   $CATOP/serial.srl \
            -CAcreateserial
    else
        openssl x509 -req \
            -in         $file \
            -CA         $CATOP/$ca_cert_name.pem \
            -CAkey      $CATOP/private/$ca_privkey_name.pem \
            -out        $crt_file \
            -days       $server_expiration_days \
            -passin     env:pass \
            -CAserial   $CATOP/serial.srl \
            -CAcreateserial
    fi

    echo -e "\n\n[$crt_file]\n"

    openssl x509 -text -noout -in $crt_file

    echo -e "\n\n[openssl verify]"

    openssl verify -CAfile $CATOP/$ca_cert_name.pem $crt_file

done