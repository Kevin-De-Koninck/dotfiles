#!/bin/bash

############################################################################################
# HELPER FUNCTIONS
############################################################################################
# Parse a config.ini file to be more bash friendly.
# The ini file will be transformed where each line wil look like the following:
#     <SECTION_NAME>=<KEY>=<VALUE>
# This way, we can grep values more easily in bash, avoiding the need of specialized tools (extra dependencies)
parse_config_ini () {
  awk '/\[/{prefix=$0; next} $1{print prefix $0}' config.ini | sed -e 's/\[//' -e 's/\]/=/'
}

# Get the content of a certain section in the config.ini file
# Arguments:
#   - $1: Name of the section to be parsed
parse_section_of_config_ini () {
  local SECTION="${1}"
  while read LINE; do
    if [[ ${LINE} = "${SECTION}"* ]]; then
      echo "${LINE}" | sed -e "s/^${SECTION}=//g" -e "s/^#.*//g"
    fi
  done < <(parse_config_ini)
}

# Get the value of a certain KEY in a certain SECTION of the config.ini file
# Arguments:
#   - SECTION: The section in which the key resides
#   - KEY: The key of which the value needs to be retrieved
get_value_from_section_in_config_file () {
  local SECTION="${1}"
  local KEY="${2}"

  while read LINE; do
    if [[ ${LINE} = "${KEY}="* ]]; then
      echo "${LINE}" | cut -d '=' -f 2
    fi
  done < <(parse_section_of_config_ini "${SECTION}")
}

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

# Print a colored header
# Arguments:
#   - MSG: The message
log_header () {
  local SEV="SUCCESS"
  local MSG="$1"
  
  log "${SEV}" "--------------------------------------------------------------------------------------------------"
  log "${SEV}" "${MSG}"
  log "${SEV}" "--------------------------------------------------------------------------------------------------"
}

# Wait for user input
wait_for_keypress () {
  read -p "Press [Enter] key to continue..."
}

############################################################################################
# START
############################################################################################
if [[ "$OSTYPE" != "darwin"* ]]; then
  log "ERROR" "This script can only run on macOS!"
fi

# Save the old location
OLD_DIR="$(pwd)"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

############################################################################################
# SSH
############################################################################################

log_header "SSH"

if ! [ -f ~/.ssh/github_rsa.pub ]; then
  log "INFO" "Creating a secure SSH key for GitHub."
  ssh-keygen -t rsa -b 4096 -a 100 -N "" -f github_rsa -C "Key used for GitHub, see https://github.com/account/ssh"
  mv github_rsa github_rsa.pub ~/.ssh
  log "DEBUG" "Add the key '~/.ssh/github_rsa.pub' to GitHub (https://github.com/account/ssh)."
  log "DEBUG" "Opening https://github.com/account/ssh in Safari now."
  open https://github.com/account/ssh
  wait_for_keypress
fi

############################################################################################
# XCODE AND DEVELOPER TOOLS
############################################################################################

log_header "XCODE, BREW AND DEV TOOLS"

log "INFO" "Installing xCode and developer tools."
xcode-select --install 2> /dev/null


############################################################################################
# BREW
############################################################################################

log_header "BREW"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
  log "INFO" "Installing homebrew."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

log "INFO" "Updating homebrew."
brew update

log "INFO" "Upgrade any already-installed formulae."
brew upgrade

log "INFO" "Installing brew apps."
while read LINE; do
  LINE=$(echo "${LINE}" | cut -d '=' -f 2)
  if [[ ${LINE} != "" ]]; then
    log "DEBUG" "Installing brew app: ${LINE}."
    brew install ${LINE}
  fi
done < <(parse_section_of_config_ini "BREW")

# Do some symbolic linking
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum" 2> /dev/null

############################################################################################
# BREW CASK
############################################################################################

log_header "BREW CASK"

# Install apps to /Applications (The default is: /Users/$user/Applications)
log "INFO" "Installing brew cask apps."
while read LINE; do
  LINE=$(echo "${LINE}" | cut -d '=' -f 2)
  if [[ ${LINE} != "" ]]; then
    log "DEBUG" "Installing brew cask app: ${LINE}."
    brew cask install --appdir="/Applications" ${LINE}
  fi
done < <(parse_section_of_config_ini "BREW_CASK")


############################################################################################
# APPSTORE APPS
############################################################################################

log_header "APPSTORE APPS"

while read LINE; do
  log "DEBUG" "Please install the app on the page that will be opened in Safari."
  open ${LINE}
  wait_for_keypress
done < <(parse_section_of_config_ini "APPSTORE_APPS")

############################################################################################
# GIT
############################################################################################

log_header "GIT"

log "INFO" "Setting the git config"
git config --global user.name "$(get_value_from_section_in_config_file 'GIT' 'NAME')"
git config --global user.email "$(get_value_from_section_in_config_file 'GIT' 'EMAIL')"


############################################################################################
# ZSH
############################################################################################

log_header "ZSH"

log "INFO" "Setting ZSH as default shell."
chsh -s /bin/zsh


############################################################################################
# QUICKLOOK PLUGINS
############################################################################################

log_header "QUICKLOOK PLUGINS"

log "INFO" "Installing quicklook plugins."
while read LINE; do
  log "DEBUG" "Installing plugin: ${LINE}."
  brew cask install --appdir="/Applications" "${LINE}"
done < <(parse_section_of_config_ini "QUICKLOOK_PLUGINS")
xattr -d -r com.apple.quarantine ~/Library/QuickLook


############################################################################################
# MAC SETTINGS
############################################################################################

log_header "MAC SETTINGS"
log "DEBUG" "Source: https://github.com/herrbischoff/awesome-macos-command-line"


# Reduce transparancy for a darker dark mode
defaults write com.apple.universalaccess reduceTransparency -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Safari settings."

log "DEBUG" "Enable develop menu and web inspector."
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write -g WebKitDeveloperExtras -bool true

log "DEBUG" "Hiding Safari's bookmarks bar by default."
defaults write com.apple.Safari ShowFavoritesBar -bool false

log "DEBUG" "Hiding Safari's sidebar in Top Sites."
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

log "DEBUG" "Enable Do Not Track."
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

log "DEBUG" "Update extensions automatically."
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

log "DEBUG" "Block pop-up windows."
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

log "DEBUG" "Warn about fraudulent websites."
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

log "DEBUG" "Show the full URL in the address bar (note: this still hides the scheme)."
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying visual settings."

log "DEBUG" "Use Dark mode."
defaults write -g AppleInterfaceStyle -string Dark

# -----------------------------------------------------------------------------------------

log "INFO" "Applying TextEdit settings."

log "DEBUG" "Use Plain Text Mode as Default."
defaults write com.apple.TextEdit RichText -int 0

log "DEBUG" "Open and save files as UTF-8 in TextEdit."
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Disk Utility settings."

log "DEBUG" "Enable the debug menu in Disk Utility."
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Time Machine settings."

log "DEBUG" "Prevent Time Machine from Prompting to Use New Hard Drives as Backup Volume."
sudo defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

log "DEBUG" "Disable local Time Machine backups."
hash tmutil &> /dev/null && sudo tmutil disablelocal

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Activity Monitor settings"


log "DEBUG" "Show the main window when launching Activity Monitor."
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

log "DEBUG" "Visualize CPU usage in the Activity Monitor Dock icon."
defaults write com.apple.ActivityMonitor IconType -int 5

log "DEBUG" "Show all processes in Activity Monitor."
defaults write com.apple.ActivityMonitor ShowCategory -int 0

log "DEBUG" "Sort Activity Monitor results by CPU usage."
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Spaces settings."

log "DEBUG" "Disable Auto Rearrange Spaces Based on Most Recent Use."
defaults write com.apple.dock mru-spaces -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Dock settings."

log "DEBUG" "Set a default size."
defaults write com.apple.dock tilesize -int 30

log "DEBUG" "Enable scroll gestures."
defaults write com.apple.dock scroll-to-open -bool true 

log "DEBUG" "Do not show recent apps."
defaults write com.apple.dock show-recents -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying SSD disk settings."

log "DEBUG" "Disable Sudden Motion Sensor (Leaving this turned on is useless when you're using SSDs.)."
sudo pmset -a sms 0

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Desktop settings."

log "DEBUG" "Show External Media (External HDs, thumb drives, etc.)."
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

log "DEBUG" "Show Removable Media (CDs, DVDs, iPods, etc.)."
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

log "DEBUG" "Show Network Volumes (AFP, SMB, NFS, WebDAV, etc.)."
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Finder settings."

log "DEBUG" "Show All File Extensions."
defaults write -g AppleShowAllExtensions -bool true

log "DEBUG" "Show Full Path in Finder Title."
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

log "DEBUG" "Toggle Folder Visibility in Finder."
chflags nohidden ~/Library

log "DEBUG" "Smooth scrolling."
defaults write -g NSScrollAnimationEnabled -bool true

log "DEBUG" "Rubberband scrolling."
defaults write -g NSScrollViewRubberbanding -bool true

log "DEBUG" "Expand Save Panel by Default."
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

log "DEBUG" "Show pathbar."
defaults write com.apple.finder ShowPathbar -bool true

log "DEBUG" "Show statusbar."
defaults write com.apple.finder ShowStatusBar -bool true

log "DEBUG" "Set Default Finder Location to Home Folder."
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

log "DEBUG" "Set Sidebar Icon Size (Sets size to 'medium'.)."
defaults write -g NSTableViewDefaultSizeMode -int 2

#log "DEBUG" "Disabling the warning when changing a file extension."
#defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

log "DEBUG" "Use list view in all Finder windows by default."
defaults write com.apple.finder FXPreferredViewStyle Nlsv

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Screenshot settings."

log "DEBUG" "Setting screenshots location to ~/Desktop."
defaults write com.apple.screencapture location -string "$HOME/Desktop"

log "DEBUG" "Setting screenshot format to PNG."
defaults write com.apple.screencapture type -string "png"
# -----------------------------------------------------------------------------------------

log "INFO" "Applying Desktop settings."

log "DEBUG" "Enabling snap-to-grid for icons on the desktop and in other icon views."
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Metadata Files settings."

log "DEBUG" "Disable Creation of Metadata Files on Network Volumes (Avoids creation of .DS_Store and AppleDouble files.)."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

log "DEBUG" "Disable Creation of Metadata Files on USB Volumes (Avoids creation of .DS_Store and AppleDouble files.)."
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Font settings."

log "DEBUG" "Get SF Mono Fonts."
cp -v /System/Applications/Utilities/Terminal.app/Contents/Resources/Fonts/SFMono-* ~/Library/Fonts 2> /dev/null
cp -v /Applications/Utilities/Terminal.app/Contents/Resources/Fonts/SFMono-* ~/Library/Fonts 2> /dev/null
cp -v /Applications/Xcode-beta.app/Contents/SharedFrameworks/DVTKit.framework/Versions/A/Resources/Fonts/SFMono-* ~/Library/Fonts 2> /dev/null

log "DEBUG" "Disable smart quotes and smart dashes as they are annoying when typing code."
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

log "DEBUG" "Disable automatic period substitution as it’s annoying when typing code."
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

log "DEBUG" "Disable automatic capitalization as it’s annoying when typing code"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Power Management settings."

log "DEBUG" "Chime When Charging (Play iOS charging sound when MagSafe is connected.)"
defaults write com.apple.PowerChime ChimeOnAllHardware -bool true
open /System/Library/CoreServices/PowerChime.app

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Startup settings."

log "DEBUG" "Enable startup chime."
sudo nvram StartupMute=%00

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Printing settings."

log "DEBUG" "Expand Print Panel by Default."
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

log "DEBUG" "Quit Printer App After Print Jobs Complete."
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Security settings."

log "DEBUG" "Enable application firewall."
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

log "DEBUG" "Disabling OS X Gate Keeper (You'll be able to install any app you want from here on, not just Mac App Store apps)."
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying search settings."

log "DEBUG" "Build Locate Database."
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Filevault settings."

log "DEBUG" "Enable Filevault."
sudo fdesetup enable

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Memory Management settings."

log "DEBUG" "Purge memory cache."
NSQuitAlwaysKeepsWindowssudo purge

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Software Update and Mac App Store settings."

log "DEBUG" "Set Software Update Check Interval (Set to check daily instead of weekly.)."
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

log "DEBUG" "Enable the WebKit Developer Tools in the Mac App Store."
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

log "DEBUG" "Enable Debug Menu in the Mac App Store."
defaults write com.apple.appstore ShowDebugMenu -bool true

log "DEBUG" "Enable the automatic update check."
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

log "DEBUG" "Download newly available updates in background."
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

log "DEBUG" "Install System data files & security updates."
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

log "DEBUG" "Automatically download apps purchased on other Macs."
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

log "DEBUG" "Turn on app auto-update."
defaults write com.apple.commerce AutoUpdate -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Photos settings."

log "DEBUG" "Prevent Photos from opening automatically when devices are plugged in."
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Date and Time settings."

log "DEBUG" "Set timezone."
sudo systemsetup -settimezone Europe/Brussels > /dev/null

log "DEBUG" "Set language and text formats"
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

log "DEBUG" "Set Clock Using Network Time."
sudo systemsetup setusingnetworktime on

log "DEBUG" "Date and time format."
sudo defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm a"

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Mouse and Trackpad settings."

log "DEBUG" "Setting trackpad & mouse speed to a reasonable number."
defaults write -g com.apple.trackpad.scaling 2.5
defaults write -g com.apple.mouse.scaling 2.5

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Mail app settings."

log "DEBUG" "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'."
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Terminal app settings."

log "DEBUG" "Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default."
defaults write com.apple.terminal StringEncodings -array 4
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

log "DEBUG" "Disable the annoying line marks."
defaults write com.apple.Terminal ShowLineMarks -int 0

log "DEBUG" "# Enable Secure Keyboard Entry in Terminal."
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Chrome app settings."

log "DEBUG" "Disable annoying backswipe in Chrome."
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying Transmission app settings."

log "DEBUG" "Trash original torrent files."
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

log "DEBUG" "Hide the donate message."
defaults write org.m0k.transmission WarningDonate -bool false

log "DEBUG" "Hide the legal disclaimer."
defaults write org.m0k.transmission WarningLegal -bool false

# -----------------------------------------------------------------------------------------

log "INFO" "Applying other misc settings."

log "DEBUG" "Disabling system-wide resume."
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

log "DEBUG" "Disabling automatic termination of inactive apps."
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

log "DEBUG" "Allow text selection in Quick Look."
defaults write com.apple.finder QLEnableTextSelection -bool TRUE

############################################################################################
# CLEAN
############################################################################################

log_header "CLEANING"

log "INFO" "Cleaning brew and brew cask."
brew cleanup

log "INFO" "Applying all settings immediatly."
log "DEBUG" "Restarting SystemUIServer."
sudo killall SystemUIServer
log "DEBUG" "Restarting Finder."
sudo killall Finder
log "DEBUG" "Restarting Dock."
sudo killall Dock


############################################################################################
# DONE
############################################################################################

log_header "DONE!"
log "INFO" "Please restart your mac first."

cd "${OLD_DIR}"
