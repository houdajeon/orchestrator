#!/bin/bash
set -e

# Always run from the project root directory
cd "$(dirname "$0")/.."

case "$1" in
 create)
    echo "Creating virtual machines and installing K3s..."
    vagrant up --provider=virtualbox
    
    echo "Configuring local kubectl context..."
    mkdir -p ~/.kube
    vagrant ssh master -c "sudo cat /etc/rancher/k3s/k3s.yaml" > ~/.kube/config
    # Use cross-platform sed syntax 
    sed -i.bak 's/127.0.0.1/192.168.56.10/g' ~/.kube/config && rm -f ~/.kube/config.bak
    chmod 600 ~/.kube/config
    
    echo "Applying Kubernetes manifests..."
    # Check if files exist before applying
    if [ -d "Manifests" ] && [ "$(ls -A Manifests/*.yaml 2>/dev/null)" ]; then
      kubectl apply -f Manifests/
    else
      echo "Warning: No .yaml files found in Manifests/ directory. Skipping apply."
    fi

    rm -f node-token
    echo "Cluster creation completed."
    ;;
  start)
    echo "Starting cluster virtual machines..."
    vagrant resume || vagrant up --provider=virtualbox
    echo "Cluster started successfully."
    ;;
  stop)
    echo "Stopping cluster virtual machines..."
    vagrant halt
    echo "Cluster stopped."
    ;;
  *)
    echo "Usage: $0 {create|start|stop}"
    exit 1
    ;;
esac