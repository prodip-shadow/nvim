#!/usr/bin/env bash
# ==============================================================================
#  Automated Cross-Distribution Neovim Uninstaller
#  Repository: https://github.com/prodip-shadow/nvim
#
#  Usage:
#    bash uninstall.sh              # Interactive uninstallation
#    bash uninstall.sh --all        # Completely remove config, plugins, cache, and Neovim
#    bash uninstall.sh --config     # Remove config, plugins, and cache only (keeps Neovim)
# ==============================================================================

set -Eeuo pipefail

# ------------------------------------------------------------------------------
# Constants & Paths
# ------------------------------------------------------------------------------
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"
LOCAL_BIN="$HOME/.local/bin"

REMOVE_NEOVIM_BIN=false
AUTO_CONFIRM=false

# ------------------------------------------------------------------------------
# Colors & Formatting
# ------------------------------------------------------------------------------
if [[ -t 1 ]] && command -v tput &>/dev/null && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
    BOLD="$(tput bold)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    CYAN="$(tput setaf 6)"
    RED="$(tput setaf 1)"
    MAGENTA="$(tput setaf 5)"
    RESET="$(tput sgr0)"
else
    BOLD=""
    GREEN=""
    YELLOW=""
    BLUE=""
    CYAN=""
    RED=""
    MAGENTA=""
    RESET=""
fi

# ------------------------------------------------------------------------------
# UI Helpers
# ------------------------------------------------------------------------------
info() {
    echo -e "  ${BLUE}➜${RESET} $1"
}

success() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

warn() {
    echo -e "  ${YELLOW}!${RESET} ${YELLOW}$1${RESET}"
}

error() {
    echo -e "  ${RED}✗${RESET} ${RED}$1${RESET}" >&2
}

# ------------------------------------------------------------------------------
# Parse Arguments
# ------------------------------------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --all|-a)
            REMOVE_NEOVIM_BIN=true
            AUTO_CONFIRM=true
            ;;
        --config|-c)
            REMOVE_NEOVIM_BIN=false
            AUTO_CONFIRM=true
            ;;
        --yes|-y)
            AUTO_CONFIRM=true
            ;;
        --help|-h)
            echo "Usage: bash uninstall.sh [options]"
            echo ""
            echo "Options:"
            echo "  -a, --all      Remove configuration, plugins, cache, and uninstall Neovim binary"
            echo "  -c, --config   Remove configuration, plugins, and cache only (keep Neovim)"
            echo "  -y, --yes      Non-interactive mode (automatically confirm prompts)"
            echo "  -h, --help     Show this help message"
            exit 0
            ;;
    esac
done

# ------------------------------------------------------------------------------
# Interactive Confirmation
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${RED}======================================================${RESET}"
echo -e "${BOLD}${RED}           Neovim Uninstallation Wizard               ${RESET}"
echo -e "${BOLD}${RED}======================================================${RESET}\n"

echo -e "This wizard will remove:"
echo -e "  • Neovim Configuration : ${BOLD}${CONFIG_DIR}${RESET}"
echo -e "  • Installed Plugins    : ${BOLD}${DATA_DIR}${RESET}"
echo -e "  • State & Undo History : ${BOLD}${STATE_DIR}${RESET}"
echo -e "  • Cache Files          : ${BOLD}${CACHE_DIR}${RESET}\n"

if [[ "$AUTO_CONFIRM" != "true" ]]; then
    read -rp "Are you sure you want to proceed with uninstallation? [y/N]: " confirm_removal
    if [[ ! "$confirm_removal" =~ ^[Yy]$ ]]; then
        info "Uninstallation aborted by user."
        exit 0
    fi

    echo ""
    read -rp "Do you also want to uninstall the Neovim executable package from your system? [y/N]: " confirm_bin_removal
    if [[ "$confirm_bin_removal" =~ ^[Yy]$ ]]; then
        REMOVE_NEOVIM_BIN=true
    fi
fi

# ------------------------------------------------------------------------------
# 1. Remove Configuration, Plugins, and Cache
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}[1/3] Removing Configuration, Plugins & Cache${RESET}"

if [[ -d "$CONFIG_DIR" ]]; then
    rm -rf "$CONFIG_DIR"
    success "Removed configuration directory: ${CONFIG_DIR}"
else
    info "Configuration directory not found, skipping."
fi

if [[ -d "$DATA_DIR" ]]; then
    rm -rf "$DATA_DIR"
    success "Removed data & plugins directory: ${DATA_DIR}"
else
    info "Data directory not found, skipping."
fi

if [[ -d "$STATE_DIR" ]]; then
    rm -rf "$STATE_DIR"
    success "Removed state directory: ${STATE_DIR}"
else
    info "State directory not found, skipping."
fi

if [[ -d "$CACHE_DIR" ]]; then
    rm -rf "$CACHE_DIR"
    success "Removed cache directory: ${CACHE_DIR}"
else
    info "Cache directory not found, skipping."
fi

# ------------------------------------------------------------------------------
# 2. Clean Up Symlinks
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}[2/3] Cleaning up installer symlinks${RESET}"

if [[ -L "${LOCAL_BIN}/fd" ]]; then
    rm -f "${LOCAL_BIN}/fd"
    success "Removed local fd symlink: ${LOCAL_BIN}/fd"
fi

if [[ -L "${LOCAL_BIN}/nvim" ]]; then
    rm -f "${LOCAL_BIN}/nvim"
    success "Removed local nvim symlink: ${LOCAL_BIN}/nvim"
fi

# ------------------------------------------------------------------------------
# 3. Uninstall Neovim Executable (If Requested)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}[3/3] Neovim Executable Management${RESET}"

if [[ "$REMOVE_NEOVIM_BIN" == "true" ]]; then
    info "Attempting to remove Neovim executable..."

    SUDO=""
    if [[ "$(id -u)" -ne 0 ]] && command -v sudo &>/dev/null; then
        SUDO="sudo"
    fi

    # Remove pre-built manual binaries if present
    if [[ -d "/opt/nvim-linux-x86_64" ]] || [[ -d "/opt/nvim-linux-arm64" ]] || [[ -f "/usr/local/bin/nvim" ]]; then
        $SUDO rm -rf /opt/nvim-linux-* /usr/local/bin/nvim 2>/dev/null || true
        success "Removed pre-built Neovim binaries from /opt and /usr/local/bin."
    fi

    # Detect package manager and remove package
    if command -v pacman &>/dev/null; then
        if pacman -Qi neovim &>/dev/null; then
            $SUDO pacman -R --noconfirm neovim
            success "Uninstalled neovim via pacman."
        fi
    elif command -v apt-get &>/dev/null; then
        if dpkg -l neovim &>/dev/null; then
            $SUDO apt-get remove -y neovim
            success "Uninstalled neovim via apt."
        fi
    elif command -v dnf &>/dev/null; then
        if rpm -q neovim &>/dev/null; then
            $SUDO dnf remove -y neovim
            success "Uninstalled neovim via dnf."
        fi
    elif command -v yum &>/dev/null; then
        if rpm -q neovim &>/dev/null; then
            $SUDO yum remove -y neovim
            success "Uninstalled neovim via yum."
        fi
    fi
else
    info "Neovim executable was preserved. Only configuration and plugins were removed."
fi

# ------------------------------------------------------------------------------
# Completion Banner
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${GREEN}======================================================${RESET}"
echo -e "${BOLD}${GREEN}✓ Uninstallation completed successfully!${RESET}"
echo -e "${BOLD}${GREEN}======================================================${RESET}\n"
if [[ "$REMOVE_NEOVIM_BIN" == "true" ]]; then
    echo -e "Neovim and all associated configurations have been completely removed from your system.\n"
else
    echo -e "Neovim configuration, plugins, and cache have been wiped clean."
    echo -e "You can reinstall anytime by running:"
    echo -e "  ${BOLD}${CYAN}bash <(curl -fsSL https://raw.githubusercontent.com/prodip-shadow/nvim/main/install.sh)${RESET}\n"
fi
