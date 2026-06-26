## Install Minikube
```
    sudo apt update
    sudo apt install -y docker.io
    sudo usermod -aG docker ubuntu
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

## Install Kubectl
```
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    sudo usermod -aG docker $USER && newgrp docker
```


## Start minikube with Calico CNI enabled
```
    minikube start --network-plugin=cni --cni=calico
```

## Verify the cluster is up and nodes are ready
```
    kubectl get nodes
```

## Verify Calico pods are running (they manage the network policies)
```
    kubectl get pods -n kube-system -l k8s-app=calico-node
```

## Run kube-bench on Minikube
```
    kubectl apply -f https://raw.githubusercontent.com/aquasecurity/kube-bench/main/job.yaml
    kubectl get pods -w
```

## Extract the audit report logs
```
    kubectl logs pod/kube-bench-xxxxx
```

## kube-hunter scan
```
    kubectl apply -f 06-kube-hunter-job.yaml
```

## Extract the kube-hunter audit report logs
```
    kubectl logs job/kube-hunter-job
```