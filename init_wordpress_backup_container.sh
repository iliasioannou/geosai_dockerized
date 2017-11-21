#! /bin/bash

docker run \
  --net eosai \
  --name eosai_wordpress_backup \
  -v `pwd`/shared_data/backups:/backups \
  --volumes-from=eosai_wordpress \
  --link=eosai_wordpress_mysql:mysql \
  -d aveltens/wordpress-backup
