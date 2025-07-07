#!/data/data/com.termux/files/usr/bin/bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Info
ROOTFS_DIR="${HOME}/zenora-rootfs"
BIN_FILE="$PREFIX/bin/zenora"
ROOTFS_URL="https://github.com/zenoralinux/zenora-android/releases/latest/download/zenroalinux-arm64-rootfs.tar.gz"

# Function to exit with error message
die() {
    echo -e "${RED}[✘] $1${RESET}"
    exit 1
}

# Logo
echo -e "${BLUE}"
echo "╔═════════════════════════════════════════════╗"
echo "║       🚀 Installing Zenora Linux (ARM64)    ║"
echo "╚═════════════════════════════════════════════╝"
echo -e "${RESET}"

# Check internet connection
echo -e "${YELLOW}[•] Checking internet connection...${RESET}"
ping -c 1 -W 3 1.1.1.1 > /dev/null || die "No internet connection. Please check your network."

# Install dependencies
echo -e "${YELLOW}[1/5] Installing required packages...${RESET}"
export DEBIAN_FRONTEND=noninteractive
pkg update -y || die "Failed to update package list."
pkg install -y proot wget curl tar|| die "Failed to install dependencies."

# Download rootfs
echo -e "${YELLOW}[2/5] Downloading rootfs...${RESET}"
mkdir -p "$ROOTFS_DIR"
cd "$HOME"

if [ ! -f rootfs.tar.gz ]; then
    wget -O rootfs.tar.gz "$ROOTFS_URL" || die "Download failed. Check the URL or internet."
fi

# Verify file exists
[ -f rootfs.tar.gz ] || die "RootFS archive not found after download."

# Extract rootfs
echo -e "${YELLOW}[3/5] Extracting rootfs...${RESET}"
tar -xzf rootfs.tar.gz -C "$ROOTFS_DIR" --strip-components=0 || die "Extraction failed."
rm -f rootfs.tar.gz

# Ensure .version
touch "$ROOTFS_DIR/root/.version" || die "Could not create .version file."

# Create launcher
echo -e "${YELLOW}[4/5] Creating launcher script at $BIN_FILE...${RESET}"

cat > "$BIN_FILE" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash -e

cd ${HOME}
unset LD_PRELOAD

if [ ! -f zenora-rootfs/root/.version ]; then
    touch zenora-rootfs/root/.version
fi

user="zzenora"
home="/home/$user"
start="sudo -u $user /bin/zsh --login"

if grep -q "$user" zenora-rootfs/etc/passwd; then
    ZENORAUSR="1"
else
    ZENORAUSR="0"
fi

if [[ $ZENORAUSR == "0" || ("$#" != "0" && ("$1" == "-r" || "$1" == "-R")) ]]; then
    user="root"
    home="/root"
    start="/bin/zsh --login"
    if [[ "$#" != "0" && ("$1" == "-r" || "$1" == "-R") ]]; then
        shift
    fi
fi

cmdline="proot \
    --link2symlink \
    -0 \
    -r zenora-rootfs \
    -b /dev \
    -b /proc \
    -b /sys \
    -b /sdcard \
    -b zenora-rootfs\$home:/dev/shm \
    -w \$home \
    /usr/bin/env -i \
    HOME=\$home \
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \
    TERM=\$TERM \
    LANG=C.UTF-8 \
    \$start"

cmd="\$@"
if [ "\$#" == "0" ]; then
    exec \$cmdline
else
    \$cmdline -c "\$cmd"
fi
EOF

chmod +x "$BIN_FILE" || die "Failed to make launcher executable."

# Finish
echo -e "\n${GREEN}✅ Zenora Linux was successfully installed!${RESET}"
echo -e "🔹 Launch as user: ${BLUE}zenora${RESET}"
echo -e "🔹 Launch as root: ${BLUE}zenora -r${RESET}"

# Info
echo -e "\n${YELLOW}🌐 Website:${RESET} https://zenoralinux.ir"
echo -e "${YELLOW}💬 Telegram:${RESET} https://t.me/zenoralinux"
