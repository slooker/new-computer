## Add homebrew support
eval "$(/opt/homebrew/bin/brew shellenv)"

## Add color suppor
autoload -U colors && colors

## Git prompt
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' [%b]'
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%{$fg[cyan]%}${PWD/#$HOME/~}%{$reset_color%}%{$fg[yellow]%}${vcs_info_msg_0_}%{$reset_color%} $ '

## Colors in ls for mac
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

## NVM support
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Autoload .nvmrc file if it exists
enter_directory() {
  if [[ $PWD == $PREV_PWD ]]; then
    return
  fi

  PREV_PWD=$PWD
  [[ -f ".nvmrc" ]] && nvm use
}

export PROMPT_COMMAND=enter_directory

## NPM Token for payments

## Golang settings
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
export GPG_TTY=$(tty)

alias start-postgres="pg_ctl -D /opt/homebrew/var/postgres -l /opt/homebrew/var/postgres/server.log start"
alias stop-postgres="pg_ctl -D /opt/homebrew/var/postgres stop -s -m fast"

func git-amend () {
    BRANCH=$(git branch --show-current)
    git rebase --exec 'git commit --amend --no-edit -n -S' -i $BRANCH
}


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export NPM_TOKEN=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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$PATH:/opt/homebrew/bin

# PROXY_HOST=${aws rds describe-db-proxies --db-proxy-name alle-shared-iam-auth --region us-west-2 --query 'DBProxies[0].Endpoint' --output text}
alias get-proxies="aws rds describe-db-proxies --db-proxy-name alle-shared-iam-auth --region us-west-2 --query 'DBProxies[0].Endpoint' --output text"
alias rds="aws rds generate-db-auth-token --hostname alle-shared-iam-auth.proxy-cl41mvxsaelx.us-west-2.rds.amazonaws.com --port 5432 --region us-west-2 --username iam_readonly_role"


dump_staging_db () {
    curl -s -L https://www.amazontrust.com/repository/AmazonRootCA1.pem --output /tmp/AmazonRootCA1.pem
    USER_NAME=iam_readonly_payments_role
    ENVIRONMENT=alle-stage
    ENDPOINT=$(aws rds describe-db-proxies --db-proxy-name alle-shared-iam-auth --region us-west-2 --query 'DBProxies[0].Endpoint' --output text)
    PGPASSWORD=$(aws rds generate-db-auth-token --hostname $ENDPOINT --port 5432 --region us-west-2 --username $USER_NAME)
    pg_dump "port=5432 host=$ENDPOINT user=$USER_NAME dbname=payments sslrootcert=/tmp/AmazonRootCA1.pem sslmode=verify-full" -x -O > $(date +"%Y-%m-%d")-payments_dump.sql
}

get_staging_token () {
    USER_NAME=iam_readonly_payments_role
    ENVIRONMENT=alle-stage
    ENDPOINT=$(aws rds describe-db-proxies --db-proxy-name alle-shared-iam-auth --region us-west-2 --query 'DBProxies[0].Endpoint' --output text)
    PGPASSWORD=$(aws rds generate-db-auth-token --hostname $ENDPOINT --port 5432 --region us-west-2 --username $USER_NAME)
    echo $PGPASSWORD
}

port_forward_stage () {
    aws eks update-kubeconfig --name eks-cluster
    export ENV=stage
    PAYMENT_POD=$(kubectl get pods -n ${ENV} -o wide | grep 'payments' | grep 'Running' | tail -1 | awk '{ print $1 }')
    kubectl port-forward -n ${ENV} ${PAYMENT_POD} 9000:9000 
}

alias describe-payments-pod=kubectl describe pod alle-backend-payments-wallet-rest-server-65c696f649-9pf7z -n dev
alias get-payment-pods=kubectl get pods -n dev | grep payment

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
