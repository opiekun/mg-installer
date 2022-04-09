#!/bin/sh

# Grant sudo access for later
echo "Granting sudo privileges for later operations now so you can take a coffee while the script run ;)"
sudo echo "Granted!"

# Auto set composer username/password from cloud
echo "Setuping composer auth with cloud credentials.."
COMPOSER_AUTH=$(magento-cloud variable:get --level project --property value env:COMPOSER_AUTH)
docker run -it --rm -v $PWD:/app -v mg_composer:/root/.composer magento/magento-cloud-docker-php:7.4-cli-1.2.2 \
    bash -c "echo '$COMPOSER_AUTH' > /root/.composer/auth.json"
