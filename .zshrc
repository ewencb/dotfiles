# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/cewen/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# pure prompt 
autoload -U promptinit; promptinit
prompt pure

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s ${USER} >/dev/null 2>&1
fi

export EDITOR="nvim"

# Created by `pipx` on 2024-12-02 22:57:06
export PATH="$PATH:/home/cewen/.local/bin"

# dotfiles management
alias dotfiles='/usr/bin/git --git-dir=/home/cewen/.dotfiles/ --work-tree=/home/cewen'

dotsync() {
  emoji="🛠️"
  msg=${1:-"update dotfiles"}

  # Add newly un-ignored, untracked files
  while IFS= read -r f; do
    dotfiles add "$f"
  done < <(dotfiles ls-files --others --exclude-standard)

  # Add all other changes (modified/deleted files allowed by .gitignore)
  dotfiles add .

  # Pull latest changes before committing
  dotfiles pull --rebase

  # Only commit/push if there's something staged
  if ! dotfiles diff --cached --quiet; then
    dotfiles commit -m "$emoji $msg"
    dotfiles push
  else
    echo "✨ No changes to sync"
  fi
}



# path
export PATH="$PATH:/home/cewen/bin"
