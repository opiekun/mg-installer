#!/bin/sh

CRYPT_KEY=$(echo $1 | md5sum | awk '{ print $1 }')
rm app/etc/env.php
/app/mg-installer/bin/n98-magerun2.phar co:en:create -n
sed -i "s/\"key\" => \"\"/\"key\" => \"$CRYPT_KEY\"/g" app/etc/env.php
sed -i "s/'key' => ''/'key' => '$CRYPT_KEY'/g" app/etc/env.php
