#!/bin/bash

# Inspired by:
# http://www.ajado.com/blog/how-to-set-permissions-for-typo3-on-the-webserver/
# http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob;f=config.guess;hb=HEAD

clear

# Set variables
WORKING_DIR="${PWD}/"
SCRIPT_DIR=$(dirname $0)/
SOURCES_DIR=~/Software/Development/CMS/Typo3/
T3SOURCE_DIR="${SOURCES_DIR}typo3_src"

WEBSERVER_USER=_www
WEBSERVER_GROUP=_www

FILESYSTEM_USER=falcongoat
FILESYSTEM_GROUP=staff

. ${SCRIPT_DIR}functions.sh

if [ $(id -u) = 0 ]; then
	echo "We are ROOT"
else
	echo "You need to run this script as ROOT. Try 'sudo' or something similar."
	echo "Exiting..."
	echo
	exit
fi

echo
echo "---------------------"
echo "Typo3 Setup Procedure"
echo "====================="
echo "IMPORTANT:"
echo "This script checks in no way, whether Apache or MySQL are installed. This is taken as a given, since we try to set up Typo3 here."
echo "In the current version the script is assuming that it is called from the root directory (webroot) of the future Typo3 installation."
echo

detect_os

test_sources $SOURCES_DIR

exit

# Copy the dummy-package's contents to the working directory
cp -r ${SOURCES_DIR}dummy-4.6.0/ ${WORKING_DIR}.

# Create a symlink in the webroot, which points to the TYPO3 sources in the t3_src directory
ln -s -f ${T3SOURCE_DIR} ${WORKING_DIR}typo3_src

# Make files writable for owners and groups
chmod -R 775 $WORKING_DIR

# Set the owner of all files in the webroot to "ajado", which is the FTP user as well.
# This way we can edit all files over ftp, but the TYPO3 system files (which are sym-linked)
# In case some attacker takes over this FTP user, he/she will only be able to affect files in the "ajado" webroot, not on other webroots
chown -R ${FILESYSTEM_USER}:${FILESYSTEM_GROUP} $WORKING_DIR

# Reset the group of the directories which have to be writeable through TYPO3, which uses the www-data user
chgrp -R ${WEBSERVER_GROUP} ${WORKING_DIR}typo3temp/
chgrp -R ${WEBSERVER_GROUP} ${WORKING_DIR}typo3temp/
chgrp -R ${WEBSERVER_GROUP} ${WORKING_DIR}uploads/
chgrp -R ${WEBSERVER_GROUP} ${WORKING_DIR}fileadmin/
chgrp -R ${WEBSERVER_GROUP} ${WORKING_DIR}typo3conf/

# Create an ENABLE_INSTALL_TOOL file, so you can start configuring TYPO3 via install tool right away
touch ${WORKING_DIR}typo3conf/ENABLE_INSTALL_TOOL

