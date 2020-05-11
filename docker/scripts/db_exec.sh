DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Exec DB: "

docker-compose exec "$APP_NAME"-mysql mysql --defaults-extra-file=/etc/mysql/config.cnf --database="$DB_DATABASE"

echo "OK"
