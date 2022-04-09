#!/bin/sh
PROJECT=$1

# General hacks (VERY optnated)
## Make frontend session last all day
docker-compose run --rm deploy magento-command config:set -n web/cookie/cookie_lifetime 86400 --lock-env
## Make admin session last all day
docker-compose run --rm deploy magento-command config:set -n admin/security/session_lifetime 86400 --lock-env
## Disable newrelic
docker-compose run --rm deploy magento-command config:set -n newrelicreporting/general/enable 0 --lock-env
## Update admin grid on demand
docker-compose run --rm deploy magento-command config:set -n dev/grid/async_indexing 0 --lock-env

# Fix filesystem permissions changed by docker processes
echo '\nEnsuring correct permissions for your files..'
sudo chown -R $(id -un):$(id -gn) ./

# Download non-catalog media
echo "Downloading non-catalog media.."
magento-cloud mount:download -p $PROJECT --mount pub/media --target pub/media \
    --exclude cache --exclude catalog --exclude tmp -y

# Make http://magento2.docker accessible from browser
if ! grep -q magento2.docker /etc/hosts; then
    echo "Making the URL available.."
    echo "127.0.0.1 magento2.docker" | sudo tee -a /etc/hosts
fi
