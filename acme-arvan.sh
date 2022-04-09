#!/usr/bin/env bash

# Get Domain Name
echo -n "Enter your Domain: "
read domain

# Get Arvan API
echo -n "Enter your Arvan API: "
read api

# Set API
export Arvan_Token="$api"

# Issue a cert
~/.acme.sh/acme.sh --issue --dns dns_arvan -d $domain --server letsencrypt
