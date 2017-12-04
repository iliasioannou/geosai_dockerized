# EOSAI ecosystem orchestrator

EOSAI project has been developed as a set of containers.

You could run them all manually (be sure images have been previously built).

Or just type:
    
    ./run_eosai.sh

## Geoserver setup

To replicate the infrastructure, you need to get Geoserver ready placing its own data in the mounted folder.
So basically:
   
   - start geoserver with a mounted folder empty
   - export geoserver data dir
   - stop geoserver
   - place the exported folder in the geoserver data dir
   - export output data from C5_Output_dir directory and place in *shared_data* folder
   - restart geoserver
   - change whatever you need using geoserver web interface

## Proxy

User exposed service have been proxied via configured Nginx instance. 
Please check the *nginx.conf* file to check how reverse proxy works and what routes have been covered.

## Network

For every connection between geonetwork and postgres it's needed to create always a Docker network.

