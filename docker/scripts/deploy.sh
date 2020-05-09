DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Deploy: "

docker-compose exec "$APP_NAME"-app /home/www-user/.composer/vendor/bin/envoy run deploy

