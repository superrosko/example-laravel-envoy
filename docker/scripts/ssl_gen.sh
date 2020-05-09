DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Generate ssl certificates: "

openssl req -new -newkey rsa:"$SSL_BITS" -days "$SSL_EXPIRED" -nodes -x509 -subj \
    "/C=RU/ST=Moscow-State/L=Moscow/O=Developer/CN=$SSL_HOST" \
    -keyout "$SSL_DIR"/nginx-selfsigned.key -out "$SSL_DIR"/nginx-selfsigned.crt
openssl dhparam -dsaparam -out "$SSL_DIR"/dhparam.pem "$SSL_BITS"
