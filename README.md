# example-laravel-envoy

[![GitHub tag (latest SemVer)][ico-github-tag-version]][link-github-tag-version]
[![Packagist][ico-license]][link-license]
[![GitHub code size in bytes][ico-github-size]][link-github]
[![GitHub top language][ico-github-top-language]][link-github]

## Introduction

Deploy Laravel app with Envoy.

Read more: https://rdevelab.ru/blog/no-category/post/laravel-app-deploy-with-envoy.

## Requirements

- Nginx 1.14.0
- MySQL 5.7.30
- Node 10.16.0
- PHP >= 7.2.5
  - BCMath PHP Extension
  - Ctype PHP Extension
  - Fileinfo PHP extension
  - JSON PHP Extension
  - Mbstring PHP Extension
  - OpenSSL PHP Extension
  - PDO PHP Extension
  - Tokenizer PHP Extension
  - XML PHP Extension
  
## Installation

### Common

#### Git clone
```bash
git clone git@github.com:superrosko/example-laravel-envoy.git .
```

#### Install composer and npm
```bash
composer install
npm install
npm run dev
```

#### Configure laravel env
```bash
php -r "file_exists('.env') || copy('.env.example', '.env');"
php artisan key:generate --ansi
```

Set your host configuration in .env.

#### Linking storage directory
```bash
php artisan storage:link
```

#### DB migration and seeding
```bash
php artisan migrate
php artisan db:seed
```

#### Optimising installation
```bash
php artisan clear-compiled --env=dev
php artisan optimize --env=dev
php artisan config:cache --env=dev
php artisan cache:clear --env=dev
```

### Docker

#### Git clone
```bash
git clone git@github.com:superrosko/example-laravel-envoy.git .
```

#### Run initialization
```bash
make initial
```

## Usage

### Docker

Restart docker compose:
```bash
make compose_restart
```
Generating ssl certificates:
```bash
make ssl_gen
```
Install dependencies:
```bash
make deps_install
```
Update dependencies:
```bash
make deps_update
```
App configuration:
```bash
make app_config
```
Create new database user if not exists:
```bash
make db_create_user
```
Execute mysql cli:
```bash
make db_exec
```
Apply migrations:
```bash
make db_migration
```
Refresh migrations and seeds:
```bash
make db_migration_reset
```
App php exec: 
```bash
make php_exec COMMAND="artisan"
```
App initialization: 
```bash
make initial
```
Deploy app:
```bash
make deploy
```

## Credits

- [Dmitriy Bespalov][link-author]
- [All Contributors][link-contributors]

## License

The MIT License (MIT). Please see [License File][link-license] for more information.


[link-author]: https://github.com/superrosko
[link-contributors]: https://github.com/superrosko/example-laravel-envoy/contributors
[link-github]: https://github.com/superrosko/example-laravel-envoy
[link-github-tag-version]: https://github.com/superrosko/example-laravel-envoy
[link-license]: LICENSE

[ico-github-size]: https://img.shields.io/github/languages/code-size/superrosko/example-laravel-envoy.svg?style=flat
[ico-github-top-language]: https://img.shields.io/github/languages/top/superrosko/example-laravel-envoy.svg?style=flat
[ico-github-tag-version]: https://img.shields.io/github/v/tag/superrosko/example-laravel-envoy.svg?style=flat
[ico-license]: https://img.shields.io/github/license/superrosko/example-laravel-envoy.svg?style=flat
