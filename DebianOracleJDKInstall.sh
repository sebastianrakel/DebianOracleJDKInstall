#!/bin/bash
#######################################################################
# Title      :    DebianOracleJDKInstall.sh
# Author     :    Sebastian R. (sebastian@devunit.eu)
# Date       :    2012-09-30
# Requires   :    wget, tar, gz
# Category   :    Installer
#######################################################################
# Description:
#	Little script for installing Oracle JDK on Debian/Ubuntu Linux
# Note:
#######################################################################

VER='0.0.1 alpha'
APPLICATION_TITLE="Oracle JDK Installer - $VER"

#JDK - Links
JDK_X64_TAR='http://download.oracle.com/otn-pub/java/jdk/7u7-b10/jdk-7u7-linux-x64.tar.gz'
JDK_X86_TAR='http://download.oracle.com/otn-pub/java/jdk/7u7-b10/jdk-7u7-linux-i586.tar.gz'

echo $APPLICATION_TITLE

#check running as root
if [ $EUID -ne 0 ]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

#creating jvm folder if not exist
if [ ! -d /usr/lib/jvm/ ]; then
	echo 'creating jvm directory'
	`mkdir /usr/lib/jvm`
fi

#download jdk
echo 'extracting jdk'
if [ `uname -m` == "x86_64" ]; then
	`wget -N -c --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" $JDK_X64_TAR -O /tmp/tmp_jdk.tar.gz`
else
	`wget -N -c --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F" $JDK_X86_TAR -O /tmp/tmp_jdk.tar.gz`
fi

#extract jdk
`tar xzf /tmp/tmp_jdk.tar.gz -C /usr/lib/jvm`

#get newest jdk folder in jvm
JDK_DIR=$(ls -t /usr/lib/jvm | head -1)

#set java alternative
echo 'setting up jdk'
update-alternatives --install /usr/bin/java java /usr/lib/jvm/$JDK_DIR/bin/java 1065
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/$JDK_DIR/bin/javac 1065

echo 'deleting tmp files'
`rm /tmp/tmp_jdk.tar.gz`

echo 'successfully installed jdk - printing java version now'
`java -version`

exit 0
