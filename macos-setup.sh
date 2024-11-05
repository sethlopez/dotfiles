#!/usr/bin/env bash

###
## MACOS BOOTSTRAP
## ---
## Apply my preferred macOS settings and install common programs via Homebrew.
## ---
## References:
##   - https://macos-defaults.com
##   - https://mths.be/macos
###

FONT_RESET="\033[0m"
FONT_BOLD="\033[1m"
FONT_RED="\033[31m"
FONT_GREEN="\033[32m"

function _print {
    echo -e -n "$1 "
}

function _print_result {
    local STATUS=$?
    if [ $STATUS -eq 0 ]; then
        echo -e "${FONT_GREEN}OK${FONT_RESET}"
    else
        echo -e "${FONT_BOLD}${FONT_RED}ERROR=${STATUS}${FONT_RESET}"
    fi
}

_print "Apply macOS preferences? (y/N)"
read -re -n 1 -t 15 MACOS_PREFS_REPLY
if [[ $MACOS_PREFS_REPLY == [yY]* ]]; then
    # ask for the administrator password
    echo "The administrator password is required to change some settings."
    sudo -v
    # keep sudo going until this script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # close system preference panes to prevent overriding changes
    _print "Closing System Preferences panes to prevent overriding changes..."
    osascript -e 'tell application "System Preferences" to quit'
    _print_result

    # ask the user for the computer name and default to the current computer name
    _print "What would you like to name this computer? ($(sudo scutil --get ComputerName))"
    read -re -t 30
    if [[ -z $REPLY ]]; then
        echo "Keeping the current name."
    else
        _print "Updating the computer name to $REPLY..."
        sudo scutil --set ComputerName "$REPLY"
        _print_result
        _print "Updating the hostname to $REPLY..."
        sudo scutil --set HostName "$REPLY"
        _print_result
        _print "Updating the local hostname to $REPLY..."
        sudo scutil --set LocalHostName "$REPLY"
        _print_result
        _print "Updating the NetBIOSName to $REPLY..."
        sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$REPLY"
        _print_result
    fi

    # GENERAL UI/UX
    # set highlight color
    #defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"
    # show scrollbars when scrolling
    _print "Setting scrollbars to show when scrolling..."
    defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"
    _print_result
    # set sidebar icon size to medium
    _print "Setting sidebar icon size to medium..."
    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
    _print_result
    # set standby delay to 24 hours
    _print "Setting standby delay to 24 hours..."
    sudo pmset -a standbydelay 86400
    _print_result
    # don't keep windows on application quit
    _print "Disabling application resume on quit..."
    defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
    _print_result
    # save to disk rather than iCloud by default
    _print "Setting default document save location to disk instead of iCloud..."
    defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    _print_result
    # expand save-file sheets by default
    _print "Setting save-file dialog sheet to expand automatically [1/2]..."
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    _print_result
    _print "Setting save-file dialog sheet to expand automatically [2/2]..."
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    _print_result
    # expand print sheets by default
    _print "Setting print dialog sheet to expand automatically [1/2]..."
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    _print_result
    _print "Setting print dialog sheet to expand automatically [2/2]..."
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    _print_result
    # quit printer app when print jobs complete
    _print "Setting printer app to quit when print jobs are complete..."
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
    _print_result
    # remove duplicates from "open with" menu
    _print "Removing \"Open With\" menu duplicates..."
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
    _print_result
    # disable hibernation to speed up sleep mode
    _print "Disabling hibernation..."
    sudo pmset -a hibernatemode 0
    _print_result
    # remove sleep image file to save disk space
    _print "Removing sleep image file [1/3]..."
    sudo rm /private/var/vm/sleepimage
    _print_result
    _print "Removing sleep image file [2/3]..."
    sudo touch /private/var/vm/sleepimage
    _print_result
    _print "Removing sleep image file [3/3]..."
    sudo chflags uchg /private/var/vm/sleepimage
    _print_result
    # include date in screenshot filenames
    _print "Setting screenshot filenames to include the date..."
    defaults write com.apple.screencapture include-date -bool true
    _print_result
    # set screenshot format to PNG
    _print "Setting screenshot format to PNG..."
    defaults write com.apple.screencapture type -string "png"
    _print_result
    # disable screenshot shadow
    _print "Disabling screenshot shadows..."
    defaults write com.apple.screencapture disable-shadow -bool true
    _print_result
    # set screenshot save location
    _print "Setting screenshot save location to ~/Pictures..."
    defaults write com.apple.screencapture location -string "$HOME/Pictures"
    _print_result
    # disable dashboard
    _print "Disabling dashboard..."
    defaults write com.apple.dashboard mcx-disabled -bool true
    _print_result
    # hide dashboard as a space
    _print "Hiding dashboard as a space..."
    defaults write com.apple.dock dashboard-in-overlay -bool true
    _print_result
    # disable automatic rearrangement of spaces based on most recent use
    _print "Disabling automatic most recently used rearrangement of spaces..."
    defaults write com.apple.dock mru-spaces -bool false
    _print_result
    # disable launchpad gesture (pinch with thumb and three fingers)
    _print "Disabling Launchpad gesture..."
    defaults write com.apple.dock showLaunchpadGestureEnabled -int 0
    _print_result
    # reset launchpad
    _print "Resetting Launchpad..."
    find "$HOME/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete
    _print_result
    # set hot corners
    #_print "Set bottom-left hot corner to put the display to sleep [1/2]..."
    #defaults write com.apple.dock wvous-bl-corner -int 10
    #_print_result
    #_print "Set bottom-left hot corner to put the display to sleep [2/2]..."
    #defaults write com.apple.dock wvous-bl-modifier -int 0
    #_print_result
    _print "Enabling window tiling when dragging to the edge of the screen..."
    defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool true
    _print_result
    _print "Enabling window tiling while dragging and holding the option key..."
    defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool true
    _print_result
    _print "Disabling window tiling margins..."
    defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
    _print_result

    # SECURITY
    # disable confirmation dialog for downloaded apps
    _print "Disabling app quarantine confirmation dialog for downloaded applications..."
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    _print_result
    # require password immediately after sleep or screen saver
    _print "Enabling ask for password immediately after sleep or screen saver [1/2]..."
    defaults write com.apple.screensaver askForPassword -int 1
    _print_result
    _print "Enabling ask for password immediately after sleep or screen saver [2/2]..."
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    _print_result

    # TRACKPAD
    # disable natural scroll
    _print "Disabling natural scroll..."
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    _print_result
    # enable tap to click
    _print "Enabling tap to click [1/4]..."
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    _print_result
    _print "Enabling tap to click [2/4]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    _print_result
    _print "Enabling tap to click [3/4]..."
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    _print_result
    _print "Enabling tap to click [4/4]..."
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    _print_result
    # enable three-finger drag
    _print "Enabling three-finger drag [1/6]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    _print_result
    _print "Enabling three-finger drag [2/6]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -bool false
    _print_result
    _print "Enabling three-finger drag [3/6]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -bool false
    _print_result
    _print "Enabling three-finger drag [4/6]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
    _print_result
    _print "Enabling three-finger drag [5/6]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -bool false
    _print_result
    _print "Enabling three-finger drag [6/6]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -bool false
    _print_result
    # disable lookup gesture (tap with three fingers)
    _print "Disabling Lookup gesture [1/2]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -bool false
    _print_result
    _print "Disabling Lookup gesture [2/2]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -bool false
    _print_result
    # disable smart zoom (double-tap with two fingers)
    _print "Disabling smart zoom gesture [1/2]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool false
    _print_result
    _print "Disabling smart zoom gesture [2/2]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool false
    _print_result
    # disable notification center gesture
    _print "Disabling notification center gesture [1/2]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -bool false
    _print_result
    _print "Disabling notification center gesture [2/2]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -bool false
    _print_result
    # disable show desktop gesture
    _print "Disabling show desktop gesture [1/5]..."
    defaults write com.apple.dock showDesktopGestureEnabled -bool false
    _print_result
    _print "Disabling show desktop gesture [2/5]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -bool false
    _print_result
    _print "Disabling show desktop gesture [3/5]..."
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -bool false
    _print_result
    _print "Disabling show desktop gesture [4/5]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -bool false
    _print_result
    _print "Disabling show desktop gesture [5/5]..."
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -bool false
    _print_result

    # KEYBOARD
    # enable full keyboard access for system controls
    _print "Enabling keyboard access for system controls..."
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    _print_result
    # disable press-and-hold in favor of key repeat
    _print "Disabling press-and-hold in favor of key repeat..."
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    _print_result
    # set fast key repeat and low repeat delay
    _print "Setting key repeat to fastest speed..."
    defaults write NSGlobalDomain KeyRepeat -int 1
    _print_result
    _print "Setting key repeat to a short duration..."
    defaults write NSGlobalDomain InitialKeyRepeat -int 10
    _print_result
    # disable automatic capitalization
    _print "Disabling automatic capitalization..."
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    _print_result
    # disable smart dashes
    _print "Disabling automatic dash substitution..."
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    _print_result
    # disable period substitution
    _print "Disabling automatic period substitution..."
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
    _print_result
    # disable quote substitution
    _print "Disabling automatic quote substitution..."
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    _print_result
    # disable spelling correction
    _print "Disabling automatic spelling correction..."
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    _print_result

    # AUDIO
    # increase sound quality for bluetooth headphones
    _print "Increasing sound quality for Bluetooth audio devices..."
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
    _print_result

    # STATUS BAR
    # set clock options
    _print "Displaying AM/PM, Day of week, and seconds in the status bar clock [1/4]..."
    defaults write com.apple.menuextra.clock ShowAMPM -bool true
    _print_result
    _print "Displaying AM/PM, Day of week, and seconds in the status bar clock [2/4]..."
    defaults write com.apple.menuextra.clock ShowDate -int 0
    _print_result
    _print "Displaying AM/PM, Day of week, and seconds in the status bar clock [3/4]..."
    defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
    _print_result
    _print "Displaying AM/PM, Day of week, and seconds in the status bar clock [4/4]..."
    defaults write com.apple.menuextra.clock ShowSeconds -bool true
    _print_result

    # DOCK
    # remove all pinned applications from dock
    _print "Removing all pinned applications from the dock [1/2]..."
    defaults write com.apple.dock persistent-apps -array
    _print_result
    _print "Removing all pinned applications from the dock [2/2]..."
    defaults write com.apple.dock persistent-others -array
    _print_result
    # hide recent applications
    _print "Removing recent applications from the dock [1/2]..."
    defaults write com.apple.dock show-recents -bool false
    _print_result
    _print "Removing recent applications from the dock [2/2]..."
    defaults write com.apple.dock recent-apps -array
    _print_result
    # show only open applications in the dock
    _print "Showing only open applications in the dock..."
    defaults write com.apple.dock static-only -bool true
    _print_result
    # set dock icon size to 48 pixels
    _print "Setting dock icon size to 48px..."
    defaults write com.apple.dock tilesize -int 48
    _print_result
    # turn off magnification
    _print "Turning off magnification..."
    defaults write com.apple.dock magnification -bool false
    _print_result
    # auto-hide dock
    _print "Enabling dock auto-hide..."
    defaults write com.apple.dock autohide -bool true
    _print_result

    # FINDER
    # set user directory as default location for new finder windows
    _print "Setting Finder default location to home directory [1/2]..."
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    _print_result
    _print "Setting Finder default location to home directory [2/2]..."
    defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"
    _print_result
    # set default finder view to column view (options: "Nlsv", "icnv", "clmv", "Flwv")
    _print "Setting Finder default view to columns..."
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
    _print_result
    # show filename extensions
    _print "Showing filename extensions in Finder..."
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    _print_result
    # disable change filename extension confirmation dialog
    _print "Disabling confirmation dialog when changing filename extensions in Finder..."
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    _print_result
    # show the path bar
    _print "Showing path bar in Finder..."
    defaults write com.apple.finder ShowPathbar -bool true
    _print_result
    # keep folders on top when sorting by name
    _print "Sorting folders first in Finder..."
    defaults write com.apple.finder _FXSortFoldersFirst -bool true
    _print_result
    # open folders in a new window
    _print "Disabling Finder tabs..."
    defaults write com.apple.finder FinderSpawnTab -bool false
    _print_result
    # disable .DS_Store creation for external storage devices
    _print "Disabling .DS_Store creation for external storage devices [1/2]..."
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    _print_result
    _print "Disabling .DS_Store creation for external storage devices [2/2]..."
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    _print_result
    # hide desktop icons for storage devices
    _print "Disabling Desktop icons for storage devices [1/4]..."
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
    _print_result
    _print "Disabling Desktop icons for storage devices [2/4]..."
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
    _print_result
    _print "Disabling Desktop icons for storage devices [3/4]..."
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
    _print_result
    _print "Disabling Desktop icons for storage devices [4/4]..."
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
    _print_result
    # Hide recent tags
    _print "Hiding recent tags in Finder..."
    defaults write com.apple.finder ShowRecentTags -bool false
    _print_result
    # hide all desktop icons
    _print "Disabling all Desktop icons..."
    defaults write com.apple.finder CreateDesktop -bool false
    _print_result
    # disable empty trash confirmation dialog
    _print "Disabling confirmation dialog when emptying trash..."
    defaults write com.apple.finder WarnOnEmptyTrash -bool false
    _print_result
    # show the ~/Library directory
    _print "Showing the ~/Library directory..."
    chflags nohidden ~/Library
    _print_result

    # SPOTLIGHT
    # change indexing order and disable some search results
    _print "Changing Spotlight indexing order and disabling some search results [1/4]..."
    defaults write com.apple.spotlight orderedItems -array \
        '{"enabled" = 1;"name" = "APPLICATIONS";}' \
        '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
        '{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
        '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
        '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
        '{"enabled" = 1;"name" = "DIRECTORIES";}' \
        '{"enabled" = 1;"name" = "DOCUMENTS";}' \
        '{"enabled" = 1;"name" = "IMAGES";}' \
        '{"enabled" = 1;"name" = "MOVIES";}' \
        '{"enabled" = 1;"name" = "MUSIC";}' \
        '{"enabled" = 1;"name" = "PDF";}' \
        '{"enabled" = 1;"name" = "SPREADSHEETS";}' \
        '{"enabled" = 1;"name" = "PRESENTATIONS";}' \
        '{"enabled" = 1;"name" = "FONTS";}' \
        '{"enabled" = 0;"name" = "BOOKMARKS";}' \
        '{"enabled" = 0;"name" = "CONTACT";}' \
        '{"enabled" = 0;"name" = "EVENT_TODO";}' \
        '{"enabled" = 0;"name" = "MENU_OTHER";}' \
        '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
        '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
        '{"enabled" = 0;"name" = "MESSAGES";}' \
        '{"enabled" = 0;"name" = "SOURCE";}'
    _print_result
    # make sure indexing is enabled for the main volume
    _print "Changing Spotlight indexing order and disabling some search results [3/4]..."
    sudo mdutil -i on / > /dev/null
    _print_result
    # rebuild the index from scratch
    _print "Changing Spotlight indexing order and disabling some search results [4/4]..."
    sudo mdutil -E / > /dev/null
    _print_result

    # ACTIVITY MONITOR
    # show the main window when launching activity monitor
    _print "Setting Activity Monitor to show main window when launched..."
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
    _print_result
    # show CPU usage in activity monitor dock icon
    _print "Setting Activity Monitor to show CPU usage in dock icon..."
    defaults write com.apple.ActivityMonitor IconType -int 5
    _print_result
    # show all processes in activity monitor
    _print "Setting Activity Monitor to show all processes..."
    defaults write com.apple.ActivityMonitor ShowCategory -int 0
    _print_result
    # sort activity monitor results by CPU usage
    _print "Setting Activity Monitor to sort results by CPU usage [1/2]..."
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
    _print_result
    _print "Setting Activity Monitor to sort results by CPU usage [2/2]..."
    defaults write com.apple.ActivityMonitor SortDirection -int 0
    _print_result

    # SYSTEM UPDATES
    # enable automatic update check
    _print "Enabling automatic update check..."
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
    _print_result
    # check for software updates daily, not weekly
    _print "Setting software update check schedule to daily..."
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
    _print_result
    # download newly available updates in background
    _print "Setting software updates to download in the background..."
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
    _print_result
    # install system data files and security updates
    _print "Setting critical software updates to install automatically..."
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
    _print_result
    # enable automatic update installation
    _print "Setting normal software updates to install automatically..."
    defaults write com.apple.commerce AutoUpdate -bool true
    _print_result

    for app in \
    "Activity Monitor" \
    "cfprefsd" \
    "Dock" \
    "Finder" \
    "SystemUIServer"; do
        killall "${app}" &>/dev/null
    done

    echo "Preferences applied."
    echo "Some changes may require a reboot to take effect."
fi

_print "Install Xcode command line tools? (y/N)"
read -re -n 1 -t 15 XCODE_CLI_TOOLS_REPLY
if [[ $XCODE_CLI_TOOLS_REPLY == [yY]* ]]; then
    xcode-select --install
fi

# if homebrew isn't available, ask the user if they want to install it
if ! command -v brew > /dev/null 2>&1; then
    _print "Install Homebrew? (y/N)"
    read -re -n 1 -t 15 HOMEBREW_REPLY
    # install if the user replied y/Y or accepted the default (empty response)
    if [[ $HOMEBREW_REPLY == [yY]* ]]; then
        _print "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        _print_result
    fi
fi

# if homebrew is available, ask the user if they want to install from the Brewfile
if command -v brew > /dev/null 2>&1; then
    _print "Install/Upgrade applications in Brewfile via Homebrew? (y/N)"
    read -re -n 1 -t 15 BREWFILE_REPLY
    # install if the user replied y/Y or accepted the default (empty response)
    if [[ $BREWFILE_REPLY == [yY]* ]]; then
        _print "Installing/Upgrading applications in Brewfile via Homebrew..."
        brew bundle --file="./Brewfile"
        _print_result
    fi
fi

echo "Done."
