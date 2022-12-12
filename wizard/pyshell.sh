1#!/bin/bash

echo -e '\e[0m'                                                              
echo -e '@@@  @@@   @@@@@@   @@@@@@@   @@@@@@@@    @@@   @@@@@@@@     @@@'
echo -e '@@@@ @@@  @@@@@@@@  @@@@@@@@  @@@@@@@@   @@@@  @@@@@@@@@@   @@@@'
echo -e '@@!@!@@@  @@!  @@@  @@!  @@@  @@!       @@@!!  @@!   @@@@  @@@!!'
echo -e '!@!!@!@!  !@!  @!@  !@!  @!@  !@!         !@!  !@!  @!@!@    !@!'
echo -e '@!@ !!@!  @!@  !@!  @!@  !@!  @!!!:!:     @!@  @!@ @! !@!    @!@'
echo -e '!@!  !!!  !@!  !!!  !@!  !!!  !!!!!::     !@!  !@!!!  !!!    !@!'
echo -e '!!:  !!!  !!:  !!!  !!:  !!!  !!:         !!:  !!:!   !!!    !!:'
echo -e ':!:  !:!  :!:  !:!  :!:  !:!  :!:         :!:  :!:    !:!    :!:'
echo -e ':::   ::   ::::::   :::::::   :::::::     :::   ::::::::     :::'
echo -e '\e[0m'



sudo apt update && sudo apt upgrade -y
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.10 -y
curl -sS https://bootstrap.pypa.io/get-pip.py -y| python3.10 
python3.10 -m pip install --upgrade pip -y
python3.10 --version 
python3.10 -m pip install pick 
python3.10 -m pip install requests 
python3.10 -m pip install os3 
python3.10 -m pip install subprocess 

mv node101wizard.py node101wizard

echo -e '\e[0m' 
echo -e '@@@  @@@  @@@  @@@  @@@@@@@@   @@@@@@   @@@@@@@   @@@@@@@ '
echo -e '@@@  @@@  @@@  @@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@'
echo -e '@@!  @@!  @@!  @@!       @@!  @@!  @@@  @@!  @@@  @@!  @@@'
echo -e '!@!  !@!  !@!  !@!      !@!   !@!  @!@  !@!  @!@  !@!  @!@'
echo -e '@!!  !!@  @!@  !!@     @!!    @!@!@!@!  @!@!!@!   @!@  !@!'
echo -e '!@!  !!!  !@!  !!!    !!!     !!!@!!!!  !!@!@!    !@!  !!!'
echo -e '!!:  !!:  !!:  !!:   !!:      !!:  !!!  !!: :!!   !!:  !!!'
echo -e ':!:  :!:  :!:  :!:  :!:       :!:  !:!  :!:  !:!  :!:  !:!'
echo -e ':::: :: :::    ::   :: ::::  ::   :::  ::   :::   :::: :: '
echo -e '\e[0m' 