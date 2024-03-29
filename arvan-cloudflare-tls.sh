#!/bin/bash

# check acme.sh installed or aliases set

ARED='\x1b[31;1m'
AURL='\x1b[39;49m'
ANO='\033[0m'
ACME="$HOME/.acme.sh/"

if ! [ ${ACME}/acme.sh 2>&1 1>/dev/null ] && [ acme.sh 2>&1 1>/dev/null ]; then
        echo -e "${ARED}acme not installed or aliases not set"
	echo -e "checkout ${AURL}https://github.com/acmesh-official/acme.sh/wiki/How-to-install${ANO}"
        exit 1
fi

# Get from user
echo "1- Get New TLS (Default)"
echo "2- Renew Your TLS"
echo -n "Which do you want? (number): "
read WHAT

case $WHAT in
   1)
       WANT=new
	   ;;
   2)
       WANT=renew
       ;;
   *)
       WANT=new
       echo "set to default (1- new)"
       ;;
esac

# Get from user
echo "1- Cloudflare (Default)"
echo "2- ArvanCloud"
echo -n "Which do you use? (number): "
read SERVICE

case $SERVICE in
   1)
	   USING=cloud
	   ;;
   2)
	  USING=arvan
	   ;;
   *)
	   USING=cloud
       echo "set to default (1- cloudflare)"
	   ;;
esac

echo "/////////////////////////////////////"
echo " "

# Get Domain Name
echo -n "Enter your Domain: "
read domain

# //// Get new Cert ////
if [ $WANT = 'new' ]; then

    if [ $USING = 'cloud' ]; then
        # Get Cloudflare API
        echo -n "Enter your Cloudflare API Token: "
        read capi
        echo -n "Enter your Cloudflare Account ID: "
        read cid
        
        # Set Api
        export CF_Token="$capi"
        export CF_Account_ID="$cid"

        echo " "
        echo " "

        # Issue a cert
        acme.sh --issue --dns dns_cf -d $domain --server letsencrypt

    elif [ $USING = 'arvan' ]; then
        # Get Arvan API
        echo -n "Enter your Arvan API: "
        read aapi

        # Set API
        export Arvan_Token="$aapi"

        echo " "
        echo " "

        # Issue a cert
        acme.sh --issue --dns dns_arvan -d $domain --server letsencrypt

    else
        echo "new unknow"
    fi

# //// Renew The cert ////
elif [ $WANT = 'renew' ]; then

    if [ $USING = 'cloud' ]; then
        echo " "

        # Renew a cert from cloudflare
        acme.sh --issue --dns dns_cf -d $domain --server letsencrypt --renew --force

    elif [ $USING = 'arvan' ]; then
        echo " "

        # Renew a cert
        acme.sh --issue --dns dns_arvan -d $domain --server letsencrypt --renew --force

    else
        echo "renew unknow"
    fi

else
    echo "all unknow"

fi
