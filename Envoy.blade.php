@include('vendor/autoload.php')

@setup
    $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
    $dotenv->load();

    $releaseRotate = 5;
    $timezone = 'Europe/Moscow';
    $date = new datetime('now', new DateTimeZone($timezone));

    if(!($authUser = $_ENV['DEPLOY_USER'] ?? false)) { throw new Exception('--DEPLOY_USER must be specified'); }
    if(!($authKey = $_ENV['DEPLOY_USER_KEY'] ?? false)) { throw new Exception('--DEPLOY_USER_KEY must be specified'); }
    if(!($authServer = $_ENV['DEPLOY_SERVER'] ?? false)) { throw new Exception('--DEPLOY_SERVER must be specified'); }

    $gitBranch = 'master';
    if(!($gitRepository = $_ENV['DEPLOY_REPOSITORY'] ?? false)) { throw new Exception('--DEPLOY_REPOSITORY must be specified'); }


    if(!($dirBase = $_ENV['DEPLOY_PATH'] ?? false)) { throw new Exception('--DEPLOY_PATH must be specified'); }
    $dirShared = $dirBase . '/shared';
    $dirCurrent = $dirBase . '/current';
    $dirReleases = $dirBase . '/releases';
    $dirCurrentRelease = $dirReleases . '/' . $date->format('YmdHis');
@endsetup

@servers(['production' => '-i ' . $authKey. ' ' . $authUser . '@' . $authServer])

@story('deploy', ['on' => 'production'])
    gitclone
    composer
    npm
    config_project
    set_current
    releases_clean
@endstory

@task('releases_clean')
    purging=$(ls -dt {{$dirReleases}}/* | tail -n +{{$releaseRotate}});

    if [ "$purging" != "" ]; then
        echo "# Purging old releases: $purging;"
        rm -rf $purging;
    else
        echo "# No releases found for purging at this time";
    fi
@endtask

@task('gitclone', ['on' => $on])
    echo "# Gitclone task"

    mkdir -p {{$dirCurrentRelease}}
    git clone --depth 1 -b {{$gitBranch}} {{$gitRepository}} {{$dirCurrentRelease}}

    echo "# Repository has been cloned"
@endtask

@task('composer', ['on' => $on])
    echo "# Composer task"

    cd {{$dirCurrentRelease}}
    composer install --no-interaction --quiet --no-dev --prefer-dist --optimize-autoloader

    echo "# Composer dependencies have been installed"
@endtask

@task('npm', ['on' => $on])
    echo "# Npm task"

    cd {{$dirCurrentRelease}}
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    npm install -only=production
    npm audit fix
    npm run production

    echo "# Npm dependencies have been installed"
@endtask

@task('backup', ['on' => $on])
    echo '# Backup';
    cd {{$dirCurrentRelease}};
    php artisan backup:run
@endtask

@task('config_project', ['on' => $on])
    echo "# Config project task";

    echo "# Linking storage directory";
    rm -rf {{$dirCurrentRelease}}/storage/app;
    cd {{$dirCurrentRelease}};
    ln -nfs {{$dirShared}}/storage/app storage/app;
    php artisan storage:link

    echo "# Linking .env file";
    cd {{$dirCurrentRelease}};
    ln -nfs {{$dirBase}}/.env .env;

    chgrp -R www-data {{$dirShared}};
    chgrp -R www-data {{$dirCurrentRelease}};
    chmod -R ug+rwx {{$dirShared}};
    chmod -R ug+rwx {{$dirCurrentRelease}};

    echo "# Optimising installation";
    php artisan clear-compiled --env={{$env}};
    php artisan optimize --env={{$env}};
    php artisan config:cache --env={{$env}};
    php artisan cache:clear --env={{$env}};
@endtask

@task('down', ['on' => $on])
    echo "# Down task"
    cd {{$dirCurrentRelease}};
    php artisan down;
@endtask

@task('migrate', ['on' => $on])
    echo "# Running migrations";
    cd {{$dirCurrentRelease}};
    php artisan migrate --env=production --force;
@endtask

@task('up', ['on' => $on])
    echo "# Up task"
    cd {{$dirCurrentRelease}};
    php artisan up;
@endtask

@task('set_current', ['on' => $on])
    echo '# Linking current release';
    ln -nfs {{$dirCurrentRelease}} {{$dirCurrent}};
@endtask

