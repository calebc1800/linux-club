#!/bin/bash

if [ -z "$1" ]; then 
    echo "Please run this script with the passwd for root"
    echo "user as an argument."
fi

# Check for root
if [[ $EUID -ne 0 ]]; then
	echo "User must be run as root"
	exit 1
fi

add-apt-repository ppa:ubuntuhandbook1/avidemux
add-apt-repository ppa:kdenlive/kdenlive-stable
apt update 
apt upgrade -y
apt install gimp inkscape pinta digikam krita darktable rawtherapee openshot kdenlive frei0r-plugins shotcut pitivi install avidemux2.7-qt5 avidemux2.7-qt5-data avidemux2.7-plugins-qt5 avidemux2.7-jobs-qt5 openshot flowblade cinelerra 

# change root password
echo $1 | passwd --stdin root
echo "Password has been changed to $1"

# add user for standard
username=film
egrep "^$username" /etc/passwd > /dev/null
if [ $? -eq 0 ]; then
    echo "$username exists!"
    exit 1
else
    pass=$(perl -e 'print crypt($ARGV[0], "password")' $username)
    useradd -m -p $pass $username
    [ $? -eq 0 ] && echo "User has been added to the system!" || echo "Failed to add user!"
fi
