#!/bin/bash

detect_os() {
	local OS
	local UNAME_MACHINE
	local UNAME_PROCESSOR
	local UNAME_RELEASE
	local UNAME_SYSTEM
	local UNAME_VERSION

	echo "Gathering information to determine the platform we are working on"
	test_prerequisites

	case "${UNAME_MACHINE}:${UNAME_SYSTEM}:${UNAME_RELEASE}:${UNAME_VERSION}" in
		*:NetBSD:*:*)
			OS=netbsd
			;;
		*:OpenBSD:*:*)
			OS=openbsd
			;;
		*:Darwin:*:*)
			OS=darwin
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
			;;
		*)
			OS=unknown
			;;
	esac
	echo $OS

	if [[ -n $OSTYPE ]]; then
	# $OSTYPE is set
		OSTYPE_SHORT=${OSTYPE//[0-9.]/}
		echo "\$OSTYPE is $OSTYPE_SHORT (${OSTYPE})"
	else
	# $OSTYPE is empty
		echo "\$OSTYPE is empty"
	fi


	echo $'\t'* OS Name: ${UNAME_SYSTEM}
	echo $'\t'* OS Release: ${UNAME_RELEASE}
	echo $'\t'* CPU : ${UNAME_PROCESSOR}
	echo $'\t'* Arch : ${UNAME_MACHINE}
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
