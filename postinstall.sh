#!/bin/bash
################################################################################
#Set Colour Schemes
RED='\033[0;31m' # RED
YLLO='\033[1;33m' # Light Yellow
LCYAN='\033[1;36m' # Light Cyan
LGRN='\033[1;32m' # Light Green
NC='\033[0m' # No Color
#Windows uses \r\n as the line terminator while Linux (and most other operating systems) use \n alone. When you edit a file in Windows, Windows will add \r to the end of the lines and that will break your scripts.
#sed -i 's/\r//g' postinstall.sh
#Variables
installpkg='ansible git curl'
temppath='/tmp/ansi-rpi'
ansirepo="/etc/apt/sources.list.d/"
#Generate Log File
#Create Temporary storage directory
# rm -rf $temppath
mkdir -p $temppath
logfile="$temppath/$RANDOM.log"
cd $temppath
################################################################################
cat <<"EOF"
                           (   (        ) (
                           )\ ))\ )  ( /( )\ )
                          (()/(()/(  )\()|()/(
                           /(_))(_))((_)\ /(_))
                          (_))(_))_|_ ((_|_))_
                          / __||   \ |/ / |   \
                          \__ \| |) || <  | |) |
                          |___/|___/_|\_\ |___/
################################################################################
Author: Saideep Kavidi
Github: https://github.com/sdkd-git/
License: MIT License
#
#This script can be used for installation of provided apps and services.
Uncomment the packages you want to install from ansible/main.yml.
Make Sure you have customized Anisble-Playbook as per your requirement before
you begin the installation.
################################################################################
EOF
################################################################################
# Command exits with a nonzero exit value
# set -e
# Check is user is running with permission
# if ! [ $(id -u) = 0 ];
#   then echo -e "\n${YLLO}The script need to be run as root.${NC}" >&2
#   exit 1
# fi
echo -e "\n$(date)\n$(uname -nir)\n" >> $logfile
# ################################################################################
# Script for auto update/autoremove and dist-upgrade.
 apt-get update >> $logfile
# if [ $? = 0 ]; then
#   echo -e "${LGRN}Repository update Completed\n"
# else
#   echo -e "${RED}Repository Update failed\nExiting Installtion..!\n${NC}"
#   exit 4
# fi
# # Ubuntu upgrade
apt-get dist-upgrade -y >> $logfile
# if [[ $? = 0 ]]; then
#   echo -e "Upgrade completed\n"
# else
#   echo -e "${RED}Upgrade failed${NC}"
#   exit 5
# fi
# # Ubuntu Auto Package removal
apt-get autoremove -y >> $logfile
# if [[ $? = 0 ]]; then
#   echo -e "Autoremove completed\n"
# else
#   echo -e "${RED}Autoremove failed${NC}"
#   exit 11
# fi
# ################################################################################
apt-get update >> $logfile
# # Install Packages
apt-get install $installpkg -y >> $logfile
# if ! [ $? = 0 ];
#   then
#     echo -e "\n${LGRN} Installation failed for following packages $installpkg ${NC}\n" >&2
#     echo -e "${RED} Stopping further actions..!${NC}\n Please check logs for more details." >&2
#     exit 6
# fi
# # Check Dependency Packages/Force install/Autoremove
echo -e "${YLLO}Checking and reinstalling for dependency packages${NC}\n"
apt-get install -f -y >> $logfile
apt-get autoremove -y >> $logfile
# ################################################################################
# #git Clone
pwd
git clone https://github.com/sdkd-git/ansi-rpi
# ################################################################################
# echo -e "${LGRN}Starting Ansible Playbook.${NC}\n"
ansible-playbook ansi-rpi/ansible-playbook/main.yml -v >> $logfile
# exitstate='$?'
# # Cleaning TemporaryFiles
echo -e "${YLLO}Cleaning Apt Cache${NC}"
apt-get -q clean
echo -e "${LGRN}APT Cache cleaned\n"
# # Exit Message
# if [[ $exitstat = 0 ]]; then
#   echo -e "${LCYAN}Reboot system for applying changes.\n"
#   echo -e "${YLLO}Thanks for using the script...!\n"
# else
#   echo -e "${RED}Error Occured while installation.\n"
# fi
# #