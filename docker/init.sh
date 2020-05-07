DB_NEW_USER="example-laravel-envoy-user"
DB_NEW_PASSWORD="password"
DB_DATABASE="example-laravel-envoy-db"
APP_NAME="example-laravel-envoy"

DB_USER="root"
DB_PASSWORD="password"
DIR=$(dirname $0)

# Generate ssl crt
openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj \
    "/C=RU/ST=Moscow-State/L=Moscow/O=Developer/CN=localhost" \
    -keyout $DIR/ssl/nginx-selfsigned.key -out $DIR/ssl/nginx-selfsigned.crt
openssl dhparam -dsaparam -out $DIR/ssl/dhparam.pem 4096

# Docker compose restart
docker-compose down
docker-compose up -d

# Create DB user
docker-compose exec "$APP_NAME"-mysql mysql --user="$DB_USER" --password="$DB_PASSWORD" --database="$DB_DATABASE" --execute="CREATE USER '$DB_NEW_USER'@'%' IDENTIFIED BY '$DB_NEW_PASSWORD';"
docker-compose exec "$APP_NAME"-mysql mysql --user="$DB_USER" --password="$DB_PASSWORD" --database="$DB_DATABASE" --execute="GRANT ALL PRIVILEGES ON \`$DB_DATABASE\`.* TO '$DB_NEW_USER'@'%' WITH GRANT OPTION;"
docker-compose exec "$APP_NAME"-mysql mysql --user="$DB_USER" --password="$DB_PASSWORD" --database="$DB_DATABASE" --execute="FLUSH PRIVILEGES;"

# Install composer and npm
docker-compose exec "$APP_NAME"-app composer install
docker-compose exec "$APP_NAME"-node npm install
docker-compose exec "$APP_NAME"-node npm run dev

# Configure laravel env
docker-compose exec "$APP_NAME"-app php -r "file_exists('.env') || copy('.env.docker', '.env');"
docker-compose exec "$APP_NAME"-app php artisan key:generate --ansi

# Linking storage directory
docker-compose exec "$APP_NAME"-app php artisan storage:link

# DB migration and seeding
docker-compose exec "$APP_NAME"-app php artisan migrate
docker-compose exec "$APP_NAME"-app php artisan db:seed

# Optimising installation
docker-compose exec "$APP_NAME"-app php artisan clear-compiled --env={{$env}};
docker-compose exec "$APP_NAME"-app php artisan optimize --env={{$env}};
docker-compose exec "$APP_NAME"-app php artisan config:cache --env={{$env}};
docker-compose exec "$APP_NAME"-app php artisan cache:clear --env={{$env}};
