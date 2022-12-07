#! /bin/bash

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

EXECUTE=namada-trusted-setupd
SYSTEM_FOLDER=.namada-trusted-setupd
PROJECT_FOLDER=namada-trusted-setup
VERSION=v1.1.0
REPO=https://github.com/anoma/namada-trusted-setup.git

sleep 2

sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env" && rustup update 

sleep 1

if [ ! $TOKEN ]; then
	read -p "ENTER KEY ADDRESS: " TOKEN KEY
	echo 'export TOKEN='$TOKEN >> $HOME/.bash_profile
fi


echo "export EXECUTE=${EXECUTE}" >> $HOME/.bash_profile
echo "export SYSTEM_FOLDER=${SYSTEM_FOLDER}" >> $HOME/.bash_profile
echo "export PROJECT_FOLDER=${PROJECT_FOLDER}" >> $HOME/.bash_profile
echo "export VERSION=${VERSION}" >> $HOME/.bash_profile
echo "export REPO=${REPO}" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 1

sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y && sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof -y < "/dev/null"  && sudo apt-get update -y 
sudo apt-get install wget liblz4-tool aria2 -y && sudo apt update && sudo apt install -y curl git build-essential pkg-config libssl-dev

sleep 1

git clone $REPO
cd $PROJECT_FOLDER
git checkout $VERSION ; make install
cargo build --release --bin namada-ts --features cli
mv target/release/namada-ts /usr/local/bin 

sleep 1

echo '=============== SETUP IS FINISHED ==================='

source $HOME/.bash_profile

echo -e "=================== \e[1m\e[32mPlease save your mnemonics !\e[0m ==================="

namada-ts contribute default https://contribute.namada.net $TOKEN