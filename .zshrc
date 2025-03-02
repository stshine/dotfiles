### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k theme
zinit ice depth"1"
zinit light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-binary-symlink \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust


### Binaries

# fzf
# zinit ice if'[[ ! -n "$commands[fzf]" ]]' from"gh-r" lbin"!fzf"
# zinit load junegunn/fzf
# export FZF_ALT_C_OPTS='--preview="ls {}" --preview-window=right:60%:wrap'
# zinit ice lucid wait'0f' \
#     multisrc"shell/{completion,key-bindings}.zsh" \
#     id-as"junegunn/fzf_completions" pick"/dev/null"
# zinit light junegunn/fzf
zinit pack"bgn-binary" for fzf

# zoxide
zinit ice from"gh-r" sbin"zoxide" \
    atclone"./zoxide init zsh > zoxide.init.zsh" \
    atpull"%atclone" src"zoxide.init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

# bat
#zinit ice if'[[ ! -n "$commands[bat]" ]]' \
    #from"gh-r" lbin"!bat* -> bat" as"program" \
    #mv"bat* -> bat" pick"bat/bat" # atload"alias cat=bat"
#zinit light sharkdp/bat


### Auto suggestions and completions
zinit ice wait"0a" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

zinit ice wait"0b" lucid blockf
zinit light zsh-users/zsh-completions

zinit ice wait"0c" lucid as"completion"
zinit snippet $(rustc --print sysroot)/share/zsh/site-functions/_cargo

zinit ice wait"0d" lucid \
    blockf atclone'echo fpath+=\${0:A:h}/src > gentoo.plugin.zsh' \
    atpull'%atclone' pick'gentoo.plugin.zsh' nocompile'!'
zinit load gentoo/gentoo-zsh-completions

zstyle ':completion:*' completer _complete _ignored _approximate
# Highlight current selection
zstyle ':completion:*' menu yes=long select=2
# Display scrolling list when completion exceeds screen
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
# Match upper case for lower case, then for incomplete string
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Group the different type of matches under their descriptions
zstyle ':completion:*' group-name ''
# Treat '//' as '/'
zstyle ':completion:*' squeeze-slashes true
#zstyle ':completion:*' max-errors 1
zstyle ':completion:*:descriptions' format ' %F{green}-- %d --%f'
zstyle ':completion:*:corrections' format ' %F{yellow}-- %d (errors: %e) --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# setopt COMPLETE_IN_WORD     # Complete from both ends of a word.
#setopt ALWAYS_TO_END        # Move cursor to the end of a completed word.
#setopt PATH_DIRS            # Perform path search even on command names with slashes.
setopt AUTO_MENU            # Show completion menu on a successive tab press.
setopt AUTO_LIST            # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB        # Needed for file modification glob modifiers with compinit.
unsetopt MENU_COMPLETE      # Do not autoselect the first completion entry.
#unsetopt FLOW_CONTROL       # Disable start/stop characters in shell editor.


# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light trapd00r/LS_COLORS


### Syntax highlighting
zinit ice wait"0e" lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting


### History settings
# INC_APPEND_HISTORY and SHARE_HISTORY are mutally exclusive.
# Record duplicate entries for frequency detecting.

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
# setopt INC_APPEND_HISTORY        # Append history lines to HISTFILE as soon as they are entered.
# setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
# setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
# setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.

# Treat these characters as part of a word.
WORDCHARS='*?_.[]~&;!#$%^(){}<>'

zmodload zsh/complist
bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete

# Start typing + [PageUp] - fuzzy find history forward
if [[ -n "${terminfo[kpp]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kpp]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kpp]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-beginning-search
fi
# Start typing + [PageDown] - fuzzy find history backward
if [[ -n "${terminfo[knp]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[knp]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[knp]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-beginning-search
fi

### Alias
alias ls="ls --color=auto"
