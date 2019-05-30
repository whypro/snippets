#!/usr/bin/env bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/. && pwd)
cd ${ROOT}

set -o errexit
set -o nounset
set -o pipefail

die() {
  if test $# -gt 0; then
    echo "$@" 1>&2
  fi
  exit 1
}

usage() {
    cat <<EOF
Usage: $0 <action>

Actions:
    install     install golang
    clean	clean golang

Examples:
    $0 install
    $0 clean
EOF
}

GO_VERSION=1.12.5
GO_TGZ_FILE_NAME=go${GO_VERSION}.linux-amd64.tar.gz
GO_TGZ_FILE_URL=https://mirrors.ustc.edu.cn/golang/${GO_TGZ_FILE_NAME}
PROFILE=${HOME}/.bashrc

golang::install::check() {
	local version=$(go version 2>/dev/null)
	if [[ ${version} != "" ]]; then
		echo "golang is already installed. (${version})"
		exit 0
	fi
}

golang::install() {
	golang::install::check
	wget -nc ${GO_TGZ_FILE_URL}
	echo 'Installing golang to /usr/local/'
	tar -C /usr/local -xzf ${GO_TGZ_FILE_NAME}
	echo 'Writing environment variables to profile.'
	golang::set_env
}

golang::set_env() {
	grep -qF '/usr/local/go/bin' ${PROFILE} || echo 'export PATH=$PATH:/usr/local/go/bin' >> ${PROFILE}
	grep -qF '^export GOPATH=' ${PROFILE} || echo 'export GOPATH=$HOME/go' >> ${PROFILE}
}

golang::clean() {
	rm -rf /usr/local/go
	echo 'Removed golang in /usr/local/'
	golang::unset_env
	echo 'Removed environment variables in profile.'
}

golang::unset_env() {
	sed -i '\#^export PATH=$PATH:/usr/local/go/bin#d' ${PROFILE}
	sed -i '\#^export GOPATH=$HOME/go#d' ${PROFILE}
}

if [[ "$#" < 1 ]]; then
    usage
    die
fi


if [[ $EUID -ne 0 ]]; then
   die "This script must be run as root."
fi

ACTION=$1

golang::${ACTION}

