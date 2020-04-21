#!/bin/bash
if [ -d "/etc/squid/" ]; then
    payload="/etc/squid/payload.txt"
elif [ -d "/etc/squid3/" ]; then
	payload="/etc/squid3/payload.txt"
fi
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-10s\n' "Remover Host  Squid Proxy" ; tput sgr0
if [ ! -f "$payload" ]
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Archive $payload not found" ; tput sgr0
	exit 1
else
	tput setaf 2 ; tput bold ; echo ""; echo "Current domains in the file $payload:" ; tput sgr0
	tput setaf 3 ; tput bold ; echo "" ; cat $payload ; echo "" ; tput sgr0
	read -p "Enter the domain you want to remove from the list: " host
	if [[ -z $host ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "You entered an empty or non-existing domain!" ; echo "" ; tput sgr0
			exit 1
		else
		if [[ `grep -c "^$host" $payload` -ne 1 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "O domínio $host não foi encontrado no arquivo $payload" ; echo "" ; tput sgr0
			exit 1
		else
			grep -v "^$host" $payload > /tmp/a && mv /tmp/a $payload
			tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "ArCHIVE $payload updated, domain was successfully removed:" ; tput sgr0
			tput setaf 3 ; tput bold ; echo "" ; cat $payload ; echo "" ; tput sgr0
			if [ ! -f "/etc/init.d/squid3" ]
			then
				service squid3 reload
			elif [ ! -f "/etc/init.d/squid" ]
			then
				service squid reload
			fi	
			tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "The Squid Proxy was successfully reloaded!" ; echo "" ; tput sgr0
			exit 1
		fi
	fi
fi