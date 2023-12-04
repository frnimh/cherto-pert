#!/bin/bash

# SET Domains
TARGETS="example.com example.me"
# Set Days
DAYS=7

# SET NTFY Things
NTFY_URL="https://ntfy.sh"      # Your NTFY URL (use ntfy.sh for ios/android push notifictions or config your self-hosted ntfy well)
NTFY_TOPIC="Certificates"       # Your NTFY Topic
NTFY_PRIORITY=3                 # Priority of this for you (how much do you care about it!)
NTFY_AUTH="Bearer tk_Sample"    # if you dont want to use auth, remove it from curl func too (-H "Authorization: $NTFY_AUTH")

# Not Set This, my things (get time)
TIME=$(date +%s)

# Curl Function to send Notif
ntfy_curl() {
    curl -X POST $NTFY_URL/$NTFY_TOPIC -H "Authorization: $NTFY_AUTH" -H "Title: $NTFY_TITLE" -H "Priority: $NTFY_PRIORITY" -H "Tags: $NTFY_TAGS" -d "$NTFY_MESSAGE";
}

# Check for every Domains in List
for TARGET in $TARGETS
do
    echo "Checking if $TARGET expires is less than $DAYS"
    # Get SSL Expire timestamp using openssl command
    EXPDATE=$(date -d "$(: | openssl s_client -connect $TARGET:443 -servername $TARGET 2>/dev/null \
                           | openssl x509 -text \
                           | grep 'Not After' \
                           | awk '{print $4,$5,$7}')" '+%s');
    # Doing Hard Math
    INDAYS=$(($(date +%s) + (86400*$DAYS)));
    
    if [ $TIME -gt $EXPDATE ]; then
    # Send Notif if Certificate Expired Already
        NTFY_TITLE="Cert Expired"
        NTFY_MESSAGE="Certificate for $TARGET expired💀, on $(date -d @$EXPDATE '+%Y-%m-%d')"
        NTFY_TAGS="lock, sob"
        ntfy_curl

    elif [ $INDAYS -gt $EXPDATE ]; then
    # Send Notif if Certificate still want to live
        NTFY_TITLE="Cert Expire in $DAYS Days"
        NTFY_MESSAGE="Certificate for $TARGET expires in less than $DAYS days🔥, on $(date -d @$EXPDATE '+%Y-%m-%d')"
        NTFY_TAGS="lock, frowning_face"
        ntfy_curl
    else
    # Dont Know just not close it with done, exit code, etc..
        echo "OK - Certificate expires on $(date -d @$EXPDATE '+%Y-%m-%d')"
    fi;
done
