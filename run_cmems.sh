#! /bin/bash

set -e
RED='\033[0;31m'
NC='\033[0m'

function build_cmems_geoserver {
  printf "${RED}Preparing geoserver instance${NC}\n"
  git clone -b develop https://teamEreticoTfs:vAsK*AIJFB@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_MapServices tmp
  cd tmp
  
  if [ ! -d "../shared_data/geoserver" ]; then
    mkdir ../shared_data/geoserver
    mv *  ../shared_data/geoserver
  fi

  cd ..
  rm -rf tmp
}

function build_cmems_processors {
  printf "${RED}Building cmems_processors${NC}\n"
  git clone -b develop https://teamEreticoTfs:vAsK*AIJFB@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_Processori tmp
  cd tmp/Processors/docker
  sh build.sh develop
  cd ../../..
  rm -rf tmp
}

function build_cmems_geonetwork {
  printf "${RED}Preparing geonetwork${NC}\n"
  git clone -b develop https://teamEreticoTfs:vAsK*AIJFB@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_connettore_catalogo tmp
  cd tmp
  
  if [ ! -d "../shared_data/postgres/datavolume" ]; then
    mv datavolume ../shared_data/postgres/datavolume
  fi

  if [ ! -d "../shared_data/postgres/data" ]; then
    mkdir ../shared_data/postgres/data
  fi

  cd ..
  rm -rf tmp
}


build_cmems_processors
build_cmems_geoserver
build_cmems_geonetwork
docker-compose down
printf "${RED}Running compose${NC}\n"
docker-compose up -d postgres
printf "${RED}Going to sleep${NC}\n"
sleep 10
docker-compose up -d
