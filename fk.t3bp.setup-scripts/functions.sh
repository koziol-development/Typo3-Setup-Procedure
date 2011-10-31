#!/bin/bash

detect_os() {
	local OS
	local UNAME_MACHINE
	local UNAME_PROCESSOR
	local UNAME_RELEASE
	local UNAME_SYSTEM
	local UNAME_VERSION

	MESSAGE="Gathering information to determine the platform we are working on"
	echo_underline "Gathering information to determine the platform we are working on" 2

	test_prerequisites

	if [[ -n $OSTYPE ]]; then
	# $OSTYPE is set
		OSTYPE_SHORT=${OSTYPE//[0-9.]/}
	else
	# $OSTYPE is empty
		OSTYPE_SHORT=unknown
	fi
	echo "* \$OSTYPE is $OSTYPE_SHORT (${OSTYPE})"


	echo "* OS Name: ${UNAME_SYSTEM}	"
	echo "* OS Release: ${UNAME_RELEASE}"
	echo "* CPU : ${UNAME_PROCESSOR}	"
	echo "* Arch : ${UNAME_MACHINE}		"

	case "${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}" in
		*:Darwin:*:*)
			OS=darwin
			local OS_VERSION=($(sw_vers -productVersion)) || OS_VERSION=unknown
			
			case $OS_VERSION in
				10.7.*)
					OS_VERSION_NAME=lion
					;;
				10.6.*)
					OS_VERSION_NAME=snow-leopard
					;;
				10.5.*)
					OS_VERSION_NAME=leopard
					;;
				10.4.*)
					OS_VERSION_NAME=tiger
					;;
				10.3.*)
					OS_VERSION_NAME=panther
					;;
				10.2.*)
					OS_VERSION_NAME=jaguar
					;;
				10.1.*)
					OS_VERSION_NAME=puma
					;;
				10.0.*)
					OS_VERSION_NAME=cheetah
					;;
				*) 
					OS_VERSION_NAME=unknown
					;;
			esac

			case $UNAME_PROCESSOR in
				i386)
					sleep 0
					;;
				unknown)
					UNAME_PROCESSOR=powerpc
					;;
			esac

			if [[ -x /opt/local/bin/port ]]; then
				PACKAGE_SEARCH="port installed | grep -i"
				echo "* Found Package Manager in: /opt/local/bin/port"
			else 
				echo
				echo "*** NO SUITABLE PACKAGE MANAGER FOUND !"
				echo "We recommend to install MacPorts to install missing binaries."
				exit;
			fi

			OS=${OS}-${OS_VERSION_NAME}
			;;
		i*86:Linux:*:*)
			OS=gnu-linux
			OS_DIST=$( echo $UNAME_VERSION | tr '[A-Z]' '[a-z]' )
			case $OS_DIST in
				*ubuntu*)
					OS=linux
					OS_TYPE=debian
					OS_DIST=ubuntu
					PACKAGE_SEARCH='dkpg -i | grep -i'
					;;
				*)
					OS_TYPE=unknown
					OS_DIST=unknown
					;;	
			esac
			OS=${OS_DIST}-${OS}
			;;
		*:Linux:*:*)
			OS=some-linux
			;;
		*:NetBSD:*:*)
			OS=netbsd
			;;
		*:OpenBSD:*:*)
			OS=openbsd
			;;
		*)
			OS=unknown
			;;
	esac
	
	echo
	echo "Determined OS string: $OS"
}

test_prerequisites() {
	# Test if uname is available
	UNAME_VERSION=$(uname -v 2>&-) || UNAME_VERSION=unknown
	if [ $? -eq 0 ]; then
		echo "* 'uname' command found. 'uname -v' gave the following result:"
		echo $'\t'$UNAME_VERSION
	else 
		echo
		echo '** ERROR ***'
		echo 'uname' was not found or 'uname -v' returned a non-zero exit code!
		exit 1
	fi
	
	uname_checks
}

uname_checks() {
	echo "* Gathering information with 'uname'..."

	UNAME_MACHINE=$(uname -m) || UNAME_MACHINE=unknown
	UNAME_PROCESSOR=$(uname -p) || UNAME_PROCESSOR=unknown
	UNAME_RELEASE=$(uname -r) || UNAME_RELEASE=unknown
	UNAME_SYSTEM=$(uname -s) || UNAME_SYSTEM=unknown
}

test_single_binary() {
	BINARY=$0
	PATH=$1
	test -x $1/$0
	return $?
}
echo_underline() {
	local MESSAGE=$1
	local LINE_NUM=$2 || local LINE_NUM=0

	local -a LINES
	LINE[0]="######################################################################################################"
	LINE[1]="======================================================================================================"
	LINE[2]="------------------------------------------------------------------------------------------------------"
	LINE[3]="______________________________________________________________________________________________________"
	
	echo $MESSAGE
	echo ${LINE[$LINE_NUM]:0:${#MESSAGE}}

}
