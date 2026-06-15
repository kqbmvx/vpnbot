rm /ssh/key*
# Install docker CLI and iptables if not present
if ! which docker > /dev/null 2>&1; then
    apk add --no-cache docker-cli iptables > /dev/null 2>&1
fi

# Restore hysteria port hopping iptables rule if configured
HOP_RANGE=$(php -r "
\$pac = json_decode(file_get_contents('/config/pac.json'), true);
echo \$pac['hysteria_hop_range'] ?? '';
" 2>/dev/null)
if [ -n "$HOP_RANGE" ]; then
    FROM=$(echo $HOP_RANGE | cut -d'-' -f1)
    TO=$(echo $HOP_RANGE | cut -d'-' -f2)
    MAIN_PORT=$(php -r "
\$c = yaml_parse_file('/docker/compose');
echo explode(':', \$c['services']['hy']['ports'][0])[0];
" 2>/dev/null)
    if [ -n "$MAIN_PORT" ]; then
        docker run --rm --net=host --cap-add=NET_ADMIN alpine:latest sh -c "apk add -q iptables && iptables -t nat -D PREROUTING -p udp --dport $FROM:$TO -j REDIRECT --to-ports $MAIN_PORT 2>/dev/null; iptables -t nat -A PREROUTING -p udp --dport $FROM:$TO -j REDIRECT --to-ports $MAIN_PORT" > /dev/null 2>&1 &
    fi
fi

ssh-keygen -m PEM -t rsa -f /ssh/key -N ''
openssl req -newkey rsa:2048 -sha256 -nodes -x509 -days 365 -keyout /certs/self_private -out /certs/self_public  -subj "/C=NN/ST=N/L=N/O=N/CN=$IP"
php init.php
if [[ -f "/start" && -f "/ssh/key.pub" && -s "/ssh/key.pub" ]]; then
    unitd --log /logs/unit_error
    curl -X PUT --data-binary @/config/unit.json --unix-socket /var/run/control.unit.sock http://localhost/config
    pkill unitd
    unitd --no-daemon --control 0.0.0.0:8080 --log /logs/unit_error
else
    exit 1;
fi
