# include z - <3
. "$HOME/deps/z/z.sh"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/config/.{path,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

#---------------------------------- ssh ----------------------------------

start_ssh_agent () {
  SSHAGENT=/usr/bin/ssh-agent
  SSHAGENTARGS="-s"
  if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
  fi
}

_ssh () {
  local list=`perl -ne 'print "$1 " if /\s*Host\s+(\S+)/' ~/.ssh/config`
  local typed=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$list" -- $typed))
}
complete -F _ssh ssh

# only enter a ssh password once, just enough to send the public key
# and yeah, I only use RSA (http://security.stackexchange.com/a/51194/39787)
pushsshkey () {
  local id=$1
  local host=$2
  cat ~/.ssh/${id}_rsa.pub | ssh $host '( [ ! -d "$HOME/.ssh" ] && mkdir "$HOME/.ssh"; cat >> "$HOME/.ssh/authorized_keys2" )'
}

# changes the default ssh IdentityFile, expects no leading whitespace
sshid () {
  local id=$1
  rm ~/.ssh/config.bak 2>/dev/null
  perl -p -i.bak -e "s/^IdentityFile.*$/IdentityFile ~\/.ssh\/${id}_rsa/i" ~/.ssh/config
  rm ~/.ssh/config.bak 2>/dev/null
  start_ssh_agent
  ssh-add ~/.ssh/${id}_rsa
}

bash_setup () {
  preserve "$HOME/.bashrc"
  preserve "$HOME/.bash_profile"
  preserve "$HOME/.profile"
  echo '. "$HOME/config/bashrc"' > "$HOME/.bashrc"
  echo '. "$HOME/config/bashrc"' > "$HOME/.bash_profile"
  [ ! -d "$HOME/repos" ] && mkdir "$HOME/repos"
  case "$PLATFORM" in
    windows) windows_bash_setup ;;
    linux)   linux_bash_setup ;;
    bsd)     bsd_bash_setup ;;
  esac
}


# set ssh id
sshid id
