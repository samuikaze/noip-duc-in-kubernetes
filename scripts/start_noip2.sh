#!/bin/ash

if [ -f .env ]; then
    while IFS="=" read -r env_key env_val; do
        export $env_key=$env_val
        print "$env_key=$env_val from dotenv file\n"
    done < .env
fi

chmod +x /usr/local/bin/noip-duc

/usr/local/bin/noip-duc -g $DOMAINS -u $USERNAME -p $PASSWORD
