.PHONY: sync-kubevirtci

sync-kubevirtci:
	curl -L https://raw.githubusercontent.com/kubernetes-sigs/cluster-api-provider-kubevirt/main/kubevirtci -o kubevirtci
	chmod 755 kubevirtci
