# ⚡ Modern Cross-Distribution Neovim IDE

[![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?logo=neovim&logoColor=white&style=for-the-badge)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1%20%2F%20LuaJIT-2C2D72?logo=lua&logoColor=white&style=for-the-badge)](https://www.lua.org)
[![Plugin Manager](https://img.shields.io/badge/Plugin%20Manager-Lazy.nvim-blue?style=for-the-badge)](https://github.com/folke/lazy.nvim)
[![Theme](https://img.shields.io/badge/Theme-Nord-88C0D0?style=for-the-badge)](https://github.com/shaunsingh/nord.nvim)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

A blisteringly fast, cross-distribution, full-featured IDE configuration for **Neovim** built with Lua. It delivers a modern, beautiful development environment out of the box with **VS Code style familiarity**, integrated debugging, one-click code execution, automated LSP setup, Treesitter syntax highlighting, and auto-formatting on save.

---

# 🚀 One-Command Installation

Set up your complete Neovim environment on any fresh Linux system by running **ONLY ONE command**:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/prodip-shadow/nvim/main/install.sh)
```

### 🐧 Supported Linux Distributions
The installer automatically detects your operating system, configures the native package manager, and sets up all required tools:

- **Arch Linux & Arch-based**: Arch Linux, Manjaro, EndeavourOS, Garuda Linux, ArcoLinux, Artix Linux
- **Debian / Ubuntu & Derivatives**: Ubuntu (20.04/22.04/24.04+), Debian (11/12+), Linux Mint, Pop!_OS, Zorin OS, Elementary OS, Kali Linux
- **Fedora**: Fedora 38/39/40+ (Workstation, Server, Silverblue)
- **RHEL & Enterprise Distros**: Red Hat Enterprise Linux (RHEL), Rocky Linux, AlmaLinux, CentOS Stream, Oracle Linux

### ⚙️ What the installer does automatically:
1. 🔍 **Detects your OS & system architecture** (`x86_64`, `aarch64` / `arm64`)
2. 📦 **Installs Neovim** (guaranteeing version $\ge 0.10.0$)
3. 🛠️ **Installs all dependencies** (`git`, `ripgrep`, `fd`, `nodejs`, `npm`, `python3`, `gcc`, `make`, `cmake`, `go`, clipboard tools `xclip`/`wl-clipboard`)
4. 💾 **Creates a timestamped backup** of any existing config (`~/.config/nvim.backup-YYYYMMDD-HHMMSS`)
5. 📥 **Clones / updates this configuration** directly into `~/.config/nvim`
6. 🔌 **Synchronizes all plugins via Lazy.nvim** in headless mode
7. 🧠 **Installs Treesitter parsers and Mason LSPs, formatters, and debug adapters**

---

# 📖 Getting Started

### 1. Launching Neovim:
```bash
# Open Neovim:
nvim

# Open the current directory as a project workspace:
nvim .

# Open a specific file:
nvim index.js
```

### 2. Understanding Neovim Modes:
- **Normal Mode** (Default mode): Used for navigation, shortcuts, and running commands. Press `Esc` from any mode to return to Normal mode.
- **Insert Mode**: Used for typing text. Press `i` to enter Insert mode; press `Esc` or `jk` / `kj` to exit.
- **Visual Mode**: Used for selecting text. Press `v` or use `Shift + Arrow keys` to start selecting.

---

# 📁 File & Folder Management (Neo-tree Guide)

File exploration and management is powered by **Neo-tree**. You can easily create, rename, copy, move, and delete files and folders without leaving Neovim.

### 🌟 Opening the File Explorer:
- `Ctrl + b` or `<Space> e` : Toggle the sidebar file explorer on the left.
- `<Space> w` : Toggle the centered floating file explorer.
- `\` (Backslash) : Reveal and focus the currently active buffer in the file tree.

### 🛠️ Explorer Actions (when Neo-tree is open and focused):

| Action | Shortcut (Key) | How to Use |
| :--- | :---: | :--- |
| **Create New File** | `a` | Focus the target directory, press `a`, type the file name (e.g. `app.js`), then press `Enter`. |
| **Create New Folder** | `A` | Focus the target directory, press `A` (Shift + a), type the folder name (e.g. `components/`), then press `Enter`. |
| **Rename File / Folder** | `r` | Place cursor on the item, press `r`, type the new name, and press `Enter`. |
| **Delete File / Folder** | `d` | Place cursor on the item, press `d`, then press `y` to confirm deletion. |
| **Copy File** | `y` or `c` | Place cursor on the file and press `y` (or `c` for prompt). |
| **Cut / Move File** | `x` or `m` | Place cursor on the file and press `x` (or `m` for prompt). |
| **Paste Copied / Cut Item** | `p` | Navigate to the destination folder and press `p`. |
| **Open File / Expand Folder** | `Enter` or `l` | Opens the selected file in a buffer or toggles folder expand/collapse. |
| **Toggle Hidden Files** | `H` | Press `H` (Shift + h) to toggle visibility of dotfiles (`.env`, `.gitignore`, etc.). |
| **Close Explorer** | `q` or `Esc` | Closes the Neo-tree sidebar or floating window. |

---

# ⌨️ VS Code Style Keybindings

If you are transitioning from VS Code, all familiar shortcuts work right out of the box with zero learning curve:

### 📝 Text Selection & Cursor Navigation
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Shift + Left/Right/Up/Down` | Normal / Insert / Visual | Select text character-by-character or line-by-line |
| `Ctrl + Shift + Left/Right` | Normal / Insert / Visual | Select whole words left or right |
| `Shift + Home` / `Shift + End` | Normal / Insert / Visual | Select from cursor to start / end of current line |
| `Ctrl + Shift + Home` / `End` | Normal / Insert / Visual | Select from cursor to the top / bottom of the entire file |
| `Ctrl + Left` / `Ctrl + Right` | Normal / Insert / Visual | Jump cursor word by word |
| `Home` / `End` | Normal / Insert / Visual | Jump cursor to the start / end of current line |

### 📋 Standard Clipboard (Copy, Cut, Paste & Selection)
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Ctrl + a` | Normal / Insert / Visual | Select all buffer content (Select All) |
| `Ctrl + c` | Visual / Normal | Copy selection or line to system clipboard (Copy) |
| `Ctrl + x` | Visual | Cut selection to system clipboard (Cut) |
| `Ctrl + v` | Normal / Insert / Visual | Paste from system clipboard (Paste) |
| `Backspace` / `Delete` | Visual | Delete selected text without overwriting clipboard register |

### ↩️ Undo, Redo & Line Manipulation
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Ctrl + z` | Normal / Insert / Visual | Undo |
| `Ctrl + y` or `Ctrl + Shift + z` | Normal / Insert | Redo |
| `Alt + Up` / `Alt + Down` | Normal / Insert / Visual | Move current line or selected block up / down |
| `Shift + Alt + Up` / `Down` | Normal / Insert / Visual | Duplicate current line or selection up / down |
| `Ctrl + Shift + k` | Normal / Insert | Delete current line |
| `Ctrl + Enter` | Insert | Insert new line below without breaking current line |
| `Ctrl + Shift + Enter` | Insert | Insert new line above |

### 🔍 Search, Replace, Comments & File Operations
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Ctrl + /` or `Ctrl + _` | Normal / Insert / Visual | Toggle comment on current line or selected block |
| `Ctrl + p` | Normal | Quick Open / Fuzzy search files (Telescope) |
| `Ctrl + Shift + f` | Normal | Find text across all project files (Live Grep) |
| `Ctrl + f` | Normal | Search within current file buffer |
| `Ctrl + h` | Normal | Find and Replace within file |
| `Ctrl + s` | Normal / Insert / Visual | Save current file |
| `Ctrl + q` | Normal | Quit Neovim |

---

# ⚡ Neovim Special & Power Features

The configured **Leader key** is **`Space`** (`<Space>`).

### 🖥️ Integrated Terminal & Code Runner
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Ctrl + \`` or `Ctrl + j` | Normal / Insert / Terminal | Toggle floating terminal window |
| `Ctrl + Alt + n` (`<C-M-n>`) | Normal / Insert | **Execute current code file!** (Supports C, C++, Python, JavaScript, TypeScript, Java) |

### 📑 Tabs & Buffer Management (Bufferline)
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Tab` / `Shift + Tab` | Normal | Cycle to Next / Previous buffer tab |
| `<Space> 1` through `<Space> 9` | Normal | Jump directly to buffer number 1 to 9 |
| `<Space> x` | Normal | Close current buffer (without closing window split) |
| `<Space> v` | Normal | Split window vertically |
| `<Space> h` | Normal | Split window horizontally |
| `Ctrl + h/j/k/l` | Normal | Navigate between window splits |
| `<Space> bg` | Normal | Toggle background transparency (Nord theme) |

### 🐞 Interactive Debugging (nvim-dap & dap-ui)
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `<F5>` | Normal | Start / Continue debugging session |
| `<F10>` | Normal | Step Over |
| `<F11>` | Normal | Step Into |
| `<F12>` | Normal | Step Out |
| `<Space> db` | Normal | Toggle Breakpoint |
| `<Space> dB` | Normal | Set Conditional Breakpoint |
| `<Space> du` | Normal | Toggle Debugger UI (dap-ui) |

### 🧠 Language Server Protocol (LSP) & Code Intelligence
| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `gd` | Normal | Goto Definition |
| `gD` | Normal | Goto Declaration |
| `gr` | Normal | Goto References |
| `gI` | Normal | Goto Implementation |
| `K` | Normal | Hover Documentation & Type Information |
| `<Space> rn` | Normal | Rename symbol across workspace |
| `<Space> ca` | Normal | Quick Fixes & Code Actions |
| `<Space> d` | Normal | Show line diagnostics popup |
| `[d` / `]d` | Normal | Jump to Previous / Next diagnostic error/warning |
| `<Space> th` | Normal | Toggle Inlay Type Hints |
| `<Space> sn` | Normal | Save file without triggering auto-format |

---

## 🛠️ Auto-Configured Language Servers & Tools

The following language servers, linters, formatters, and debug adapters are automatically managed and synchronized via Mason:

- **Language Servers**: Lua (`lua_ls`), Python (`pyright`, `ruff`), TypeScript / JavaScript (`ts_ls`), Go (`gopls`), Rust (`rust_analyzer`), C / C++ (`clangd`), HTML (`html`), CSS (`cssls`), Tailwind CSS (`tailwindcss`), Vue (`vue_ls`), Emmet (`emmet_language_server`), JSON (`jsonls`), YAML (`yamlls`), Bash (`bashls`), Docker (`dockerls`, `docker_compose_language_service`), Terraform (`terraformls`), SQL (`sqlls`)
- **Formatters & Linters**: `prettier`, `stylua`, `shfmt`, `ruff`, `eslint_d`, `checkmake` (with automatic format-on-save)
- **Debug Adapters**: `js-debug-adapter` (Node.js & Chrome DAP)

---

## 📁 Repository Structure

```text
~/.config/nvim/
├── init.lua                   # Entry point & Lazy.nvim bootstrap
├── lazy-lock.json             # Pinned plugin lockfile
├── install.sh                 # Cross-distribution automated installer script
├── lua/
│   ├── core/
│   │   ├── options.lua        # Editor options & vim settings
│   │   └── keymaps.lua        # VS Code style keymaps & mappings
│   └── plugins/
│       ├── alpha.lua          # Dashboard startup screen
│       ├── autocompletion.lua # nvim-cmp, luasnip & snippet expansion
│       ├── bufferline.lua     # Browser-style buffer tabs
│       ├── code_runner.lua    # Multi-language code runner
│       ├── colortheme.lua     # Nord theme with transparency toggle
│       ├── debugger.lua       # nvim-dap & dap-ui debugging
│       ├── gitsigns.lua       # Git signs in gutter
│       ├── indent-blankline.lua # Indentation guides
│       ├── lsp.lua            # nvim-lspconfig, Mason & tool setup
│       ├── lualine.lua        # Statusline configuration
│       ├── misc.lua           # Utilities (autopairs, which-key, etc.)
│       ├── neotree.lua        # File tree explorer configuration
│       ├── none-ls.lua        # Format-on-save & linters
│       ├── telescope.lua      # Telescope fuzzy finder
│       ├── toggleterm.lua     # Floating terminal configuration
│       └── treesitter.lua     # Syntax highlighting & parsers
└── snippets/                  # Custom VS Code style snippets (React, C++, etc.)
```

---

## 📄 License

This configuration is open-source and released under the [MIT License](LICENSE).
