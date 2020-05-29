DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Exec PHP: "

docker-compose exec "$APP_NAME"-app php "$COMMAND"

echo "OK"
