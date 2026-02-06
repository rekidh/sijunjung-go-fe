#!/bin/bash

# =========================================
# Waydroid Dev Ready Script (Dynamic + Auto)
# =========================================

echo "🟢 Restarting Waydroid session..."
waydroid session stop
# Start session in background to prevent blocking
waydroid session start &

# Wait for session to be active
echo "⏳ Waiting for session to start..."
until waydroid status | grep -q "RUNNING"; do
    sleep 1
done

waydroid show-full-ui &

sleep 3

# =========================================
# Enable IP forwarding
# =========================================
echo "🟢 Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

# =========================================
# Setup NAT for internet
# =========================================
echo "🟢 Setting up NAT..."
# Detect default route interface
DEFAULT_IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
echo "🟢 Detected host interface: $DEFAULT_IFACE"

sudo iptables -t nat -A POSTROUTING -o $DEFAULT_IFACE -j MASQUERADE
sudo iptables -A FORWARD -i $DEFAULT_IFACE -o waydroid0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i waydroid0 -o $DEFAULT_IFACE -j ACCEPT

# =========================================
# Wait for Waydroid platform service
# =========================================
echo "🟢 Waiting for Waydroid platform service..."
until sudo waydroid shell service list | grep -q waydroidplatform; do
    echo "⏳ Platform service not ready yet..."
    sleep 1
done
echo "✅ Waydroid platform ready!"

# =========================================
# Fix DNS and Network (Crucial for API stability)
# =========================================
echo "🟢 Setting DNS for Waydroid (Fixing Timeout)..."
sudo waydroid shell setprop net.eth0.dns1 8.8.8.8
sudo waydroid shell setprop net.eth0.dns2 1.1.1.1

# =========================================
# Detect Waydroid IP dynamically
# =========================================
WAYDROID_IP=$(waydroid status | grep "IP address" | awk '{print $3}')
echo "🟢 Detected Waydroid IP: $WAYDROID_IP"

# =========================================
# Connect ADB
# =========================================
echo "🟢 Connecting ADB..."
adb connect $WAYDROID_IP

# =========================================
# Wait until ADB authorized
# =========================================
echo "🟢 Waiting for ADB authorization..."
while true; do
    STATUS=$(adb devices | grep $WAYDROID_IP | awk '{print $2}')
    if [ "$STATUS" == "device" ]; then
        echo "✅ ADB is ready!"
        break
    fi
    echo "⏳ ADB not ready yet, please allow USB debugging in Waydroid..."
    sleep 2
done

# =========================================
# Detect host screen size dynamically
# =========================================
# HOST_WIDTH=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -dx -f1)
# HOST_HEIGHT=$(xdpyinfo | grep dimensions | awk '{print $2}' | cut -dx -f2)
# DENSITY=420  # default, bisa disesuaikan

# echo "🟢 Setting Waydroid display to $HOST_WIDTH x $HOST_HEIGHT, density $DENSITY"
# sudo waydroid shell wm size ${HOST_WIDTH}x${HOST_HEIGHT}
# sudo waydroid shell wm density $DENSITY
sudo waydroid shell wm size 1080x2400
sudo waydroid shell wm density 420

# =========================================
# Lock portrait orientation
# =========================================
echo "🟢 Locking portrait orientation"
sudo waydroid shell settings put system accelerometer_rotation 0
sudo waydroid shell settings put system user_rotation 0 # 0=Portrait, 1=Landscape

# =========================================
# Show final status
# =========================================
echo "🟢 Waydroid status:"
waydroid status

echo "🟢 Connected devices:"
adb devices

echo "✅ Waydroid is ready for Flutter development!"
