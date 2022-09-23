#!/bin/bash

echo "+++++++++++++++++++++++++++++++++"
echo '        Neovim setup'
echo "+++++++++++++++++++++++++++++++++"
if [[ $OSTYPE == linux-gnu* ]]; then
  pkt_install_cmd="sudo apt-get install"
elif [[ $OSTYPE == darwin* ]]; then
  pkt_install_cmd="brew install"
else
  echo "OS not support !"
  exit
fi

if ! [ -x "$(command -v curl)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo '        download curl'
	echo "+++++++++++++++++++++++++++++++++"
	$pkt_install_cmd curl
fi

if ! [ -x "$(command -v nvim)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo '   Install build prerequisites'
	echo "+++++++++++++++++++++++++++++++++"
	$pkt_install_cmd ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
	git clone --depth 1 https://github.com/neovim/neovim -b stable
	cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
	sudo make install
	echo "nvim installed on /usr/local/"
fi

if ! [[ -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo '  download neovim packer manager'
	echo "+++++++++++++++++++++++++++++++++"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

if ! [[ -d  ""${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim" ]]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download plug manager'
	echo "+++++++++++++++++++++++++++++++++"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

if ! [[ -f "/usr/bin/clangd"* ]]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo '  download llvm clangd'
	echo "+++++++++++++++++++++++++++++++++"
	if [[ $OSTYPE == linux-gnu* ]]; then
		$pkt_install_cmd install clangd-12
		echo "Make it the default clangd"
		sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
	elif [[ $OSTYPE == darwin* ]]; then
		$pkt_install_cmd llvm
	fi
fi

if [[ -d "$HOME/.config/nvim" ]]; then
	echo "X Delete nvim folder"
	sudo rm -r $HOME/.config/nvim
fi

git clone git@github.com:yimjiajun/neovim.git $HOME/.config/nvim
	echo "+++++++++++++++++++++++++++++++++"
	echo ' nvim : packer sync and plug install'
	echo "+++++++++++++++++++++++++++++++++"
nvim +PackerSync +PlugInstall

hw_type=$(uname -m)

if ! [ -x "$(command -v tmux)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download tmux'
	echo "+++++++++++++++++++++++++++++++++"
	$pkt_install_cmd tmux
fi

if [ -x "$(command -v tmux)" ]; then

	if ! [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
		echo "+++++++++++++++++++++++++++++++++"
		echo ' download tmux plugins manager'
		echo "+++++++++++++++++++++++++++++++++"
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	fi

	if ! [[ -f "$HOME/.tmux.conf" ]]; then
		echo "set-option -g prefix C-' '
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
# Plugin Themes
set -g @plugin 'seebi/tmux-colors-solarized'
# theme select
set -g @colors-solarized 'dark'
# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'" > ~/.tmux.conf
		# type this in terminal if tmux is already running
		tmux source ~/.tmux.conf

		echo "+++++++++++++++++++++++++++++++++"
		echo '  configuration of tmux'
		echo "+++++++++++++++++++++++++++++++++"
		echo "## Please presss <C-'Whitespace'> + 'I' to reload and install tmux"
	fi
fi

if ! [ -x "$(command -v fzf)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download fzf'
	echo "+++++++++++++++++++++++++++++++++"
	echo '- fuzzy finder'
	$pkt_install_cmd fzf
fi

if ! [ -x "$(command -v rg)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download ripgrep'
	echo "+++++++++++++++++++++++++++++++++"
	echo '- grep speed up'
	$pkt_install_cmd ripgrep
fi

if ! [ -x "$(command -v ranger)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download ranger'
	echo "+++++++++++++++++++++++++++++++++"
	echo '- file manager'
	$pkt_install_cmd ranger
fi

if [[ $OSTYPE == linux-gnu* ]]; then
  if ! [ -x "$(command -v htop)" ]; then
		echo "+++++++++++++++++++++++++++++++++"
		echo ' download htop'
		echo "+++++++++++++++++++++++++++++++++"
		echo '- system monitor'
    $pkt_install_cmd htop
  fi

  if ! [ -x "$(command -v ncdu)" ]; then
		echo "+++++++++++++++++++++++++++++++++"
		echo ' download ncdu'
		echo "+++++++++++++++++++++++++++++++++"
		echo '- disk monitor'
    $pkt_install_cmd ncdu
  fi
fi

if ! [ -x "$(command -v lazygit)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download lazygit'
	echo "+++++++++++++++++++++++++++++++++"
	echo '- GUI git '
  if [[ $OSTYPE == linux-gnu* ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-35.]+')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
  else
    $pkt_install_cmd lazygit
  fi
fi


if ! [ -x "$(command -v zsh)" ]; then
	echo "+++++++++++++++++++++++++++++++++"
	echo ' download zsh'
	echo "+++++++++++++++++++++++++++++++++"
	$pkt_install_cmd zsh
fi

if [ -x "$(command -v zsh)" ]; then
  if [[ "X$ZSH" == "X" ]]; then
		echo "+++++++++++++++++++++++++++++++++"
		echo ' download Oh-My-Zsh'
		echo "+++++++++++++++++++++++++++++++++"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi

if ! [[ -d "$HOME/.local/share/fonts" ]]; then
  mkdir $HOME/.local/share/fonts
fi

if [[ -d "$HOME/.local/share/fonts" ]]; then
  if ! [[ -f "$HOME/.local/share/fonts/Space Mono Nerd Font Complete.ttf" ]]; then
		echo "+++++++++++++++++++++++++++++++++"
		echo ' download fonts'
		echo "+++++++++++++++++++++++++++++++++"
		echo '- Space Mono Nerd Font'
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/SpaceMono.zip
        unzip SpaceMono.zip
        cp *.ttf $HOME/.local/share/fonts/
  fi
fi

echo "+++++++++++++++++++++++++++++++++"
echo '      CLEAN UP '
echo "+++++++++++++++++++++++++++++++++"
git clean -q -fx
