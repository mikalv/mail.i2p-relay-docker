#!/bin/bash

[ "${DEBUG}" == "yes" ] && set -x

function add_config_value() {
  local key=${1}
  local value=${2}
  local config_file=${3:-/etc/postfix/main.cf}
  [ "${key}" == "" ] && echo "ERROR: No key set !!" && exit 1
  [ "${value}" == "" ] && echo "ERROR: No value set !!" && exit 1

  echo "Setting configuration option ${key} with value: ${value}"
  sed -i -e "/^#\?\(\s*${key}\s*=\s*\).*/{s//\1${value}/;:a;n;:ba;q}" \
         -e "\$a${key}=${value}" \
         ${config_file}
}

SMTP_PORT="${SMTP_PORT-587}"
DOMAIN=`echo ${SERVER_HOSTNAME} |awk -F. '{$1="";OFS="." ; print $0}' | sed 's/^.//'`

# Set needed config options
add_config_value "myhostname" ${SERVER_HOSTNAME}
add_config_value "mydomain" ${DOMAIN}
add_config_value "mydestination" '$myhostname'
add_config_value "myorigin" '$mydomain'
add_config_value "relayhost" "[${SMTP_SERVER}]:${SMTP_PORT}"
add_config_value "smtp_use_tls" "yes"

supervisord
