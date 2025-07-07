# 🧬 Zenora Linux for Android (ARM64 Termux)

Welcome to the official **Zenora Linux ARM64 rootfs** for Android, specially designed to run inside **Termux** using `proot`.

---

## 🚀 Features

- Minimal and fast Arch-based rootfs
- Preconfigured with ZSH, `powerlevel10k`, `neofetch`, and more
- Supports sudo, man pages, fake APT, custom configurations
- Root and user login options
- Ready for daily use and development inside Termux

---

## 📦 How to Install

1. Open Termux (preferably updated)
2. Run this one-liner:

```bash
curl -LO https://raw.githubusercontent.com/zenoralinux/zenora-android/main/install-zenora.sh
bash install-zenora.sh
````

---

## 💻 How to Use

### Login as regular user:

```bash
zenora
```

### Login as root:

```bash
zenora -r
```

> If `zenora` is not recognized, restart your Termux or run: `source ~/.bashrc` or `hash -r`

---

## 📂 Files and Structure

* `zenora-rootfs/`: Contains the extracted root filesystem
* `$PREFIX/bin/zenora`: Executable launcher script
* `.version`: Empty marker file for compatibility

---

## 🔗 Links

* 🌐 Website: [zenoralinux.ir](https://zenoralinux.ir)
* 💬 Telegram: [@zenoralinux](https://t.me/zenoralinux)
* 📦 GitHub: [github.com/zenoralinux](https://github.com/zenoralinux)

---

## 🛠 Maintained by

**Zenora Linux Team**
Maintainer: [@miladalizadeh](https://instagram.com/miladalizadew)
