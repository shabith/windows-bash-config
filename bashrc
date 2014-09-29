
if [ ! $TERM = 'screen' ]; then

  # bail if somehow non-interactive
  [ -z "$PS1" ] && return 2>/dev/null

  ## bail if already loaded (prefer a single file)
  [ ! -z "$BASHRC_LOADED" ] && return
  BASHRC_LOADED=true
  export BASHRC_LOADED

fi

alias bashrc='unset BASHRC_LOADED; $EDITOR "$HOME/config/bashrc"; . "$HOME/config/bashrc"'

###########################################################################
################################### MAIN ##################################
###########################################################################

# win uses $OS might as well use same
[ -z "$OS" ] && OS=`uname`
case "$OS" in
  *indows* )        PLATFORM=windows ;;
  Linux )           PLATFORM=linux ;;
  FreeBSD|Darwin )  PLATFORM=bsd ;;
esac
export PLATFORM OS

#----------------------------- From Standard ------------------------------

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISFILESIZE=2000
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
set -o notify
set -o noclobber
set -o ignoreeof
set bell-style none

#---------------------------------- Path ----------------------------------

repopaths () {
  local repopath=`find $HOME/repos -maxdepth 1 -type d -print0 | tr '\0' ':'i`
  local repobinpath=`find $HOME/repos -maxdepth 2 -type d -name 'bin' -print0 | tr '\0' ':'`
  echo "$repopath$repobinpath"
}

repath () {

export PATH=\
"./":\
"./bin":\
"$HOME/bin":\
`repopaths`\
"/usr/local/bin:"\
"/usr/bin:"\
"/bin":\
"/usr/local/sbin":\
"/usr/sbin":\
"/sbin"
}
repath

alias path='echo -e ${PATH//:/\\n}'

#---------------------------------- Note ----------------------------------

# god i love bash file completion
_note () {
  local list=`note`
  local typed=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$list" -- $typed))
}
complete -F _note note
alias todo='note todo'

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

#--------------------------- Utility Functions ----------------------------

has() {
  type "$1" > dev/null 2>&1
  return $?
}

preserve () {
    [ -e "$1" ] && mv "$1" "$1"_`date +%Y%m%d%H%M%S`
}

if [ -x /usr/bin/dircolors ]; then
  test -r ~/config/solarized/dircolors \
    && eval "$(dircolors -b ~/config/solarized/dircolors)" \
    || eval "$(dircolors -b)"
fi

alias tstamp='date +%Y%m%d%H%M%S'
alias ls='ls -h --color'
alias more=less

alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias ll='ls -lv'
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.

llastf () {
  # recursively lists all files in reverse chronological order of
  # when they were last modified
  top=$1
  [ "$1" = "" ] && top=.
  find $top -type f -printf '%TY-%Tm-%Td %TT %p\n' |sort -r
}

llastd () {
  # same but directories
  top=$1
  [ "$1" = "" ] && top=.
  find $top -type d -printf '%TY-%Tm-%Td %TT %p\n' |sort -r
}

lall () {
  find . -name "*$1*"
}

grepall () {
  find . \( ! -regex '.*/\..*' \) -type f -exec grep "$1" {} /dev/null \;
}

# why perl versions that could do with bash param sub? bourne compat
join () {
  perl -e '$d=shift; print(join($d,@ARGV))' "$@"
}

# no basename is not the same
chompsuf () {
  perl -e '@l=grep{s/\.[^\.]+$//}@ARGV;print"@l"' "$@"
}

resuf () {
  _from=$1
  _to=$2
  shift 2
  for _name in "$@"; do
    case $_name in
      *.$_from)
        _new=`chompsuf $_name`.$_to
        echo "$_name -> $_new"
        mv $_name $_new
        ;;
    esac
  done
  unset _from _to _name _new
}

#-------------------------------- PowerGit --------------------------------

export GITURLS="$HOME/config/giturls":\
"$HOME/repos/personal/giturls":\
"$HOME/repos/private/giturls"
alias gurlpath='echo -e ${GITURLS//:/\\n}'

repo () {
  if [ -z "$1" ]; then 
    gls name
  else
    cd "$HOME/repos/$1"
  fi
}
alias gcd=repo

_repo () {
  local list=`gls name`
  local typed=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$list" -- $typed))
}
complete -F _repo repo

#---------------------------- Solarized Prompt ----------------------------

# solarized ansicolors (exporting for grins)
export base03='\033[1;30;40m'
export base02='\033[0;30;40m'
export base01='\033[1;32;40m'
export base00='\033[0;33;40m'
export base0='\033[0;34;40m'
export base1='\033[0;36;40m'
export base2='\033[0;37;40m'
export base3='\033[1;37;40m'
export yellow='\033[1;33;40m'
export orange='\033[0;31;40m'
export red='\033[1;31;40m'
export magenta='\033[1;35;40m'
export violet='\033[0;35;40m'
export export blue='\033[1;34;40m'
export cyan='\033[1;36;40m'
export green='\033[1;32;40m'
export reset='\033[0m'
export green='\033[0;32;40m'

colors () {
  echo -e "base03  ${base03}#002B36$reset"
  echo -e "base02  ${base02}#073642$reset"
  echo -e "base01  ${base01}#586E75$reset"
  echo -e "base00  ${base00}#657B83$reset"
  echo -e "base0   ${base0}#839496$reset"
  echo -e "base1   ${base1}#93A1A1$reset"
  echo -e "base2   ${base2}#EEE8D5$reset"
  echo -e "base3   ${base3}#FDF6E3$reset"
  echo -e "yellow  ${yellow}#B58900$reset"
  echo -e "orange  ${orange}#CB4B16$reset"
  echo -e "red     ${red}#DC322F$reset"
  echo -e "magenta ${magenta}#D33682$reset"
  echo -e "violet  ${violet}#6C71C4$reset"
  echo -e "blue    ${blue}#268BD2$reset"
  echo -e "cyan    ${cyan}#2AA198$reset"
  echo -e "green   ${green}#859900$reset"
}

# from Nico Golde
ansicolors () {
for attr in 0 1 4 5 7 ; do
    echo "------------------------------------------------"
    printf "ESC[%s;Foreground;Background - \n" $attr
    for fore in 30 31 32 33 34 35 36 37; do
        for back in 40 41 42 43 44 45 46 47; do
            printf '\033[%s;%s;%sm %02s;%02s\033[0m' \
              $attr $fore $back $fore $back
        done
    printf '\n'
    done
done
}


clogo () {
echo -e "$blue#!/play/learn/program                                                          "  
echo -e "          $red        __   .__.__            __          __                        "
echo -e "          $red  _____|  | _|__|  |   _______/  |______  |  | __                    "
echo -e "          $red /  ___/  |/ /  |  |  /  ___/\   __\__  \ |  |/ /                    "
echo -e "          $red \___ \|    <|  |  |__\___ \  |  |  / __ \|    <                     "
echo -ne "          $red/____  >__|_ \__|____/____  > |__| (____  /__|_ \\"
echo -e "${base3}_______             "
echo -ne "          $red     \/     \/            \/            \/     \\"
echo -e "${base3}/______/             "
echo -e "                                       ${cyan}Coding Arts                             "
}

smlogo () {
  echo -e "${red}skilstak${base3}_$reset"
}

if [ "$PLATFORM" != windows ]; then
alias bigprompt='export PS1="\n\[$red\]╔ \[$green\]\T \d \[${orange}\]\u@\h\[$base01\]:\[$blue\]\w$gitps1\n\[$red\]╚ \[$cyan\]\\$ \[$reset\]"'
alias medprompt='export PS1="\[${base0}\]\u\[$base01\]@\[$base00\]\h:\W\[$cyan\]\\$ \[$reset\]"'
alias pwdprompt='export PS1="\[${base01}\]\W\[$cyan\]\\$ \[$reset\]"'
alias noprompt='export PS1="\[$cyan\]\\$ \[$reset\]"'
fi

# default
export PS1="\[${base0}\]\u\[$base01\]@\[$base00\]\h:\W\[$cyan\]\\$ \[$reset\]"

#---------------------------- Jekyll Blogging -----------------------------

export SITE="$HOME/repos/com"
export SITEME="$HOME/repos/me"

postname () {
  echo `date +%Y-%m-%d`-`join - "$@"`.markdown
}

blog_header="---
layout: post
---

"

vipost () {
  $EDITOR `postname $*`
}

writepost () {
  local dir="$1"
  shift 1;
  post=$dir/`postname "$@"`
  [ ! -e "$post" ] && echo "$blog_header" > $post
  $EDITOR + +start $post
}

pub () {
  local site=$1; shift;
  local file=`find $site/_drafts -name "*$**" ! -path '*images*' | head -1`
  if [ -e "$file" ]; then
    mv $file $site/_posts
  else
    echo "Don't see a draft matching '*$key*'"
  fi
}

alias comblog='writepost $SITE/_posts'
alias meblog='writepost $SITEME/_posts'
alias comdraft='writepost $SITE/_drafts'
alias medraft='writepost $SITEME/_drafts'

# bash lets you remove directory entries with editor
alias composts='$EDITOR $SITE/_posts'
alias meposts='$EDITOR $SITEME/_posts'
alias medrafts='$EDITOR $SITEME/_drafts'
alias comdrafts='$EDITOR $SITE/_drafts'

alias compub='pub $SITE'
alias mepub='pub $SITEME'

###########################################################################
################################# Windows #################################
###########################################################################

# I really hate that we have to do all this, but windows default term is
# horrible even if it is what most have available to them.
#
# I strongly recommend setting up a vm in a local cloud even on your 
# workstation or laptop and ssh-ing into it for any serious development,
# yes, even for mac users. Using a local linux or smartos vm promotes
# habits and workflows identical to those used professionally by coders
# and system administrators alike.

if [ "$PLATFORM" == windows ]; then

# god i hate these paths
export PF=/c/Program\ Files
export XPF=/c/Program\ Files\ \(x86\)
alias pf='cd "$PF"'
alias xpf='cd "$XPF"'

# still safer doing it ourselves instead of the git-bash system-wide option
# but yeah, i'll be updating this one a lot
PATH=$XPF/Vim/Vim74:\
$XPF/Git/bin:\
/c/Python34:\
$PF/Java/jdk1.7.0_51/bin:\
$PF/nodejs:\
"$HOME/GameMaker-Studio\ 1.2":\
$PATH:\
/c/Windows:\
/c/Windows/System32
export PATH

alias gamemaker=Gamemaker-Studio.exe
alias single='unset BASHRC_LOADED && cd "$HOME" && start "" "c:\program files (x86)\git\bin\sh.exe" --login -i && cd -'
alias ip="ipconfig | perl -ne '/^\s*IPv4/ and print'"
alias psplugins='cd "/c/Program Files (x86)/Adobe/Adobe Photoshop CC/Plug-ins"'

# have to force it, normally 'msys'
export TERM=xterm-color

# windows fails to position cursor correctly with \['s are used
alias bigprompt='export PS1="\n$red╔ $green\T \d ${orange}\u@\h$base01:$blue\w$gitps1\n$red╚ $cyan\\$ $reset"'
alias medprompt='export PS1="${base0}\u$base01@$base00\h:\W$cyan\\$ $reset"'
alias pwdprompt='export PS1="${base01}\W$cyan\\$ $reset"'
alias noprompt='export PS1="$cyan\\$ $reset"'
# alias often not available in time to call here, so we rep the one we want
# (windows really sucks, completely incompetent operating system, 'cept for games)
export PS1="${base0}\u$base01@$base00\h:\W$cyan\\$ $reset"

# called from bash_setup
windows_bash_setup () {

  # solarize all windows cmd consoles including git-bash
  echo Run 'regedit /s solarized/solarized-dark.reg' if you want solarized colors

  # solarize the chrome (and canary) source view
  # cp Custom.css "$HOME/AppData/Local/Google/Chrome/User Data/Default/User StyleSheets"
  # cp Custom.css "$HOME/AppData/Local/Google/Chrome SxS/User Data/Default/User StyleSheets"
}

###########################################################################
################################## Linux ##################################
###########################################################################

elif [ "$PLATFORM" == linux ]; then

alias listens='netstat -tulpn'
alias ip="ifconfig | perl -ne '/^\s*inet addr/ and print'"
export TERM=xterm

linux_bash_setup () {
  echo "Nothing special needed. What a surprise."
}

###########################################################################
################################### BSD ###################################
###########################################################################

# mac mostly
elif [ "$PLATFORM" == bsd ]; then

bsd_bash_setup () {
  echo "Nothing special needed. What a surprise."
}

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
alias ls='ls -G'


fi

###########################################################################
################################### MAIN ##################################
###########################################################################

#-------------------------------- Vim-ish ---------------------------------

set -o vi
if [ "`which vim 2>/dev/null`" ]; then
  export EDITOR=vim
  alias vi=vim
else
  export EDITOR=vi
fi

#TODO add keyword file completion
vif () {
  local file=`find . -name "*$**" ! -path '*images*' | head -1`
  if [ -f "$file" ]; then
    $EDITOR $file
  else
    $EDITOR $key # when actually want 'vi' but fat-fingered
  fi
}

vic () {
  $EDITOR `which $1`
}

#--------------------------------------------------------------------------

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

git_setup () {
  git config --global push.default simple
  git clone https://github.com/skilstak/powergit.git \
    "$HOME/repos/powergit" 2>/dev/null
  if [ $? == 0 -o -d "$HOME/repos/powergit" ]
  then
    repath
    gclone
  fi
}

vim_setup () {
  cd ~/vimfiles
  ./setup
  cd -
}

get_minecraft () {
  mkdir ~/minecraft
  curl --progress-bar https://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar > ~/minecraft/Minecraft.jar
  curl --progress-bar https://s3.amazonaws.com/Minecraft.Download/versions/1.8/minecraft_server.1.8.jar > ~/minecraft/minecraft_server.1.8.jar
}

#---------------------------- personalization -----------------------------

# mostly for those that do now want to maintain their own bashrc but
# still want a repo-centric bash config

[ -e "$HOME/repos/personal/bashrc" ] && . "$HOME/repos/personal/bashrc" 
[ -e "$HOME/repos/private/bashrc" ] && . "$HOME/repos/private/bashrc" 
