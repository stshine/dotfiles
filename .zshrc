# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

# Source zcomet.zsh
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

zcomet load sudorook/fishy-lite

zcomet load zsh-users/zsh-autosuggestions

. "$HOME/.cargo/env"

export PATH=$PATH:$HOME/.dotnet/tools:$HOME/.local/bin
