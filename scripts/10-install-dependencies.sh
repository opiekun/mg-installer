#!/bin/sh

printf "Making composer faster..\n"
composer g req --ignore-platform-reqs hirak/prestissimo

echo "Installing composer dependencies..\n"
composer install
git checkout .gitignore

echo "Bootstraping Docker environment.."
./vendor/bin/ece-docker build:compose --mode="developer" --sync-engine="native" --expose-db-port=3306 --with-entrypoint --with-xdebug --set-docker-host

