# CMEMS ecosystem orchestrator

CMEMS project has been developed as a set of containers.

You could run them all manually (be sure images have been previously built).

Or just type:
    
    ./run_cmems.sh

To speed the build process up, you could comment out some build functions.

## About wordpress backup

Wordpress site has been exposed to 80.
Please notice that an automated backup has been scheduled every morning at 2am. 
Saved backups will be placed into *./shared_data/backups* .

In order to restore a previous backup (which will involve restoring both db and site):

    docker exec cmems_wordpress_backup restore <date>

where

    <date>: The timestamp of the backup to restore, in the format yyyyMMdd.

## About proxy

User exposed service have been proxied via configured Nginx instance. 
Please check the *nginx.conf* file to check how reverse proxy works and what routes have been covered.

## About network

For every connection between geonetwork and postgres it's needed to create always a Docker network.

