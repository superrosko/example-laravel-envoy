DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "DB migration: "

docker-compose exec "$APP_NAME"-app php artisan migrate
