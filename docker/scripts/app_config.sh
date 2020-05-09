DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Configure laravel env: "
docker-compose exec "$APP_NAME"-app php -r "file_exists('.env') || copy('.env.docker', '.env');"
docker-compose exec "$APP_NAME"-app php artisan key:generate --ansi

echo "Linking storage directory: "
docker-compose exec "$APP_NAME"-app php artisan storage:link

echo "Optimising installation: "
docker-compose exec "$APP_NAME"-app php artisan clear-compiled --env="$APP_ENV"
docker-compose exec "$APP_NAME"-app php artisan optimize --env="$APP_ENV"
docker-compose exec "$APP_NAME"-app php artisan config:cache --env="$APP_ENV"
docker-compose exec "$APP_NAME"-app php artisan cache:clear --env="$APP_ENV"
