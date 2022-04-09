#!/bin/sh

PRODUCTION_BRANCH=$1
DEVELOPMENT_BRANCH=$2
PROJECT=$3

# Generation a dump of production database
echo "Dumping a fresh new copy of $PRODUCTION_BRANCH database.."
DB_DUMP_DIR=".docker/mysql/docker-entrypoint-initdb.d/"
sudo chown -R $(id -un):$(id -gn) $DB_DUMP_DIR
DB_DUMP_PATH="${DB_DUMP_DIR}${PWD##*/}.sql"

magento-cloud db:dump -e $PRODUCTION_BRANCH -p $PROJECT -r database --schema=$PROJECT --file=$DB_DUMP_PATH -y \
    --exclude-table='email_abandoned_cart email_automation email_campaign email_catalog email_contact email_contact_consent email_coupon_attribute email_failed_auth email_importer email_order email_review email_rules email_wishlist persistent_session report_compared_product_index report_event report_viewed_product_aggregated_daily report_viewed_product_aggregated_monthly report_viewed_product_aggregated_yearly report_viewed_product_index reporting_counts reporting_module_status reporting_orders reporting_system_updates reporting_users session'
