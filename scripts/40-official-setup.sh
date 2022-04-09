#!/bin/sh

docker-compose run --rm deploy php ./vendor/bin/ece-patches apply
docker-compose run --rm deploy cloud-deploy
docker-compose run --rm deploy magento-command deploy:mode:set developer
docker-compose run --rm deploy cloud-post-deploy
docker-compose run --rm deploy magento-command config:set -n system/full_page_cache/caching_application 2 --lock-env
docker-compose run --rm deploy magento-command setup:config:set -n --http-cache-hosts=varnish
docker-compose run --rm deploy magento-command index:reindex
docker-compose run --rm deploy magento-command cache:clean
