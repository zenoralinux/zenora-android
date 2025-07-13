#!/data/data/com.termux/files/usr/bin/bash

# =====================[ Colors ]=====================
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

# =====================[ Variables ]==================
ROOTFS_DIR="$HOME/zenora-rootfs"
ROOTFS_TAR="$HOME/rootfs.tar.gz"
BIN_FILE="$PREFIX/bin/zenora"
ROOTFS_URL="https://github.com/zenoralinux/zenora-android/releases/latest/download/zenroalinux-arm64-rootfs.tar.gz"

# ===================[ Functions ]====================
log() { echo -e "${BLUE}[•]${RESET} $1"; }
success() { echo -e "${GREEN}[✔]${RESET} $1"; }
warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
error_exit() { echo -e "${RED}[✘]${RESET} $1"; exit 1; }

check_command() {
    command -v "$1" >/dev/null 2>&1
}

# ===================[ Start Script ]=================
echo -e "${YELLOW}╔══════════════════════════════════════╗"
echo -e "║    🚀 Installing Zenora for Termux   ║"
echo -e "╚══════════════════════════════════════╝${RESET}"

# Step 1: Check internet
log "Checking internet connectivity..."
ping -c 1 1.1.1.1 >/dev/null 2>&1 || error_exit "No internet connection."

export DEBIAN_FRONTEND=noninteractive

echo "[*] Updating packages..."
pkg update -y

# Step 2: Install required packages
log "Checking required packages..."
REQUIRED_PKGS=(proot wget curl bsdtar )
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! check_command "$pkg"; then
        log "Installing $pkg..."
        pkg install -y "$pkg" || error_exit "Failed to install $pkg"
    fi
done
success "All dependencies are installed."

# Step 3: Download rootfs if needed
if [ -f "$ROOTFS_TAR" ]; then
    success "RootFS archive already exists: rootfs.tar.gz"
else
    log "Downloading rootfs archive..."
    wget -O "$ROOTFS_TAR" "$ROOTFS_URL" || error_exit "Download failed."
    success "Download complete."
fi

# Step 4: Extract rootfs if not already extracted
if [ -d "$ROOTFS_DIR" ] && [ -f "$ROOTFS_DIR/root/.version" ]; then
    success "RootFS already extracted."
else
    log "Extracting rootfs..."
    mkdir -p "$ROOTFS_DIR"
    bsdtar -xpf "$ROOTFS_TAR" -C "$ROOTFS_DIR" || error_exit "Extraction failed."
    touch "$ROOTFS_DIR/root/.version"
    success "Extraction complete."
fi

# Step 5: Create launcher if not exists
if [ -f "$BIN_FILE" ]; then
    success "Launcher already exists at: $BIN_FILE"
else
    log "Creating launcher..."
    cat > "$BIN_FILE" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash -e

cd ${HOME}
unset LD_PRELOAD

if [ ! -f zenora-rootfs/root/.version ]; then
    touch zenora-rootfs/root/.version
fi

user="zenora"
home="/home/$user"
start="/bin/zsh --login"
as_root="false"

# بررسی اینکه کاربر zenora تعریف شده یا نه
if ! grep -q "$user" zenora-rootfs/etc/passwd; then
    as_root="true"
fi

# اگر با -r یا -R اجرا شده باشه => root
if [[ "$#" != "0" && ("$1" == "-r" || "$1" == "-R") ]]; then
    as_root="true"
    shift
fi

# اگر root mode فعال بود، تغییر مسیر home و shell
if [[ "$as_root" == "true" ]]; then
    user="root"
    home="/root"
    start="/bin/zsh --login"
    proot_uid_flag="-0"
else
    proot_uid_flag=""  # یعنی بدون -0 اجرا بشه
fi

cmdline="proot \
    --link2symlink \
    $proot_uid_flag \
    -r zenora-rootfs \
    -b /dev \
    -b /proc \
    -b /sys \
    -b /sdcard \
    -b zenora-rootfs$home:/dev/shm \
    -w $home \
    /usr/bin/env -i \
    HOME=$home \
    USER=$user \
    PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin \
    TERM=$TERM \
    LANG=C.UTF-8 \
    $start"

cmd="$@"
if [ "$#" == "0" ]; then
    eval "$cmdline"
else
    eval "$cmdline -c \"$cmd\""
fi
EOF

    chmod +x "$BIN_FILE" || error_exit "Failed to make launcher executable."
    success "Launcher created at: $BIN_FILE"
fi

# Final Info
echo -e "\n${GREEN}✅ Zenora Linux installed successfully!${RESET}"
echo -e "${YELLOW}🔹 Launch with:${RESET} ${BLUE}zenora${RESET}"
echo -e "${YELLOW}🔹 Launch as root:${RESET} ${BLUE}zenora -r${RESET}"
echo -e "${YELLOW}🌐 Website:${RESET} https://zenoralinux.ir"
echo -e "${YELLOW}💬 Telegram:${RESET} https://t.me/zenoralinux"
