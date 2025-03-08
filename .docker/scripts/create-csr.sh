CATOP=/etc/pki

common_name=$server_dns

file_name=${server_dns/\*/WILD}

echo -e "[Info] 署名リクエストを生成します。"

# 出力用のディレクトリを作成する
mkdir -p $CATOP/private

# genrsaコマンドでパスフレーズなしの秘密鍵を生成する
openssl genrsa -out $CATOP/private/$file_name.pem $rsa_keygen_bits

# reqコマンドでCSR(証明書署名要求)を出力する
openssl req -new \
    -key    $CATOP/private/$file_name.pem \
    -out    $CATOP/$file_name.csr \
    -subj   "/C=$countryName/ST=$stateOrProvinceName/L=$localityName/O=$organizationName/OU=$organizationalUnitName/CN=$common_name" \
    -sha256

echo -e "\n\n[$CATOP/$file_name.csr]\n"

# 証明書の中身を確認する
openssl req -text -noout -in $CATOP/$file_name.csr

echo -e "subjectAltName = DNS:$server_dns, IP:$server_ip" > $CATOP/$file_name.txt