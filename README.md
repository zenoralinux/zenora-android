# 🧬 Zenora Linux for Android (ARM64 Termux)

Welcome to the official **Zenora Linux ARM64 rootfs** for Android, designed to run smoothly inside **Termux** using `proot`.

---

## 🚀 Features

- Arch-based lightweight rootfs
- Preinstalled ZSH, powerlevel10k, neofetch
- Supports `sudo`, man pages, fake-APT and more
- Auto-login for normal user and root support (`-r`)
- Clean and user-friendly ZSH experience

---

## 📦 How to Install (Automatic)

1. Make sure you are using **Termux from F-Droid** (not Play Store)
2. Copy-paste this into Termux:

```bash
curl -LO https://raw.githubusercontent.com/zenoralinux/zenora-android/main/install-zenora.sh
bash install-zenora.sh
````

---

## 🧰 Manual Installation (Advanced Users)

If the automatic installer fails or you prefer manual setup:

### 1. Install dependencies:

```bash
pkg update -y
pkg install -y proot proot-distro wget curl tar zsh
```

### 2. Download and extract the rootfs:

```bash
wget -O rootfs.tar.gz https://github.com/zenoralinux/zenora-android/releases/latest/download/zenroalinux-arm64-rootfs.tar.gz
mkdir -p ~/zenora-rootfs
tar -xzf rootfs.tar.gz -C ~/zenora-rootfs --strip-components=0
rm rootfs.tar.gz
```

### 3. Create `.version` file:

```bash
touch ~/zenora-rootfs/root/.version
```

### 4. Create a launcher script at `$PREFIX/bin/zenora` (or run `install-zenora.sh`)

---

## 📁 Termux Storage Access (Needed for File Sharing)

If you want Zenora to access your **Downloads**, **DCIM**, or **shared storage**, you must grant storage permissions:

### Method 1: Via Command

```bash
termux-setup-storage
```

* You will see a permission popup → tap "Allow"
* This creates the `/sdcard` symlink in Termux

### Method 2: Manually via Android Settings

1. Open **Android Settings**
2. Go to **Apps > Termux > Permissions**
3. Enable **Files and media** or **All files access** (depending on your Android version)

---

## 💻 How to Use Zenora

### Login as regular user:

```bash
zenora
```

### Login as root:

```bash
zenora -r
```

> If `zenora` is not recognized, run `hash -r` or restart Termux

---

## 📂 Directory Structure

| Path                 | Description               |
| -------------------- | ------------------------- |
| `~/zenora-rootfs/`   | Extracted root filesystem |
| `$PREFIX/bin/zenora` | Launcher script           |
| `.version`           | Compatibility marker file |

---

## 🔗 Links

* 🌐 Website: [zenoralinux.ir](https://zenoralinux.ir)
* 💬 Telegram: [@zenoralinux](https://t.me/zenoralinux)
* 📦 GitHub: [github.com/zenoralinux](https://github.com/zenoralinux)

---

## 🛠 Maintained by

**Zenora Linux Team**
Maintainer: [@miladalizadeh](https://github.com/miladalizadeh)
