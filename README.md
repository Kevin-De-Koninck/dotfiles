# dotfiles

## About

This repo contains all my dotfiles that I use to setup any macos or linux based system.
The bootstrap script does the following:

- Installs diff-highlight plugin for git
- Installs oh-my-zsh
- Installs powerlevel10k zsh theme
- Installs Powerline fonts
- Installs oh-my-zsh plugins
    * zsh-syntax-highlighting
- Copies all dotfiles to the user's home directory

This script is destructive. Backup files of existing files are not created...

**Note:** These files are OS aware. Supported OS'es are any linux based OS and macOS.

## Usage

``` bash
# checkout repo
cd /tmp
git clone https://github.com/Kevin-De-Koninck/dotfiles.git
cd dotfiles

# Initialise all dotfiles
chmod +x init_dotfiles.sh
./init_dotfiles.sh

# Remove repo
cd /tmp
rm -rf macOS-setup-script
```

# Initialise macOS

This repo also contains a script that initialises a new macOS. The script does the following:
- Generate an SSH key for GitHub
- Install Xcode and developer tools
- Install `brew` and all brew packages specified in `config.ini`
- Install `brew cask` and all apps specified in `config.ini`
- Open the app store pages for installing all app store apps specified in `config.ini`
- Install Oh-my-zsh and make `zsh` the default shell
- Install quicklook plugins specified in `config.ini`
- Apply a set of custom mac settings (tailored to my own needs)

I do not backup user preferences because I want it to be as clean as possible. Backing up those files might result in backed up files of which the programs have been deleted, resulting in a dirty system.

You might want to check out:
- `~/.ssh`
- `~/Library/Application Support/com.apple.sharedfilelist`
- `/Library/Preferences`
- `~/Library/Preferences`
- `/Library/LaunchAgents`
- `~/Library/LaunchAgents`
- `/Library/LaunchDaemons`
- `~/Library/Containers`

## Usage

``` bash
# checkout repo
cd /tmp
git clone https://github.com/Kevin-De-Koninck/dotfiles.git
cd dotfiles

# Initialise macOS
chmod +x init_macos.sh
./init_macos.sh

# Initialise all dotfiles
chmod +x init_dotfiles.sh
./init_dotfiles.sh

# Remove repo
cd /tmp
rm -rf macOS-setup-script
```
**Note:** See config.ini to add more brew, brew cask, ... options.

