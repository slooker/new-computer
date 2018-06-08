
## Set bash prompt
export PS1='[\u@\h \w]\$ '

## Colors in ls for mac
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export GOPATH=/Users/slooker/go

if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
