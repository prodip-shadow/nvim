#!/usr/bin/env bash
# ==============================================================================
#  Cross-Distribution Automated Neovim Installer
#  Repository: https://github.com/prodip-shadow/nvim
#
#  Supported Linux Distributions:
#    - Arch Linux, Manjaro, EndeavourOS, Garuda, ArcoLinux, Artix
#    - Ubuntu, Debian, Linux Mint, Pop!_OS, Zorin OS, Elementary OS, Kali
#    - Fedora
#    - RHEL, Rocky Linux, AlmaLinux, CentOS Stream, Oracle Linux
# ==============================================================================

set -Eeuo pipefail

# ------------------------------------------------------------------------------
# Constants & Configuration
# ------------------------------------------------------------------------------
REPO_URL="https://github.com/prodip-shadow/nvim.git"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_BIN="$HOME/.local/bin"
NVIM_MIN_VERSION="0.10.0"
SUDO_PID=""

# ------------------------------------------------------------------------------
# Colors & Visual Formatting
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
# UI Message Helpers
# ------------------------------------------------------------------------------
step() {
    local step_num="$1"
    local total_steps="7"
    local title="$2"
    echo -e "\n${BOLD}${CYAN}[${step_num}/${total_steps}]${RESET} ${BOLD}${title}${RESET}"
}

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

fatal() {
    error "$1"
    cleanup
    exit 1
}

cleanup() {
    if [[ -n "${SUDO_PID:-}" ]] && kill -0 "$SUDO_PID" 2>/dev/null; then
        kill "$SUDO_PID" 2>/dev/null || true
    fi
}

trap cleanup EXIT INT TERM

# ------------------------------------------------------------------------------
# Sudo & Privilege Management
# ------------------------------------------------------------------------------
setup_sudo() {
    SUDO=""
    if [[ "$(id -u)" -ne 0 ]]; then
        if command -v sudo &>/dev/null; then
            SUDO="sudo"
            if ! sudo -n true 2>/dev/null; then
                info "Root privileges required for installing system packages."
                info "Please enter your sudo password if prompted:"
                if ! sudo -v; then
                    fatal "Failed to obtain sudo authentication."
                fi
            fi
            # Keep sudo alive during installation
            ( while true; do sudo -n true; sleep 45; kill -0 "$$" || exit; done ) 2>/dev/null &
            SUDO_PID=$!
        else
            fatal "This installer requires root privileges or sudo to install system dependencies."
        fi
    fi
}

# ------------------------------------------------------------------------------
# Version Comparison Helper (SemVer)
# Returns 0 (true) if $1 >= $2
# ------------------------------------------------------------------------------
version_ge() {
    local v1="$1"
    local v2="$2"
    if [[ "$v1" == "$v2" ]]; then
        return 0
    fi
    local lower
    lower=$(printf '%s\n%s\n' "$v1" "$v2" | sort -V | head -n 1)
    [[ "$lower" == "$v2" ]]
}

# ------------------------------------------------------------------------------
# Step 1: Detect Linux Distribution
# ------------------------------------------------------------------------------
detect_distribution() {
    step "1" "Detecting Linux distribution"

    DISTRO_ID=""
    DISTRO_LIKE=""
    DISTRO_NAME=""
    DISTRO_FAMILY=""
    PKG_MANAGER=""

    if [[ -f /etc/os-release ]]; then
        # shellcheck disable=SC1091
        source /etc/os-release
        DISTRO_ID="${ID:-}"
        DISTRO_LIKE="${ID_LIKE:-}"
        DISTRO_NAME="${PRETTY_NAME:-${NAME:-Linux}}"
    elif [[ -f /usr/lib/os-release ]]; then
        # shellcheck disable=SC1091
        source /usr/lib/os-release
        DISTRO_ID="${ID:-}"
        DISTRO_LIKE="${ID_LIKE:-}"
        DISTRO_NAME="${PRETTY_NAME:-${NAME:-Linux}}"
    else
        DISTRO_NAME="$(uname -s)"
    fi

    # Determine distribution family and package manager
    if [[ "$DISTRO_ID" =~ ^(arch|manjaro|endeavouros|garuda|artix|arcolinux)$ ]] || [[ "$DISTRO_LIKE" =~ arch ]]; then
        DISTRO_FAMILY="arch"
        PKG_MANAGER="pacman"
    elif [[ "$DISTRO_ID" =~ ^(ubuntu|debian|linuxmint|pop|zorin|elementary|kali)$ ]] || [[ "$DISTRO_LIKE" =~ (debian|ubuntu) ]]; then
        DISTRO_FAMILY="debian"
        PKG_MANAGER="apt"
    elif [[ "$DISTRO_ID" == "fedora" ]] || { [[ "$DISTRO_LIKE" =~ fedora ]] && [[ ! "$DISTRO_ID" =~ (rhel|rocky|almalinux|centos) ]]; }; then
        DISTRO_FAMILY="fedora"
        PKG_MANAGER="dnf"
    elif [[ "$DISTRO_ID" =~ ^(rhel|rocky|almalinux|centos|ol)$ ]] || [[ "$DISTRO_LIKE" =~ (rhel|centos) ]]; then
        DISTRO_FAMILY="rhel"
        if command -v dnf &>/dev/null; then
            PKG_MANAGER="dnf"
        else
            PKG_MANAGER="yum"
        fi
    else
        # Fallback detection by available package manager
        if command -v pacman &>/dev/null; then
            DISTRO_FAMILY="arch"
            PKG_MANAGER="pacman"
        elif command -v apt-get &>/dev/null; then
            DISTRO_FAMILY="debian"
            PKG_MANAGER="apt"
        elif command -v dnf &>/dev/null; then
            DISTRO_FAMILY="fedora"
            PKG_MANAGER="dnf"
        elif command -v yum &>/dev/null; then
            DISTRO_FAMILY="rhel"
            PKG_MANAGER="yum"
        else
            fatal "Unsupported Linux distribution (${DISTRO_NAME}). Please install Neovim and dependencies manually."
        fi
    fi

    ARCH="$(uname -m)"

    info "Operating System    : ${BOLD}${DISTRO_NAME}${RESET}"
    info "Distribution Family : ${BOLD}${DISTRO_FAMILY}${RESET}"
    info "Package Manager     : ${BOLD}${PKG_MANAGER}${RESET}"
    info "System Architecture : ${BOLD}${ARCH}${RESET}"
    success "System compatibility verified."
}

# ------------------------------------------------------------------------------
# Step 2: Install / Verify Neovim
# ------------------------------------------------------------------------------
install_neovim_binary_fallback() {
    info "Installing pre-built official Neovim release binary..."
    local nvim_arch=""
    case "$ARCH" in
        x86_64)
            nvim_arch="linux-x86_64"
            ;;
        aarch64|arm64)
            nvim_arch="linux-arm64"
            ;;
        *)
            fatal "Pre-built Neovim binary is unavailable for architecture: ${ARCH}. Please compile Neovim from source."
            ;;
    esac

    local download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-${nvim_arch}.tar.gz"
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    local tar_file="${tmp_dir}/nvim.tar.gz"

    info "Downloading Neovim from ${download_url}..."
    curl -fsSL "$download_url" -o "$tar_file"

    local install_dest="/opt/nvim-${nvim_arch}"
    $SUDO rm -rf "$install_dest"
    $SUDO mkdir -p "$install_dest"
    $SUDO tar -xzf "$tar_file" -C "$install_dest" --strip-components=1

    $SUDO ln -sf "${install_dest}/bin/nvim" /usr/local/bin/nvim
    rm -rf "$tmp_dir"

    export PATH="/usr/local/bin:$PATH"
}

install_neovim() {
    step "2" "Installing Neovim"

    local nvim_current_version=""
    if command -v nvim &>/dev/null; then
        nvim_current_version="$(nvim --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || echo "")"
    fi

    if [[ -n "$nvim_current_version" ]] && version_ge "$nvim_current_version" "$NVIM_MIN_VERSION"; then
        success "Neovim v${nvim_current_version} is already installed and up to date (>= v${NVIM_MIN_VERSION})."
        return 0
    fi

    if [[ -n "$nvim_current_version" ]]; then
        warn "Found Neovim v${nvim_current_version}, but configuration requires >= v${NVIM_MIN_VERSION}."
    else
        info "Neovim is not installed. Installing latest version..."
    fi

    case "$DISTRO_FAMILY" in
        arch)
            info "Installing Neovim via pacman..."
            $SUDO pacman -S --needed --noconfirm neovim
            ;;
        fedora)
            info "Installing Neovim via dnf..."
            $SUDO dnf install -y neovim
            ;;
        debian)
            info "Checking Neovim package in distribution repository..."
            export DEBIAN_FRONTEND=noninteractive
            $SUDO apt-get update -y
            $SUDO apt-get install -y neovim || true
            local apt_ver=""
            if command -v nvim &>/dev/null; then
                apt_ver="$(nvim --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || echo "")"
            fi
            if [[ -z "$apt_ver" ]] || ! version_ge "$apt_ver" "$NVIM_MIN_VERSION"; then
                info "Repository Neovim (${apt_ver:-none}) is older than v${NVIM_MIN_VERSION}. Installing latest release binary..."
                install_neovim_binary_fallback
            fi
            ;;
        rhel)
            info "Installing Neovim for RHEL-based distribution..."
            $SUDO "${PKG_MANAGER}" install -y epel-release 2>/dev/null || true
            $SUDO "${PKG_MANAGER}" install -y neovim 2>/dev/null || true
            local rhel_ver=""
            if command -v nvim &>/dev/null; then
                rhel_ver="$(nvim --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || echo "")"
            fi
            if [[ -z "$rhel_ver" ]] || ! version_ge "$rhel_ver" "$NVIM_MIN_VERSION"; then
                info "Repository Neovim (${rhel_ver:-none}) is older than v${NVIM_MIN_VERSION}. Installing latest release binary..."
                install_neovim_binary_fallback
            fi
            ;;
    esac

    # Validate final Neovim installation
    if ! command -v nvim &>/dev/null; then
        fatal "Neovim installation could not be verified. 'nvim' executable not found."
    fi

    local verified_version
    verified_version="$(nvim --version | head -n 1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 || echo "unknown")"
    success "Neovim v${verified_version} is installed and verified."
}

# ------------------------------------------------------------------------------
# Step 3: Install Dependencies
# ------------------------------------------------------------------------------
install_dependencies() {
    step "3" "Installing dependencies"

    info "Installing system packages required by configuration, plugins, and LSPs..."

    case "$DISTRO_FAMILY" in
        arch)
            local arch_pkgs=(
                git curl wget unzip tar gzip
                ripgrep fd
                nodejs npm
                python python-pip python-pynvim
                base-devel cmake
                go
                xclip wl-clipboard
            )
            $SUDO pacman -S --needed --noconfirm "${arch_pkgs[@]}"
            ;;
        debian)
            export DEBIAN_FRONTEND=noninteractive
            local debian_pkgs=(
                git curl wget unzip tar gzip
                ripgrep fd-find
                nodejs npm
                python3 python3-pip python3-venv
                build-essential cmake
                xclip wl-clipboard
            )
            $SUDO apt-get update -y
            $SUDO apt-get install -y --no-install-recommends "${debian_pkgs[@]}" || $SUDO apt-get install -y "${debian_pkgs[@]}"
            
            # Additional packages if present in repo
            $SUDO apt-get install -y python3-pynvim 2>/dev/null || true
            $SUDO apt-get install -y golang-go 2>/dev/null || $SUDO apt-get install -y golang 2>/dev/null || true

            # Debian/Ubuntu names fd as `fdfind` -> Create symlink for Telescope
            if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
                mkdir -p "$LOCAL_BIN"
                ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
                export PATH="$LOCAL_BIN:$PATH"
                info "Linked fd -> $(command -v fdfind)"
            fi
            ;;
        fedora)
            local fedora_pkgs=(
                git curl wget unzip tar gzip
                ripgrep fd-find
                nodejs npm
                python3 python3-pip python3-neovim
                gcc gcc-c++ make cmake
                golang
                xclip wl-clipboard
            )
            $SUDO dnf install -y "${fedora_pkgs[@]}" || true
            ;;
        rhel)
            $SUDO "${PKG_MANAGER}" install -y epel-release 2>/dev/null || true
            local rhel_pkgs=(
                git curl wget unzip tar gzip
                ripgrep fd-find
                nodejs npm
                python3 python3-pip
                gcc gcc-c++ make cmake
                golang
                xclip wl-clipboard
            )
            $SUDO "${PKG_MANAGER}" install -y "${rhel_pkgs[@]}" 2>/dev/null || true
            $SUDO "${PKG_MANAGER}" install -y python3-pynvim 2>/dev/null || true
            ;;
    esac

    # Ensure ~/.local/bin exists in current session PATH
    mkdir -p "$LOCAL_BIN"
    export PATH="$LOCAL_BIN:$PATH"

    success "All required system dependencies installed."
}

# ------------------------------------------------------------------------------
# Step 4: Backup Existing Neovim Configuration
# ------------------------------------------------------------------------------
backup_existing_config() {
    step "4" "Backing up existing configuration"

    if [[ -d "$CONFIG_DIR" ]]; then
        local is_our_repo=false
        if [[ -d "$CONFIG_DIR/.git" ]]; then
            local remote_url
            remote_url="$(git -C "$CONFIG_DIR" config --get remote.origin.url 2>/dev/null || echo "")"
            if [[ "$remote_url" =~ prodip-shadow/nvim ]]; then
                is_our_repo=true
            fi
        fi

        if [[ "$is_our_repo" == "true" ]]; then
            info "Existing configuration in ${CONFIG_DIR} is already prodip-shadow/nvim."
            info "Will synchronize and update in the next step."
        else
            local timestamp
            timestamp="$(date +'%Y%m%d-%H%M%S')"
            local backup_path="${CONFIG_DIR}.backup-${timestamp}"
            info "Existing Neovim configuration detected. Creating backup..."
            mv "$CONFIG_DIR" "$backup_path"
            success "Backup successfully created at: ${BOLD}${backup_path}${RESET}"
        fi
    else
        info "No existing Neovim configuration found. Ready for fresh installation."
    fi
}

# ------------------------------------------------------------------------------
# Step 5: Install / Update Neovim Configuration
# ------------------------------------------------------------------------------
install_config() {
    step "5" "Installing Neovim configuration"

    mkdir -p "$(dirname "$CONFIG_DIR")"

    if [[ -d "$CONFIG_DIR/.git" ]]; then
        local remote_url
        remote_url="$(git -C "$CONFIG_DIR" config --get remote.origin.url 2>/dev/null || echo "")"
        if [[ "$remote_url" =~ prodip-shadow/nvim ]]; then
            info "Updating existing repository in ${CONFIG_DIR}..."
            git -C "$CONFIG_DIR" fetch origin main
            git -C "$CONFIG_DIR" reset --hard origin/main
            success "Configuration updated to latest commit."
            return 0
        fi
    fi

    info "Cloning repository from ${REPO_URL} into ${CONFIG_DIR}..."
    git clone "$REPO_URL" "$CONFIG_DIR"
    success "Configuration cloned successfully."
}

# ------------------------------------------------------------------------------
# Step 6: Install Plugins and Development Tools
# ------------------------------------------------------------------------------
install_plugins_and_tools() {
    step "6" "Installing plugins and development tools"

    info "Synchronizing plugins with Lazy.nvim (headless mode)..."
    nvim --headless "+Lazy! sync" +qa 2>&1 | while read -r line; do
        if [[ "$line" =~ (checkout|Installing|Updating|Cloning|Fetching|Installed|HEAD) ]]; then
            echo -e "    ${line}"
        fi
    done || true
    success "Lazy.nvim plugins installed and synchronized."

    info "Compiling and updating Treesitter parsers..."
    nvim --headless -c "lua pcall(function() require('nvim-treesitter.install').update({ with_sync = true }) end)" -c "qa" 2>&1 || true
    success "Treesitter parsers compiled."

    info "Installing language servers, formatters, and debuggers via Mason..."
    nvim --headless "+MasonToolsInstallSync" +qa 2>&1 || true
    success "Mason tools and language servers installed."
}

# ------------------------------------------------------------------------------
# Step 7: Verify Installation & Health Check
# ------------------------------------------------------------------------------
verify_installation() {
    step "7" "Verifying installation"

    local errors=0

    if command -v nvim &>/dev/null; then
        local nvim_v
        nvim_v="$(nvim --version | head -n 1)"
        success "Neovim binary : ${nvim_v}"
    else
        error "Neovim binary not found."
        ((errors++))
    fi

    if command -v git &>/dev/null; then
        success "Git           : $(git --version)"
    else
        error "Git not found."
        ((errors++))
    fi

    if command -v rg &>/dev/null; then
        success "Ripgrep (rg)  : $(rg --version | head -n 1)"
    else
        warn "Ripgrep (rg) not found in PATH."
    fi

    if command -v fd &>/dev/null || command -v fdfind &>/dev/null; then
        success "FD Finder     : Available"
    else
        warn "fd finder not found in PATH."
    fi

    if [[ -f "${CONFIG_DIR}/init.lua" ]]; then
        success "Config Entry  : ${CONFIG_DIR}/init.lua exists"
    else
        error "Configuration entry file missing: ${CONFIG_DIR}/init.lua"
        ((errors++))
    fi

    info "Testing Neovim configuration loading..."
    if nvim --headless -c "lua print('CONFIG_LOAD_OK')" -c "qa" 2>&1 | grep -q "CONFIG_LOAD_OK"; then
        success "Neovim configuration loaded cleanly."
    else
        warn "Neovim loaded with warnings. Run :checkhealth inside Neovim for detailed diagnostics."
    fi

    if [[ "$errors" -gt 0 ]]; then
        fatal "Verification finished with ${errors} error(s). Please review the logs above."
    fi
}

# ------------------------------------------------------------------------------
# Final Completion Banner
# ------------------------------------------------------------------------------
display_completion() {
    echo -e "\n${BOLD}${GREEN}========================================${RESET}"
    echo -e "${BOLD}${GREEN}✓ Neovim installation completed!${RESET}"
    echo -e "${BOLD}${GREEN}✓ Configuration installed successfully!${RESET}"
    echo -e "${BOLD}${GREEN}✓ Plugins installed!${RESET}"
    echo -e "${BOLD}${GREEN}✓ Development tools configured!${RESET}"
    echo -e ""
    echo -e "Run:"
    echo -e ""
    echo -e "  ${BOLD}${CYAN}nvim${RESET}"
    echo -e ""
    echo -e "Enjoy!"
    echo -e "${BOLD}${GREEN}========================================${RESET}\n"
}

# ------------------------------------------------------------------------------
# Main Execution Entrypoint
# ------------------------------------------------------------------------------
main() {
    echo -e "${BOLD}${MAGENTA}"
    cat << "EOF"
  _   _                 _             ___           _        _ _           
 | \ | | ___  _____   _(_)_ __ ___   |_ _|_ __  ___| |_ __ _| | | ___ _ __ 
 |  \| |/ _ \/ _ \ \ / / | '_ ` _ \   | || '_ \/ __| __/ _` | | |/ _ \ '__|
 | |\  |  __/ (_) \ V /| | | | | | |  | || | | \__ \ || (_| | | |  __/ |   
 |_| \_|\___|\___/ \_/ |_|_| |_| |_| |___|_| |_|___/\__\__,_|_|_|\___|_|   
                                                                            
EOF
    echo -e "${RESET}${BOLD}Cross-Distribution One-Command Installer${RESET}"
    echo -e "${CYAN}Repository: https://github.com/prodip-shadow/nvim${RESET}\n"

    setup_sudo
    detect_distribution
    install_neovim
    install_dependencies
    backup_existing_config
    install_config
    install_plugins_and_tools
    verify_installation
    display_completion
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
