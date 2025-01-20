#!/data/data/com.termux/files/usr/bin/sh

echo "Enter home directory"
cd ~ || { echo "Failed to change directory"; exit 1; }

# Function to install a package if not already installed
install_package() {
    local pkg_name="$1"
    if ! command -v "$pkg_name" > /dev/null; then
        echo "Installing $pkg_name..."
        pkg install "$pkg_name" -y || { echo "Failed to install $pkg_name"; exit 1; }
    fi
}

# Update package list and upgrade existing packages
echo "Updating package list..."
pkg update || { echo "Failed to update packages"; exit 1; }

# Install essential packages
install_package git
install_package python-tflite-runtime
install_package ninja
install_package patchelf

# Clone Wyoming Satellite repo and run setup script
echo "Cloning Wyoming Satellite repository..."
git clone https://github.com/rhasspy/wyoming-satellite.git || { echo "Failed to clone wyoming-satellite"; exit 1; }

cd wyoming-satellite || { echo "Failed to enter wyoming-satellite directory"; exit 1; }
echo "Running Wyoming Satellite setup script..."
./script/setup || { echo "Wyoming Satellite setup failed"; cd ..; exit 1; }

# Set up autostart and widget shortcut
cd ..
mkdir -p ~/.termux/boot/
wget -P ~/.termux/boot/ https://raw.githubusercontent.com/T-vK/wyoming-satellite-termux/main/wyoming-satellite-android || { echo "Failed to download Wyoming Satellite Android script"; exit 1; }
chmod +x ~/.termux/boot/wyoming-satellite-android

mkdir -p ~/.shortcuts/tasks/
ln -sf ../../.termux/boot/wyoming-satellite-android ~/.shortcuts/tasks/wyoming-satellite-android || { echo "Failed to create shortcut"; exit 1; }

echo "Successfully installed and set up Wyoming Satellite"

# Display device IP address
echo "Write down the IP address (most likely starting with '192.') of your device:"
ifconfig | grep -m 1 "inet " | awk '{print $2}' || { echo "Failed to get IP address"; exit 1; }

# Ask user for additional installations and actions
read -p "Install Wyoming OpenWakeWord as well? [y/N] " install_oww

if [[ "$install_oww" =~ ^[Yy]$ ]]; then
    echo "Cloning Wyoming OpenWakeWord repository..."
    git clone https://github.com/rhasspy/wyoming-openwakeword.git || { echo "Failed to clone wyoming-openwakeword"; exit 1; }

    cd wyoming-openwakeword || { echo "Failed to enter wyoming-openwakeword directory"; exit 1; }
    
    # Allow system site packages in setup script
    sed -i 's/\(builder = venv.EnvBuilder(with_pip=True\)/\1, system_site_packages=True/' ./script/setup

    echo "Running Wyoming OpenWakeWord setup script..."
    ./script/setup || { echo "Wyoming OpenWakeWord setup failed"; cd ..; exit 1; }

    sed -i 's/^export OWW_ENABLED=false$/export OWW_ENABLED=true/' ~/.termux/boot/wyoming-satellite-android
fi

read -p "Launch Wyoming Satellite now? [y/N] " launch_now

if [[ "$launch_now" =~ ^[Yy]$ ]]; then
    echo "Starting Wyoming Satellite..."
    ~/.termux/boot/wyoming-satellite-android || { echo "Failed to start Wyoming Satellite"; exit 1; }
fi

echo "Script execution completed."
