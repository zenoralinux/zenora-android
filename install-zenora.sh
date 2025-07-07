#!/data/data/com.termux/files/usr/bin/bash -e

# ---------- Zenora Linux | install-zenora.sh ----------
# Website: https://zenoralinux.ir
# Telegram: https://t.me/zenoralinux
# GitHub: https://github.com/zenoralinux
# ------------------------------------------------------

# ====[ Colors ]====
GREEN="\033[1;32m"
BLUE="\033[1;34m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ====[ Info ]====
ROOTFS_DIR="${HOME}/zenora-rootfs"
BIN_FILE="$PREFIX/bin/zenora"
ROOTFS_URL="https://github.com/zenoralinux/zenora-android/releases/latest/download/zenroalinux-arm64-rootfs.tar.gz"

# ====[ Logo ]====
echo -e "${BLUE}"
echo "╔═════════════════════════════════════════════╗"
echo "║       🚀 Installing Zenora Linux (ARM64)    ║"
echo "╚═════════════════════════════════════════════╝"
echo -e "${RESET}"

# ====[ Step 1: Install Dependencies ]====
echo -e "${YELLOW}[1/4] Installing dependencies...${RESET}"
pkg update -y
pkg install -y proot proot-distro wget curl tar zsh

# ====[ Step 2: Download RootFS ]====
echo -e "${YELLOW}[2/4] Downloading latest Zenora rootfs...${RESET}"
mkdir -p "$ROOTFS_DIR"
cd "$HOME"

if [ ! -f rootfs.tar.gz ]; then
    wget -O rootfs.tar.gz "$ROOTFS_URL"
fi

# ====[ Step 3: Extract ]====
echo -e "${YELLOW}[3/4] Extracting rootfs to $ROOTFS_DIR...${RESET}"
tar -xzf rootfs.tar.gz -C "$ROOTFS_DIR" --strip-components=0
rm -f rootfs.tar.gz

# Ensure .version file exists
touch "$ROOTFS_DIR/root/.version"

# ====[ Step 4: Create launcher script ]====
echo -e "${YELLOW}[4/4] Creating launcher at $BIN_FILE ...${RESET}"

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
    -b zenora-rootfs$home:/dev/shm \
    -w $home \
    /usr/bin/env -i \
    HOME=$home \
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \
    TERM=$TERM \
    LANG=C.UTF-8 \
    $start"

cmd="$@"
if [ "$#" == "0" ]; then
    exec $cmdline
else
    $cmdline -c "$cmd"
fi
EOF

chmod +x "$BIN_FILE"

# ====[ Done ]====
echo -e "\n${GREEN}✅ Zenora Linux has been successfully installed!${RESET}"
echo -e "To launch: ${BLUE}zenora${RESET}"
echo -e "To launch as root: ${BLUE}zenora -r${RESET}"

# ====[ Footer ]====
echo -e "\n${YELLOW}🔗 Website: ${RESET}https://zenoralinux.ir"
echo -e "${YELLOW}💬 Telegram: ${RESET}https://t.me/zenoralinux"
echo -e "${YELLOW}📦 GitHub:   ${RESET}https://github.com/zenoralinux\n"
