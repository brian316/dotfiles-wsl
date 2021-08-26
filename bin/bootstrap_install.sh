#!/bin/bash

# colors
txtgrn='\e[0;32m' # Green
txtred='\e[0;31m' # Red
txtblu='\e[0;34m' # Blue
txtcyn='\e[0;36m' # Cyan
txtylw='\e[0;33m' # Yellow
txtrst='\e[0m' # Text Reset

echo -e "Your current shell: $txtcyn $SHELL $txtrst"

# Install Homebrew package manager
if  ! command -v brew &> /dev/null; then
    echo -e " >$txtgrn Installing Homebrew package manager $txtrst"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    . ~/.bashrc

else
    echo -e " >$txtblu Homebrew $txtrst ✔️"
fi

# check if zsh is not the default shell
if [[ "$SHELL" != *"zsh" ]]; then

    # ZSH is already installed, but not set
    if command -v zsh &> /dev/null; then
        echo -e " >$txtgrn Changing shell to ZSH $txtrst"

    # Install ZSH
    else
        echo -e " >$txtgrn Installing ZSH $txtrst"
        brew install zsh
        echo $(which zsh) | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s $(which zsh) $USER
    echo -e " >$txtylw Logout user to set ZSH as new shell and re-run script $txtrst"
    exit
else
    echo -e " >$txtblu ZSH$txtrst ✔️"
fi

# install oh-my-zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo -e " >$txtgrn Installing Oh My ZSH! $txtrst"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo -e " >$txtblu Oh My ZSH!$txtrst ✔️"
fi

######## install homebrew packages ########

# Install Helm
if ! command -v helm &> /dev/null; then
    brew install helm
else
    echo -e " >$txtblu Helm$txtrst ✔️"
fi

# Install nvm and node
if ! command -v node &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh
    source ~/.zshrc
    nvm install node
    nvm alias default node
else
    echo -e " >$txtblu Node$txtrst ✔️"
fi

# Install vscode
if ! command -v code &> /dev/null; then
    if [[ "$(uname -s)" == "Darwin" ]]; then
        brew install --cask visual-studio-code
    fi
    if [[ "$(uname -s)" == "Linux"  && $(command -v dnf) ]]; then
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
        sudo dnf check-update
        sudo dnf install code
    fi
else
    echo -e " >$txtblu Visual Studio Code$txtrst ✔️"
fi

# install Docker
if ! command -v docker &> /dev/null; then
    brew install --cask docker
else
    echo -e " >$txtblu Docker$txtrst ✔️"
fi


######## update dotfiles ########
# if [ -d "./dots" ]; then
#     mkdir -p olddots
#     for dotfile in ls ./dots -f .?*
#     do
#         echo "$dotfile"
#     done
#     # cp "$HOME/"
# else
#     echo "Done ✔️"
# fi
# cp dots/* $HOME
