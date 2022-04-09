#!/bin/sh

# Project-specific variables
PRODUCTION_BRANCH=production
DEVELOPMENT_BRANCH=staging
PROJECT=q3t62ey45z636

# Stop on error
set -e

# Let's begin!
printf "Magento Cloud steup wizzard!\n\n"

# Alias to issue new commands inside the container environment easily
alias m2-run='docker run -it --rm -v $PWD:/app -v mg_composer:/root/.composer magento/magento-cloud-docker-php:7.4-cli-1.2.2'

# Grant needed authorization related stuff for that script
mg-installer/scripts/00-setup-authorizations.sh

# Install composer/docker-compose depencies
m2-run bash -c 'mg-installer/scripts/10-install-dependencies.sh'

# Create database dump
mg-installer/scripts/20-dump-database.sh $PRODUCTION_BRANCH $DEVELOPMENT_BRANCH $PROJECT

# Start the containers
echo "Stopping existing Docker containers and starting only the needed ones.."
RUNNING_CONTAINERS=$(docker ps -q); if test -n "$RUNNING_CONTAINERS"; then docker stop $RUNNING_CONTAINERS; fi
docker-compose up -d

# Workaround for crypt key bug https://github.com/magento/ece-tools/issues/644
m2-run bash -c "mg-installer/scripts/30-generate-crypt-key.sh ${PWD##*/}"

# Native/official project setup https://devdocs.magento.com/cloud/docker/docker-mode-developer.html
mg-installer/scripts/40-official-setup.sh

# Native/official project setup https://devdocs.magento.com/cloud/docker/docker-mode-developer.html
mg-installer/scripts/50-post-setup.sh $PROJECT

printf "\n\n\n\n\nDONE! The store is now available trough\n\n http://magento2.docker\n\nurl (a ssl warning can be show, but you can safelly mark the certificate as trustable).\n"
