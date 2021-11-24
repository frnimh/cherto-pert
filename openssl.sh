#!/usr/bin/env bash

# get domain name from user
echo -n "Enter your Domain: "
read domain

# Get IP
echo -n "Enter your Domain IP: "
read ip

# Get Validation Days
echo -n "Enter Validation days: "
read days

# Generate SSL
openssl req -x509 -newkey rsa:4096 -sha256 -days $days -nodes \
-keyout $domain.key -out $domain.crt -subj "/CN=$domain" \
-addext "subjectAltName=DNS:$domain,DNS:$domain,IP:$ip"
