DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Install composer and npm: "

docker-compose exec "$APP_NAME"-app composer install
docker-compose exec "$APP_NAME"-node npm install
docker-compose exec "$APP_NAME"-node npm audit fix
docker-compose exec "$APP_NAME"-node npm run dev
