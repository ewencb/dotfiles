# ~/.zprofile
# Login shell environment for Arch and macOS: PATH and exported variables.
# Interactive settings live in ~/.zshrc.

# PATH ------------------------------------------------------------------
# Homebrew first on macOS so its tools win over the system ones
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

typeset -U path  # drop duplicates
path=(~/.local/bin ~/.cargo/bin $path)

# Environment -----------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export LANG=en_US.UTF-8
export HOMEBREW_NO_ANALYTICS=1

# SSH keys come from the Bitwarden agent, whose socket differs per OS
if [[ $OSTYPE == darwin* ]]; then
  export SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
else
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi

# Secrets and machine-specific settings, kept out of the repo
[[ -r ~/.zprofile.local ]] && source ~/.zprofile.local
