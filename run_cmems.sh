#! /bin/bash

set -e
RED='\033[0;31m'
NC='\033[0m'

function build_cmems_esb {
  printf "${RED}Preparing Mule ESB instance${NC}\n"
  git clone -b develop https://teamEreticoTfs:vAsK*AIJFB@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_ESB tmp
  cd tmp/ESB/docker
  sh build.sh develop
  cd ../../..
  rm -rf tmp
}

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
    mv datavolume ../shared_data/postgres
  fi
}

function build_cmems_gui {
  printf "${RED}Building cmem_gui${NC}\n"
  git clone -b develop https://teamEreticoTfs:vAsK*AIJFB@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_Web_App tmp
  cd tmp/cmems-gui/docker
  sh deploy.sh develop
  cd ../../..
  rm -rf tmp
}

build_cmems_processors
build_cmems_gui
build_cmems_geoserver
build_cmems_geonetwork
build_cmems_esb
docker-compose down
printf "${RED}Running compose${NC}\n"
docker-compose up -d postgres
printf "${RED}Going to sleep${NC}\n"
sleep 10
docker-compose up -d
