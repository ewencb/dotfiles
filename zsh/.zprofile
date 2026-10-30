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
export HOMEBREW_NO_ANALYTICS=1

# System CA bundle, for prebuilt apps (BambuStudio) that can't find it (Arch only)
[[ -f /etc/ssl/certs/ca-certificates.crt ]] &&
  export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Per-OS settings. The Bitwarden SSH agent socket differs; Arch takes LANG
# from /etc/locale.conf, macOS needs it set here
if [[ $OSTYPE == darwin* ]]; then
  export LANG=en_US.UTF-8
  export SSH_AUTH_SOCK="$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
else
  export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
fi

# Secrets and machine-specific settings, kept out of the repo
[[ -r ~/.zprofile.local ]] && source ~/.zprofile.local

# Start Sway when logging in on tty1 (Arch only); keep last, exec never returns
if [[ -z $WAYLAND_DISPLAY && $TTY == /dev/tty1 ]]; then
  exec sway
fi
