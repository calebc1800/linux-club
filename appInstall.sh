#!/bin/bash
#Repo Install
#KDEnlive
add-apt-repository ppa:kdenlive/kdenlive-stable
#Avidemux
sudo add-apt-repository ppa:ubuntuhandbook1/avidemux
#Open Shot
sudo add-apt-repository ppa:openshot.developers/ppa

#Update
apt update

#photo editing software
apt install gimp openshot inkscape pinta digikam krita darktable rawtherapee -y
#Video editing software
apt install pitivi kdenlive frei0r-plugins avidemux2.7-qt5 avidemux2.7-qt5-data avidemux2.7-plugins-qt5 avidemux2.7-jobs-qt5 openshot-qt -y
