# Config Files Setup Guide

A collection of shell configuration files for a modern, productive terminal experience. This repository contains [Zsh](https://www.zsh.org/) configuration with [Zinit](https://github.com/zdharma-continuum/zinit) plugin manager and [Fastfetch](https://github.com/fastfetch-cli/fastfetch) system information display. Created by og [GeneCodeSavvy](https://github.com/GeneCodeSavvy) & enhanced by [Ramxcodes](https://github.com/ramxcodes).

## Preview
![Terminal Preview](/terminal.png)

Btw i use NVIM & Ghostty.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [macOS](#macos)
  - [Linux](#linux)
  - [Windows](#windows)
- [Configuration](#configuration)
  - [Zsh Configuration](#zsh-configuration)
  - [Fastfetch Configuration](#fastfetch-configuration)
- [Features](#features)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before installing, ensure you have:

- **Git** - For cloning repositories and plugin management
- **Zsh** - Shell (usually pre-installed on macOS and most Linux distributions)
- **curl** or **wget** - For downloading installation scripts

### Optional but Recommended Tools

The configuration integrates with these tools (they'll work without them, but features will be limited):

- **Starship** - Cross-shell prompt
- **FZF** - Fuzzy finder
- **Zoxide** - Smart directory jumper
- **eza** - Modern `ls` replacement
- **fd** - Fast `find` replacement
- **Bun** - JavaScript runtime

## Installation

### macOS

#### 1. Install Zsh (if not already installed)

Zsh comes pre-installed on macOS. Verify with:

```bash
zsh --version
```

If not installed, install via Homebrew:

```bash
brew install zsh
```

#### 2. Install Oh My Zsh (Optional - This config uses Zinit)

**Note:** This configuration uses **Zinit** instead of Oh My Zsh, but if you want Oh My Zsh as a base, you can install it:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**However, this config will automatically install Zinit**, so Oh My Zsh is optional.

#### 3. Install Fastfetch

Using Homebrew:

```bash
brew install fastfetch
```

Or using MacPorts:

```bash
sudo port install fastfetch
```

Or build from source:

```bash
git clone https://github.com/fastfetch-cli/fastfetch.git
cd fastfetch
mkdir build && cd build
cmake ..
cmake --build . -j
sudo cmake --install .
```

#### 4. Install Configuration Files

```bash
# Clone or navigate to this repository
cd /path/to/config

# Backup existing config (if any)
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

# Copy zsh config
cp "zsh config/.zshrc" ~/.zshrc

# Create fastfetch config directory
mkdir -p ~/.config/fastfetch

# Copy fastfetch config
cp "fast fetch config/config.jsonc" ~/.config/fastfetch/config.jsonc
```

#### 5. Make Zsh Your Default Shell

```bash
# Add zsh to allowed shells
echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells

# Change default shell
chsh -s /opt/homebrew/bin/zsh
```

#### 6. Start a New Terminal Session

Close and reopen your terminal, or run:

```bash
exec zsh
```

---

### Linux

#### 1. Install Zsh

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install zsh git curl
```

**Fedora/RHEL/CentOS:**

```bash
sudo dnf install zsh git curl
```

**Arch Linux:**

```bash
sudo pacman -S zsh git curl
```

**openSUSE:**

```bash
sudo zypper install zsh git curl
```

#### 2. Install Oh My Zsh (Optional)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

**Note:** This config uses Zinit, which will auto-install on first run.

#### 3. Install Fastfetch

**Ubuntu/Debian (using apt):**

```bash
sudo apt install fastfetch
```

**Fedora/RHEL/CentOS:**

```bash
sudo dnf install fastfetch
```

**Arch Linux (AUR):**

```bash
yay -S fastfetch
# or
paru -S fastfetch
```

**Build from source:**

```bash
git clone https://github.com/fastfetch-cli/fastfetch.git
cd fastfetch
mkdir build && cd build
cmake ..
cmake --build . -j
sudo cmake --install .
```

#### 4. Install Configuration Files

```bash
# Clone or navigate to this repository
cd /path/to/config

# Backup existing config (if any)
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

# Copy zsh config
cp "zsh config/.zshrc" ~/.zshrc

# Create fastfetch config directory
mkdir -p ~/.config/fastfetch

# Copy fastfetch config
cp "fast fetch config/config.jsonc" ~/.config/fastfetch/config.jsonc
```

#### 5. Make Zsh Your Default Shell

```bash
# Verify zsh is in /etc/shells
grep -q /usr/bin/zsh /etc/shells || echo /usr/bin/zsh | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which zsh)
```

#### 6. Start a New Terminal Session

```bash
exec zsh
```

---

### Windows

#### Option 1: WSL (Windows Subsystem for Linux) - Recommended

1. **Install WSL:**

   Open PowerShell as Administrator and run:

   ```powershell
   wsl --install
   ```

   Or for a specific distribution:

   ```powershell
   wsl --install -d Ubuntu
   ```

2. **Follow Linux installation steps** above within your WSL distribution.

3. **Install Windows Terminal** (optional but recommended):

   ```powershell
   winget install Microsoft.WindowsTerminal
   ```

#### Option 2: Git Bash

1. **Install Git for Windows** (includes Git Bash):

   - Download from: https://git-scm.com/download/win
   - During installation, ensure "Git Bash Here" is enabled

2. **Install Zsh for Git Bash:**

   ```bash
   # In Git Bash
   pacman -S zsh
   ```

3. **Install Fastfetch:**

   ```bash
   # Build from source (requires CMake and a C compiler)
   git clone https://github.com/fastfetch-cli/fastfetch.git
   cd fastfetch
   mkdir build && cd build
   cmake ..
   cmake --build . -j
   ```

4. **Install Configuration Files:**

   ```bash
   # Navigate to config directory
   cd /path/to/config

   # Backup existing config
   [ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

   # Copy configs
   cp "zsh config/.zshrc" ~/.zshrc
   mkdir -p ~/.config/fastfetch
   cp "fast fetch config/config.jsonc" ~/.config/fastfetch/config.jsonc
   ```

#### Option 3: MSYS2

1. **Install MSYS2:**

   - Download from: https://www.msys2.org/

2. **Install Zsh and Fastfetch:**

   ```bash
   pacman -S zsh fastfetch git curl
   ```

3. **Follow the configuration steps** from Option 2.

---

## Configuration

### Zsh Configuration

The Zsh configuration includes:

- **Zinit Plugin Manager** - Automatically installed on first run
- **Syntax Highlighting** - Real-time command syntax highlighting
- **Autosuggestions** - Suggests commands based on history
- **FZF Tab Completion** - Fuzzy tab completion
- **History Substring Search** - Search history with arrow keys
- **Auto-notify** - Notifications for long-running commands
- **You Should Use** - Reminds you about available aliases
- **Oh My Zsh Snippets** - Useful plugins (git, sudo, extract, etc.)

#### Customization

Edit `~/.zshrc` to customize:

- **Target Date Countdown:** Change the date in the `remaining_days` function call (line 431)
- **Aliases:** Modify the aliases section (lines 367-417)
- **Plugins:** Add or remove Zinit plugins (lines 69-102)
- **Local Config:** Create `~/.zshrc.local` for machine-specific settings

**After making any changes, reload your configuration:**

```bash
source ~/.zshrc
```

Or use the built-in alias:

```bash
reload
```

**Note:** Always run `source ~/.zshrc` after:

- Adding or removing plugins
- Modifying aliases or functions
- Changing environment variables
- Removing configuration lines
- When configuration changes don't seem to take effect

### Fastfetch Configuration

The Fastfetch config displays system information on terminal startup.

#### Customization

Edit `~/.config/fastfetch/config.jsonc`:

1. **Replace `{YOUR USERNAME}`** with your actual username in:

   - Line 5: Logo source path
   - Line 20: Title format

2. **Custom Logo (Optional):**

   - Place your logo at `~/.config/fastfetch/yourlogo.png`
   - Adjust width, height, and padding as needed

3. **Modules:** Add or remove modules from the `modules` array to customize what information is displayed

4. **Colors:** Change the `display.color` value to match your theme

**Note:** Fastfetch config changes take effect on the next terminal session. No need to reload zsh config for fastfetch changes.

---

## Features

### Included Plugins

- **zsh-syntax-highlighting** - Command syntax highlighting
- **zsh-autosuggestions** - Command autosuggestions
- **zsh-completions** - Additional completions
- **fzf-tab** - Fuzzy tab completion
- **zsh-history-substring-search** - History search
- **zsh-auto-notify** - Long command notifications
- **zsh-you-should-use** - Alias reminders
- **LS_COLORS** - Enhanced directory colors

### Custom Functions

- `remaining_days <YYYY-MM-DD>` - Calculate days until a target date
- `mkcd <directory>` - Create directory and cd into it
- `extract <file>` - Extract various archive formats

### Integrations

- **Starship** - Modern prompt (if installed)
- **FZF** - Fuzzy finder (if installed)
- **Zoxide** - Smart `cd` (if installed)
- **eza** - Enhanced `ls` (if installed)
- **Bun** - JavaScript runtime (if installed)

### Aliases

- `c` / `cls` - Clear screen
- `zshrc` - Edit zsh config
- `reload` - Reload zsh config
- `ll` - Long list with icons
- `lt` - Tree view
- `bro` - Bun run dev
- `gst`, `gco`, `gp`, `gl` - Git shortcuts
- And many more...

---

## Troubleshooting

### Configuration changes not working

If you've made changes to `~/.zshrc` but they're not taking effect:

1. **Reload the configuration:**

   ```bash
   source ~/.zshrc
   ```

2. **If that doesn't work, restart your shell:**

   ```bash
   exec zsh
   ```

3. **Check for errors:**

   ```bash
   zsh -n ~/.zshrc
   ```

4. **Verify the changes were saved:**

   ```bash
   cat ~/.zshrc | grep -A 5 "your_change_here"
   ```

**Common scenarios requiring `source ~/.zshrc`:**

- After adding/removing plugins
- After modifying aliases
- After changing environment variables
- After removing configuration lines
- When new commands aren't recognized
- When aliases don't work

### Zsh not found

**macOS:**

```bash
brew install zsh
```

**Linux:**

```bash
# Ubuntu/Debian
sudo apt install zsh

# Fedora
sudo dnf install zsh

# Arch
sudo pacman -S zsh
```

### Zinit installation fails

If Zinit fails to install automatically:

```bash
mkdir -p ~/.local/share/zinit
git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git
```

Then reload your configuration:

```bash
source ~/.zshrc
```

Or restart your terminal.

### Fastfetch not found

1. Verify installation:

   ```bash
   which fastfetch
   fastfetch --version
   ```

2. If not found, install using your package manager (see installation sections above)

3. On Windows, ensure it's in your PATH

### Slow startup time

1. **Disable startup display:**
   Comment out the `fastfetch` and `remaining_days` calls in `~/.zshrc` (lines 425-431)

2. **Reduce plugins:**
   Comment out unused plugins in the plugins section

3. **Use lazy loading:**
   Some tools (like NVM) are already lazy-loaded in this config

**After making changes, reload:**

```bash
source ~/.zshrc
```

### Permission denied errors

```bash
# Make scripts executable
chmod +x ~/.zshrc

# Fix directory permissions
chmod 755 ~/.config
chmod 755 ~/.local/share
```

### Config not loading

1. **Reload the configuration:**

   ```bash
   source ~/.zshrc
   ```

   If this doesn't work, try:

   ```bash
   exec zsh
   ```

2. **Verify zsh is your shell:**

   ```bash
   echo $SHELL
   ```

3. **Check config file location:**

   ```bash
   ls -la ~/.zshrc
   ```

4. **Test config manually:**

   ```bash
   zsh -c "source ~/.zshrc"
   ```

5. **Check for syntax errors:**

   ```bash
   zsh -n ~/.zshrc
   ```

   This will show any syntax errors without executing the file.

### Windows-specific issues

- **WSL:** Ensure you're running commands inside WSL, not PowerShell
- **Git Bash:** Some features may be limited; WSL is recommended
- **Path issues:** Use forward slashes `/` instead of backslashes `\`

---

## Additional Resources

- [Zsh Documentation](https://zsh.sourceforge.io/Doc/)
- [Zinit Documentation](https://zdharma-continuum.github.io/zinit/wiki/)
- [Fastfetch Documentation](https://github.com/fastfetch-cli/fastfetch)
- [Starship Prompt](https://starship.rs/)
- [FZF](https://github.com/junegunn/fzf)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)

## One click installation using brew

```
brew install \
  starship \
  eza \
  fzf \
  zoxide \
  fd \
  fastfetch \
  tree \
  oven-sh/bun/bun \
  node@22 \
  nvm \
  unzip \
  unrar \
  p7zip \
  gzip \
  bzip2 \
  git \
  net-tools

```

---

## Contributing

If you have improvements or find issues, please open an issue or submit a pull request.

**Happy coding! 🚀**
