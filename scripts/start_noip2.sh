#!/bin/ash

if [ -f .env ]; then
    echo "./.env exists!"
    echo "[Warn] You're in develop mode now, all the credentials and domains will be print to terminal."
    echo "[Warn] If you want to run in production mode, please remove .env file in scripts directory and set all the credentials in environment variables."
    echo ""
    while IFS="=" read -r env_key env_val; do
        eval "$env_key=$env_val"
        printf "%s=%s from dotenv file\n" "$env_key" "$env_val"
    done < .env
fi

chmod +x /usr/local/bin/noip-duc

/usr/local/bin/noip-duc -g $DOMAINS -u $USERNAME -p $PASSWORD
