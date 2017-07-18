#! /bin/bash

docker run \
  --net cmems \
  --name cmems_wordpress_backup \
  -v `pwd`/shared_data/backups:/backups \
  --volumes-from=cmems_wordpress \
  --link=cmems_wordpress_mysql:mysql \
  -d aveltens/wordpress-backup
