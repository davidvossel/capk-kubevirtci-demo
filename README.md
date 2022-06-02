# Demo dev flow using capk+kubevirtci

Requirements
- 32Gi memory
- docker
- nested virtualization

# Creating a guest cluster using the latest CAPK

These steps will download the kubevirtci script, start a infra cluster using
`kubevirtci` locally, and install a CAPK guest cluster.

## Step 1. Download the kubevirtci script from the cluster-api-provider-kubevirt repo

This make target downloads the latest `kubevirtci` script into the source tree

```make sync-kubevirtci```

## Step 2. Start a local infra cluster and install the latest CAPK controller.

```./kubevirtci up && ./kubevirtci install-capk```

## Step 3. Create a CAPK guest cluster

```./kubevirtci create-cluster```

## Step 4. Obeserve the guest cluster creation

Observe the creation and provisioning of the Cluster object
```
./kubevirtci kubectl get cluster -n kvcluster
selecting docker as container runtime
NAME        PHASE         AGE   VERSION
kvcluster   Provisioned   10m   
```

Observe that the kubevirt VMIs are online for the Cluster

```
./kubevirtci kubectl get vmi -n kvcluster
selecting docker as container runtime
NAME                            AGE     PHASE     IP               NODENAME   READY
kvcluster-control-plane-nbw52   11m     Running   10.244.196.164   node01     True
kvcluster-md-0-zdpvs            8m35s   Running   10.244.196.165   node01     True
```

Observe pods within the guest cluster are online

```
./kubevirtci kubectl-tenant get pods -A
```

Notice that the guest cluster nodes are not ready yet. This is because no cni
driver is installed.

```
./kubevirtci kubectl-tenant get nodes
selecting docker as container runtime
Found control plane VM: kvcluster-control-plane-nbw52 in namespace kvcluster
NAME                            STATUS     ROLES                  AGE   VERSION
kvcluster-control-plane-nbw52   NotReady   control-plane,master   11m   v1.21.9
kvcluster-md-0-zdpvs            NotReady   <none>                 10m   v1.21.9
```

## Step 5. Install Calico CNI

**PENDING MERGER OF https://github.com/kubernetes-sigs/cluster-api-provider-kubevirt/pull/143**

```
./kubevirtci install-calico
```

Watch for calico pods in the kube-system namespace to come online. Once the
calico pods come online, the nodes should transition to a ```Ready``` status

## Step 6 (Optional). Destroy the CAPK guest cluster

```./kubevirtci destroy-cluster

# Common Utility/Debug Functions

Use `./kubevirtci help` to discover all the utility functions. These are a list
of the most commonly used ones during development.

## Accessing Infra Cluster

Infra cluster kubectl access
```./kubevirtci kubectl```

The path to the infra cluster's kubeconfig
```./kubevirtci kubeconfig```

## Accessing Guest Cluster

Guest cluster kubectl access.
```./kubevirtci kubectl-tenant```

## Using Virtctl

```./kubevirtci virtctl ...```

## SSH into infra node

This will give you an ssh session into an infra node.

```./kubevirtci ssh-infra node01```

Once in the infra node, execute `sudo su -` to gain root access.

## SSH into guest cluster node

This will give you ssh access to a guest cluster node.

```./kubevirtci ssh-tenant <vmi name> <vmi namespace>

Once in the guest cluster execute the following to get a bash terminal and
get root access.

```
/bin/bash
sudo su -
```
