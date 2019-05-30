#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/. && pwd)
cd ${ROOT}

HOME_DIR_PREFIX=/home

echo::red() {
    echo -e "\033[31m$1\033[0m"
}

echo::green() {
    echo -e "\033[32m$1\033[0m"
}

echo::yellow() {
    echo -e "\033[33m$1\033[0m"
}

die() {
  if test $# -gt 0; then
    echo::red "$@" 1>&2
  fi
  exit 1
}

usage() {
    cat <<EOF
Usage: $0 <action> <username>

Actions:
    create	create user
    clean	clean user

Examples:
    $0 create kpaas
    $0 clean kpaas
EOF
}


create() {
	local username=$1
	useradd -s /bin/bash -d ${HOME_DIR_PREFIX}/${username} -m ${username}
	passwd ${username}
	set_env ${username}
	echo "Create user ${username} successfully."
	export -f echo::green
	su - ${username} -c 'echo -e "\033[32mPlease run \"ssh-copy-id $(whoami)@<public-ip>\" on your local machine and login with \"ssh $(whoami)@<public-ip>\"\033[0m"'
	#su - ${username}
}

clean() {
	local username=$1
	userdel -f ${username}
}

set_env() {
	local username=$1
        su - ${username} -c "grep -qF '/usr/local/go/bin' ~/.bashrc || echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc"
        su - ${username} -c "grep -qF '^export GOPATH=' ~/.bashrc || echo 'export GOPATH=$HOME/go' >> ~/.bashrc"
}

unset_env() {
        sed -i '\#^export PATH=$PATH:/usr/local/go/bin#d' ~/.bashrc
        sed -i '\#^export GOPATH=$HOME/go#d' ~/.bashrc
}

if [[ "$#" < 2 ]]; then
    usage
    die
fi

if [[ $EUID -ne 0 ]]; then
   die "This script must be run as root."
fi

ACTION=$1
USERNAME=$2

${ACTION} ${USERNAME}

