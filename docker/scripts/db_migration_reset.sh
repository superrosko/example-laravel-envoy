DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "DB migration and seeding:"

docker-compose exec "$APP_NAME"-app php artisan migrate:fresh
docker-compose exec "$APP_NAME"-app php artisan db:seed
