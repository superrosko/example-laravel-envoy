DIR=$(cd "$(dirname "$0")" && pwd)
# shellcheck source=./conf/.configuration
. "$DIR/conf/.configuration"

echo "Create DB user: "

docker-compose exec "$APP_NAME"-mysql mysql --defaults-extra-file=/etc/mysql/config.cnf --database="$DB_DATABASE" --execute="CREATE USER IF NOT EXISTS '$DB_NEW_USER'@'%' IDENTIFIED BY '$DB_NEW_PASSWORD';"
docker-compose exec "$APP_NAME"-mysql mysql --defaults-extra-file=/etc/mysql/config.cnf --database="$DB_DATABASE" --execute="GRANT ALL PRIVILEGES ON \`$DB_DATABASE\`.* TO '$DB_NEW_USER'@'%' WITH GRANT OPTION;"
docker-compose exec "$APP_NAME"-mysql mysql --defaults-extra-file=/etc/mysql/config.cnf --database="$DB_DATABASE" --execute="FLUSH PRIVILEGES;"

echo "OK"