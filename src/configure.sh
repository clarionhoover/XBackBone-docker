#!/bin/sh

sed -i "s@http:\/\/localhost@$URL@g" /app/config.php

if [ -z ${DB+x} ]; then
  DB="sqlite"
fi

if [[ $DB == "mysql" ]]; then
  # Sed here to replace the connection string information
  # replace "resources/database/xbackbone.db with "host=$MYSQL_HOST;port=$MYSQL_PORT;dbname=$MYSQL_DB"
  # replace 'username' => null, with 'username' => '$MYSQL_USERNAME',
  # replace 'pasword' => null, with 'password' => '$MYSQL_PASSWORD',

  sed -i "s/resources\/database\/xbackbone.db/host=$MYSQL_HOST;port=$MYSQL_PORT;dbname=$MYSQL_DB/g" /app/config.php
  sed -i "s/'username' => null,/'username' => '$MYSQL_USERNAME',/g" /app/config.php
  sed -i "s/'pasword' => null,/'password' => '$MYSQL_PASSWORD',/g" /app/config.php
fi

if [ ! -f /app/resources/database/mysql ] || [ ! -f /app/resources/database/xbackbone.db ]; then
  cd /app
  su -c "php bin/migrate --install" application
  if [[ $DB == "mysql" ]]; then
    touch /app/resources/database/mysql
  fi
fi
