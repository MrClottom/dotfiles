# very nice comment

echo "installing setup"

sudo apt install -y apt-transport-https curl gnupg

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install -y brave-browser

echo "Installing zsh..."

sudo apt install -y zsh git konsole npm

curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install-zsh.sh

chmod +x install-zsh.sh

./install-zsh.sh

rm install-zsh.sh

git clone https://github.com/MrClottom/dotfiles.git dotfiles.tmp
mv dotfiles.tmp/.git .
rm -r dotfiles.tmp
git reset --hard HEAD

sudo apt install -y autojump

git clone https://github.com/ryanoasis/nerd-fonts.git ~/Downloads/nerd-fonts
./Downloads/nerd-fonts/install.sh FiraCode
sudo rm -r ./Downloads/nerd-fonts

sudo apt install -y neovim silversearcher-ag fzy
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | zsh

sudo add-apt-repository -y ppa:regolith-linux/release
sudo apt install -y regolith-desktop i3blocks

echo "please run \"nvm install node\" to install nodejs"
