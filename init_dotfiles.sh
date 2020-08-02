#!/bin/bash

# Globals
SCRIPT_DIR="$(dirname "${0}")"

# Print a colored message
# Arguments:
#   - SEV: The sevirity of the log (DEBUG, INFO, SUCCESS, ERROR)
#   - MSG: The message
log () {
  local SEV="$1"
  local MSG="$2"
  local COLOR=""
  local NC="\033[0m"

  if [[ "${SEV}" == "DEBUG" ]]; then
    COLOR="\033[1;30m"
  fi  
  if [[ "${SEV}" == "INFO" ]]; then
    COLOR="\033[0;36m"
  fi  
  if [[ "${SEV}" == "SUCCESS" ]]; then
    COLOR="\033[0;32m"
  fi  
  if [[ "${SEV}" == "ERROR" ]]; then
    COLOR="\033[0;31m"
  fi  

  echo -e "[$(date "+%Y-%m-%d %H:%M:%S")][${COLOR}${SEV}${NC}] ${COLOR}${MSG}${NC}"

  if [[ ${SEV} == "ERROR" ]]; then
    exit 1
  fi  
}

# Install prerequisites
install_prerequisites () {
  if [ ! -f ~/bin/diff-highlight ]; then
    log "INFO" "Now installing diff-highlight plugin for git: ~/bin/diff-highlight"
    mkdir -p ~/bin
    cd ~/bin
    curl -O https://raw.githubusercontent.com/git/git/fd99e2bda0ca6a361ef03c04d6d7fdc7a9c40b78/contrib/diff-highlight/diff-highlight
    chmod +x diff-highlight
    log "SUCCESS" "diff-highlight plugin was installed in: ~/bin/diff-highlight"
  else
    log "DEBUG" "~/bin/diff-highlight exists, skipping installation..."
  fi

  # Oh my zsh
  if [ ! -d ~/.oh-my-zsh ]; then
    log "INFO" "Now installing oh-my-zsh."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    log "SUCCESS" "oh-my-zsh was installed."

    # Install powerlevel10k theme
    log "INFO" "Now installing oh-my-zsh theme: powerlevel10k."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    log "SUCCESS" "Theme powerlevel10k is now available."

    # Install the fonts with it
    log "INFO" "Now installing the powerline fonts."
    cd /tmp
    git clone https://github.com/powerline/fonts.git --depth=1
    cd /tmp/fonts
    ./install.sh
    cd ${SCRIPT_DIR}
    rm -rf /tmp/fonts
    log "SUCCESS" "The powerline fonts are now available."

    # Install all oh-my-zsh plugins
    log "INFO" "Now installing oh-my-zsh plugin: zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    log "SUCCESS" "oh-my-zsh plugin 'zsh-syntax-highlighting' is now available."
  else
    log "DEBUG" "oh-my-zsh is already installed. Skipping installation..."
  fi
}

copy_dotfiles () {
  log "INFO" "Copying all dotfiles to your home directory."
  cd ${SCRIPT_DIR}
	rsync --exclude ".git/" \
    		--exclude ".DS_Store" \
		    --exclude "init_macos.sh" \
    		--exclude "init_dotfiles.sh" \
		    --exclude "config.ini" \
		    --exclude "README.md" \
    		--exclude "LICENSE" \
		    -avh --no-perms . ~;
  log "SUCCESS" "All dotfiles have been copied to your home directory."
}

# MAIN
log "INFO" "Starting bootstrap."
if [ "$1" == "--force" -o "$1" == "-f" ]; then
  log "INFO" "Argument -f was set, skipping confirmation."
  install_prerequisites
	copy_dotfiles
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo ""
	if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_prerequisites
		copy_dotfiles
  else
    log "DEBUG" "Skipping everything..."
	fi
fi

