DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Exec Bash: "

docker-compose exec "$APP_NAME"-app bash
