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

sleep 1

sudo curl https://sh.rustup.rs -sSf | sh -s -- -y

source "$HOME/.cargo/env"  &&  rustup update 

sudo apt -y install cmake && sudo apt-get update && sudo apt-get install ufw && sudo ufw enable && sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop net-tools lsof -y < "/dev/null"
apt install cargo

sudo git clone https://github.com/AleoHQ/snarkOS.git --depth 1 && cd snarkOS && sudo ./build_ubuntu.sh && source "$HOME/.cargo/env" && cargo install --path .  && ./run-client.sh

mkdir $HOME/aleo
snarkos account new >>$HOME/aleo/account.txt

# Private Key ve diğer Key'leri görüntülemek için;

mkdir -p /var/aleo/
cat $HOME/aleo/account.txt >>/var/aleo/account_backup.txt
echo 'export VALIDATOR_PRIVATE_KEY'=$(grep "Private Key" $HOME/aleo/account.txt | awk '{print $3}') >> $HOME/.bash_profile
source $HOME/.bash_profile

echo "[Unit]
Description=Snarkos Client
After=network-online.target
[Service]
User=$USER
ExecStart=$(which snarkos) start --nodisplay --client ${VALIDATOR_PRIVATE_KEY}
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > $HOME/snarkos-client.service
 mv $HOME/snarkos-client.service /etc/systemd/system
 tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF 

sudo systemctl enable snarkos-client

echo "[Unit]
Description=Snarkos Prover
After=network-online.target
[Service]
User=$USER
ExecStart=$(which snarkos) start --nodisplay --prover ${VALIDATOR_PRIVATE_KEY}
Restart=always
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
" > $HOME/snarkos-prover.service
 mv $HOME/snarkos-prover.service /etc/systemd/system

sudo systemctl enable snarkos-prover

sudo systemctl restart snarkos-client 

sudo systemctl restart snarkos-prover

cat $HOME/aleo/account.txt

echo -e "CHECK OUT YOUR LOGS : \e[1m\e[32mPlease Save Your Keys\e[0m"

echo '=============== SETUP IS FINISHED ==================='
echo -e "CHECK OUT YOUR LOGS : \e[1m\e[32msudo journalctl -u snarkos-client -f -o cat\e[0m"
source $HOME/.bash_profile