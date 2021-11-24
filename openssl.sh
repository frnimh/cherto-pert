#!/usr/bin/env bash

# get domain name from user
echo "Enter your Domain:"
read domain

# Get IP
echo "Enter your Domain IP:"
read ip

# Get Validation Days
echo "Enter Validation days:"
read days

# Generate SSL
openssl req -x509 -newkey rsa:4096 -sha256 -days $days -nodes \
-keyout $domain.key -out $domain.crt -subj "/CN=$domain" \
-addext "subjectAltName=DNS:$domain,DNS:$domain,IP:$ip"
