#!/bin/bash
# -------
# Script for install of Postgresql to be used with Alfresco
# 
# Copyright 2013 Loftux AB, Peter Löfgren
# Distributed under the Creative Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0)
# -------

export ALFRESCODB=alfrescodb
export ALFRESCOUSER=alfrescouser
export EBYSDB=ebysdb
export EBYSUSER=ebysuser


echo
echo "--------------------------------------------"
echo "This script will install PostgreSQL."
echo "and create alfresco database and user."
echo "You may be prompted for sudo password."
echo "--------------------------------------------"
echo

read -e -p "Install PostgreSQL database? [y/n] " -i "n" installpg
if [ "$installpg" = "y" ]; then
  sudo apt-get install postgresql postgresql-contrib
  echo
  echo "You will now set the default password for the postgres user."
  echo "This will open a psql terminal, enter:"
  echo
  echo "\\password postgres"
  echo
  echo "and follow instructions for setting postgres admin password."
  echo "Press Ctrl+D or type \\q to quit psql terminal"
  echo "START psql --------"
  sudo -u postgres psql postgres
  echo "END psql --------"
  echo
fi

read -e -p "Create Alfresco Database and user? [y/n] " -i "n" createdb
if [ "$createdb" = "y" ]; then
  sudo -u postgres createuser -D -A -P $ALFRESCOUSER
  sudo -u postgres createdb -O $ALFRESCOUSER $ALFRESCODB
  echo
  echo "Remember to update alfresco-global.properties with the alfresco database password"
  echo
fi

read -e -p "Create EBYS Database and user? [y/n] " -i "n" createdb2
if [ "$createdb2" = "y" ]; then
  sudo -u postgres createuser -D -A -P $EBYSUSER
  sudo -u postgres createdb -O $EBYSUSER $EBYSDB
  echo
  echo "Remember to update ebys-data.xml with the alfresco database password"
  echo
fi

echo
echo "You must update postgresql configuration to allow password based authentication"
echo "(if you have not already done this)."
echo
echo "Add the following to pg_hba.conf"
echo "located in folder /etc/postgresql/<version>/main/"
echo
echo "host all all 127.0.0.1/32 password"
echo "host all all samenet 		password"
echo
echo "Change this line in postgresql.conf listen_addresses='localhost' to listen_addresses='*'"
echo
echo "After you have updated, restart the postgres server /etc/init.d/postgresql restart"
echo
