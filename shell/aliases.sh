function to() {
	dirname=.
	case $1 in
		k8s) dirname=~/go/src/k8s.io/kubernetes ;;
		k8sbin) dirname=~/go/src/k8s.io/kubernetes/_output/bin ;;

		po) dirname=~/go/src/github.com/coreos/prometheus-operator ;;

		qiniu) dirname=~/go/src/qiniu.com ;;
		ke) dirname=~/go/src/qiniu.com/ke ;;
		kd) dirname=~/go/src/qiniu.com/kirk-deploy ;;
		kl) dirname=~/go/src/qiniu.com/kirklog ;;
		monos) dirname=~/go/src/qiniu.com/monos ;;
		morse) dirname=~/go/src/qiniu.com/morse ;;

		*) echo "$1 not found"; return 0 ;;
	esac
	echo "chdir to $dirname"
	cd $dirname
}

alias kc='kubectl'
alias kcks='kubectl -n kube-system'
alias gmmrb="gfa && gco master && gm --ff-only upstream/master && gco - && grb master"

