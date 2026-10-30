# ~/.zshrc
# Works on Arch and macOS. Interactive shell settings only;
# environment and PATH live in ~/.zprofile.

# History ---------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space extended_history

# Options ---------------------------------------------------------------
setopt autocd extended_glob interactive_comments no_beep

# Completion ------------------------------------------------------------
autoload -Uz compinit && compinit
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{8}-- %d --%f'
zstyle ':completion:*' group-name ''

# Vim mode --------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=1

# Mode shown two ways: cursor shape (blinking block/underline, DOS-style) and prompt arrow (❮/❯)
_mode_char='❯'
zle-keymap-select() {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[1 q'; _mode_char='❮'
  else
    echo -ne '\e[3 q'; _mode_char='❯'
  fi
  zle reset-prompt
}
zle-line-init() { echo -ne '\e[3 q'; _mode_char='❯' }
zle -N zle-keymap-select
zle -N zle-line-init

# v in normal mode: edit the command in Neovim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Handy keys in insert mode
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^?' backward-delete-char

# hjkl in the completion menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Prompt ----------------------------------------------------------------
# Palette colours only, so it follows the terminal and tty theme.
#
#   ~/code/vertexdice  main*  12s
#   ❯
#
# Line 1: folder, git branch (* unstaged, + staged), time taken if over 3s.
# Line 2: arrow, ❯ in insert mode, ❮ in normal mode; exit code shown on failure.
autoload -Uz vcs_info add-zsh-hook
zmodload zsh/datetime
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '  %F{5} %b%F{11}%u%c%f'
zstyle ':vcs_info:git:*' actionformats '  %F{5} %b|%a%F{11}%u%c%f'

_cmd_start=0
_took=''
_prompt_preexec() { _cmd_start=$EPOCHSECONDS }
_prompt_precmd() {
  local secs=$(( EPOCHSECONDS - _cmd_start ))
  if (( _cmd_start && secs >= 3 )); then _took="  %F{8}${secs}s%f"; else _took=''; fi
  _cmd_start=0
  vcs_info
}
add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_precmd

PROMPT=$'\n%F{14}%~%f${vcs_info_msg_0_}${_took}\n%(?..%F{9}%? %f)%F{6}${_mode_char}%f '
# Show user@host on the right only over SSH
[[ -n $SSH_CONNECTION ]] && RPROMPT='%F{8}%n@%m%f'

# Aliases ---------------------------------------------------------------
if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=auto'
alias vim='nvim'

# Plugins ---------------------------------------------------------------
# Looks in Arch and Homebrew locations; skips anything not installed.
_src() {
  local f
  for f in "$@"; do [[ -r $f ]] && source "$f" && return; done
}

# fzf: Ctrl+R history, Ctrl+T files, Alt+C cd, **<Tab> path completion
_src /usr/share/fzf/key-bindings.zsh /opt/homebrew/opt/fzf/shell/key-bindings.zsh
_src /usr/share/fzf/completion.zsh /opt/homebrew/opt/fzf/shell/completion.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
_src /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh \
     /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Must be last
_src /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
     /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unfunction _src
