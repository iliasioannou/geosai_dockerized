#! /bin/bash

set -e

RED='\033[0;31m'
NC='\033[0m'

function clean {
  printf "${RED}Removing old tmp folder${NC}\n"
  rm -rf tmp  
}


function build_cmems_esb {
  printf "${RED}Preparing Mule ESB instance${NC}\n"
  if [ ! -d "shared_data/download" ]; then
    mkdir shared_data/download
  fi
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_ESB tmp
  cd tmp/ESB/docker
  sh build.sh develop
  cd ../../..
  rm -rf tmp
}

function build_cmems_geoserver {
  printf "${RED}Preparing geoserver instance${NC}\n"
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_MapServices tmp
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
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_Processori tmp
  cd tmp/Processors/docker
  sh build.sh develop
  cd ../../..
  rm -rf tmp
}


function build_cmems_geonetwork {
  printf "${RED}Preparing geonetwork${NC}\n"
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_connettore_catalogo tmp
  cd tmp
  if [ ! -d "../shared_data/postgres/datavolume" ]; then
    mv datavolume ../shared_data/postgres
  fi
  cd ..
  rm -rf tmp
}

function build_cmems_gui {
  printf "${RED}Building cmem_gui${NC}\n"
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_Web_App tmp
  cd tmp/cmems-gui/docker
  sh deploy.sh develop
  cd ../../..
  rm -rf tmp
}

function build_cmems_activiti {
  printf "${RED}Building cmems_activiti${NC}\n"
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_WFE  tmp
  cd tmp/docker
  sh build.sh develop 
  cd ../..
  rm -rf tmp
}

function build_cmems_manager {
  printf "${RED}Building cmems_manager${NC}\n"
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_Manager_OD_Request  tmp
  cd tmp/docker
  sh build.sh develop 
  cd ../..
  rm -rf tmp
}

function build_cmems_api {
  printf "${RED}Building cmems_api${NC}\n"
  git clone -b develop https://teamEreticoTfs:hIEMK-i=d@tfs.planetek.it/SBU-GS/pkz029_UU_CMEMS/_git/pkz029_UU_CMEMS_Api_Rest  tmp
  cd tmp/cmems-api/docker
  sh deploy.sh develop 
  cd ../..
  rm -rf tmp
}

function build_proxy {
  printf "${RED}Building cmems_proxy${NC}\n"
  cd proxy
  docker build -t planetek/cmems_proxy:base .
  cd ..
}

clean
build_cmems_processors
build_cmems_gui
build_cmems_geoserver
build_cmems_geonetwork
build_cmems_esb
build_cmems_activiti
build_cmems_manager
build_cmems_api
build_proxy
docker-compose down
printf "${RED}Running compose${NC}\n"
docker-compose up -d postgres mysql_activiti mysql_manager mysql
printf "${RED}Going to sleep${NC}\n"
sleep 10
docker-compose up -d
sleep 10
docker exec cmems_activiti bash -c '/src/load.sh'
docker exec -t -i cmems_geoserver bash -c "sed -i -- 's/port=\"8080\"/port=\"9090\"/g' /usr/local/tomcat/conf/server.xml"
docker exec -t -i cmems_activiti  bash -c "sed -i -- 's/port=\"8080\"/port=\"9085\"/g' /opt/tomcat/conf/server.xml"
docker-compose restart geoserver geonetwork activiti
