DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Update composer and npm: "

docker-compose exec "$APP_NAME"-app composer update
docker-compose exec "$APP_NAME"-node npm update
docker-compose exec "$APP_NAME"-node npm audit fix
docker-compose exec "$APP_NAME"-node npm run dev
