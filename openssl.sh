# get domain name
echo "Enter your domain:"
read domain

# Get IP
echo "Enter your IP:"
read ip

# Get days valid
echo "Enter Valid days:"
read days

# Generate SSL
openssl req -x509 -newkey rsa:4096 -sha256 -days $days -nodes \
-keyout $domain.key -out $domain.crt -subj "/CN=$domain" \
-addext "subjectAltName=DNS:$domain,DNS:$domain,IP:$ip"
