#!/bin/bash

PWD=`/bin/pwd`

# Import common functions.
import_common() {
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    source ${DIR}/deploy_functions.sh   
}


read_dbname() {
    WPDBNAME=`cat wp-config.php | grep DB_NAME | cut -d \' -f 4`
}


declare_output_filename() {

    if [[ ! -z "${WPDBNAME}" ]]; 
    then
        TARFILE=${PWD}/${WPDBNAME}-`date '+%m%d%y'`.tar.gz
    else
        TARFILE=${PWD}/wordpress-`date '+%m%d%y'`.tar.gz
    fi

    cli_text "${CYAN}Output01: ${TARFILE}${NC}"
}


declare_sources() {
    SOURCE1=${PWD}/wp-content
    SOURCE2=${PWD}/wp-config.php
    SOURCE3=${PWD}/*.sql.gz

    cli_text "Source01: ${SOURCE1}"
    cli_text "Source02: ${SOURCE2}"
    cli_text "Source03: ${SOURCE3}"
}


compress_site(){
    /usr/bin/tar -cvzf ${TARFILE} ${SOURCE1} ${SOURCE2} ${SOURCE3} & spinner
    cli_text "${GREEN}Tar Gzipped Done.${NC}"
}



import_common
cli_header "Wordpress WP-Content Dump"
read_dbname
declare_sources
declare_output_filename
compress_site