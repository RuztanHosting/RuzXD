#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installTheme(){
    cd /var/www/
    tar -cvf RuzXDbackup.tar.gz pterodactyl
    echo "Installing theme..."
    cd /var/www/pterodactyl
    rm -r RuzXD
    git clone https://github.com/RuztanHosting/RuzXD.git
    cd RuzXD
    rm /var/www/pterodactyl/resources/scripts/RuzXD.css
    rm /var/www/pterodactyl/resources/scripts/index.tsx
    mv index.tsx /var/www/pterodactyl/resources/scripts/index.tsx
    mv RuzXD.css /var/www/pterodactyl/resources/scripts/RuzXD.css
    cd /var/www/pterodactyl

    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt update
    apt install -y nodejs

    npm i -g yarn
    yarn

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear


}

installThemeQuestion(){
    while true; do
        read -p "Are you sure that you want to install the theme [y/n]? " yn
        case $yn in
            [Yy]* ) installTheme; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

repair(){
    bash <(curl https://raw.githubusercontent.com/RuztanHosting/RuzXD/main/repair.sh)
}

restoreBackUp(){
    echo "Restoring backup..."
    cd /var/www/
    tar -xvf RuzXDbackup.tar.gz
    rm RuzXDbackup.tar.gz

    cd /var/www/pterodactyl
    yarn build:production
    sudo php artisan optimize:clear
}
echo "RuztanXD Cuma Pemula Jangan Di Bully Puh"
echo "©RuztanXD"
echo ""
echo "Channel wa: https://whatsapp.com/channel/0029VabMRfKDJ6H1y5xfgj2s"
echo "Tele: t.me/ruztanxd"
echo ""
echo "[1] Install theme"
echo "[2] Restore backup"
echo "[3] Repair panel (use if you have an error in the theme installation)"
echo "[4] Exit"

read -p "Pilih Salah satu angka: " choice
if [ $choice == "1" ]
    then
    installThemeQuestion
fi
if [ $choice == "2" ]
    then
    restoreBackUp
fi
if [ $choice == "3" ]
    then
    repair
fi
if [ $choice == "4" ]
    then
    exit
fi
