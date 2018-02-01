#! /bin/bash

set -e

RED='\033[0;31m'
NC='\033[0m'

function clean {
  printf "${RED}Removing old tmp folder${NC}\n"
  rm -rf tmp  
}


function build_eosai_esb {
  printf "${RED}Preparing Mule ESB instance${NC}\n"
  if [ ! -d "shared_data/download" ]; then
    mkdir shared_data/download
  fi
  docker pull dockerhub.planetek.it/pkh111_eosai_esb:master
}

function build_eosai_geoserver {
  printf "${RED}Preparing geoserver instance${NC}\n"
  git clone -b master https://TeamEreticoTfs:hIEMK-i=d@tfs.planetek.it/Planetek%20Hellas/pkh111_EOSAI/_git/pkh111_EOSAI_MapServices tmp
  mkdir config
  cp tmp/config/users.xml config
  cd tmp
  if [ ! -d "../shared_data/geoserver" ]; then
    mkdir ../shared_data/geoserver
    mv *  ../shared_data/geoserver
  fi

  cd ..
  rm -rf tmp
  cp config/users.xml shared_data/geoserver/geoserver_data_dir/security/usergroup/default/users.xml
  rm -rf config
}

function build_eosai_processors {
  printf "${RED}Building eosai_processors${NC}\n"
  docker pull dockerhub.planetek.it/pkh111_eosai_processors:master
  // git clone -b master https://tfs.planetek.it/Planetek%20Hellas/pkh111_EOSAI/_git/pkh111_EOSAI_Processori tmp
  // cd tmp
  // cd /Processors/docker
  // sh ./build.sh master
  // cd ../../..
  // rm -rf tmp
}


function build_eosai_geonetwork {
  printf "${RED}Preparing geonetwork${NC}\n"
  git clone -b master https://TeamEreticoTfs:hIEMK-i=d@tfs.planetek.it/Planetek%20Hellas/pkh111_EOSAI/_git/pkh111_EOSAI_connettore_catalogo tmp
  cd tmp
  if [ ! -d "../shared_data/postgres/datavolume" ]; then
    mv datavolume ../shared_data/postgres
  fi
  cd ..
  rm -rf tmp
}

function build_eosai_gui {
  printf "${RED}Building eosai_gui${NC}\n"
  git clone -b master https://TeamEreticoTfs:hIEMK-i=d@tfs.planetek.it/Planetek%20Hellas/pkh111_EOSAI/_git/pkh111_EOSAI_Web_App tmp
  cd tmp/eosai-gui/docker
  sh deploy.sh master
  cd ../../..
  rm -rf tmp
}

function build_eosai_activiti {
  printf "${RED}Building eosai_activiti${NC}\n"
  git clone -b master https://TeamEreticoTfs:hIEMK-i=d@tfs.planetek.it/Planetek%20Hellas/pkh111_EOSAI/_git/pkh111_EOSAI_WFE  tmp
  cd tmp/docker
  sh build.sh master
  cd ../..
  rm -rf tmp
}

function build_eosai_manager {
  printf "${RED}Building eosai_manager${NC}\n"
  docker pull dockerhub.planetek.it/pkh111_eosai_manager_od:master
}

function build_eosai_api {
  printf "${RED}Building eosai_api${NC}\n"
  docker pull dockerhub.planetek.it/pkh111_eosai_api:master
}

function build_proxy {
  printf "${RED}Building eosai_proxy${NC}\n"
  cd proxy
  docker build -t planetek/eosai_proxy:base .
  cd ..
}

clean
#build_eosai_processors
#build_eosai_gui
#build_eosai_geoserver
#build_eosai_geonetwork
#build_eosai_esb
#build_eosai_activiti
#build_eosai_manager
#build_eosai_api
#build_proxy
docker-compose up -d postgres mysql_activiti mysql_manager
printf "${RED}Going to sleep${NC}\n"
sleep 10
docker exec -it eosai_postgres psql -U postgres geonetwork -a -f opt/data-volume/db.sql
docker-compose up -d 
sleep 10
docker exec eosai_activiti bash -c '/src/load.sh'
sleep 10
docker exec -it eosai_geoserver /mnt/copy_wps_jars.sh
