#!/bin/bash
#Name : Scan.sh
#Author: Shan Prashanth
#Version: v1.0

clear
echo "   _____                       _     "
echo "  / ____|                     | |    "
echo " | (___   ___ ____ _ __    ___| |__  "
echo "  \___ \ / __/ _  |  _ \  / __|  _ \ "
echo "  ____) | (_| (_| | | | |_\__ \ | | |"
echo " |_____/ \___\____|_| |_(_)___/_| |_|"

under="-------------------------------"
echo
echo
echo  "Scan.sh starting"
echo $under
echo
echo -n "Enter FileName : "
read file
if [ ! -d $file ]; then
	mkdir -p $file; cd $file
	echo "New Folder has created!"
fi
echo "Folder Has Created!!"
echo
echo -n "Interface : "
read iface
echo 
echo -n "IP range : "
read ipr
echo
echo "Starting Netdiscover..."
echo $under
echo
netdiscover -P -i $iface -r $ipr
echo
echo
echo "Starting NBT Scan..."
echo $under
echo
nbtscan -r $ipr
echo
echo -n "Nmap Command [-A -sV] : "
read command
echo
echo -n "Enter IP to Scan : "
read ip
echo
echo "Nmap Scanning starting on $ip"
echo $under
echo
nmap $command $ip -oA $file$command 
echo
if grep -q "80/tcp\|443/tcp" $file$command.nmap
then
        echo "Port 80 or 443 Found."
	echo
	echo "Opening FireFox"
	echo $under
	firefox --new-window $ip  2>/dev/null &
	echo "Port 80 Found. Nikto is running"
	nikto -h $ip -o $file-nikto.txt
else
	echo "not found"
fi

read -p "Press enter to continue to enum4linux"
echo "Starting enum4Linux"
echo $under 
enum4linux $ip > $file-enum.txt  2>/dev/null
echo
echo "All Acanning and Discovery Done!"

