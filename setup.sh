#!/bin/bash

KEY_FILE="$HOME/.ssh/id_rsa_iphone"
CONFIG_FILE="$HOME/.ssh/config"

echo "[*] Setting up iPhone SSH environment..."

# 1. Check iproxy
if ! command -v iproxy &> /dev/null; then
    echo "[*] iproxy not found, installing usbmuxd via brew..."
    brew install usbmuxd
fi

# 2. Start iproxy in background
if pgrep -x "iproxy" > /dev/null; then
    echo "[*] iproxy is already running"
else
    echo "[*] Starting iproxy on port 2222..."
    nohup iproxy 2222 22 >/dev/null 2>&1 &
    sleep 2
fi

# 3. Create SSH Key for iPhone
if [ ! -f "$KEY_FILE" ]; then
    echo "[*] Generating SSH key for iPhone..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_FILE" -N ""
fi

# 4. Copy public key to iPhone
echo "[*] Copying SSH public key to iPhone..."
ssh-copy-id -i "$KEY_FILE.pub" -p 2222 root@localhost

# 5. Add block config SSH (if not exist)
if ! grep -q "Host localhost-iphone" "$CONFIG_FILE" 2>/dev/null; then
    echo "[*] Adding SSH config..."
    cat <<EOT >> "$CONFIG_FILE"

Host localhost-iphone
    HostName localhost
    Port 2222
    User root
    IdentityFile $KEY_FILE
EOT
fi

echo "[*] Done!"
echo "[*] Test with: ssh localhost-iphone"
echo "[*] Theos will use: make install"