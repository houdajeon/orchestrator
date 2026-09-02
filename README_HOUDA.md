# Kubernetes (`kubectl`) & Vagrant SSH Reference Guide

## 1. Node & Cluster Management

### List all nodes in the cluster

```bash
kubectl get nodes -o wide
```

### Inspect node details and events

```bash
kubectl describe node <node-name>
```

### Check cluster information and control plane components

```bash
kubectl cluster-info
```

---

## 2. Managing Pods & StatefulSets

### List all running pods

```bash
kubectl get pods
```

### Watch pod status in real time

```bash
kubectl get pods -w
```

### Inspect detailed pod specifications and recent events

```bash
kubectl describe pod <pod-name>
```

### List all StatefulSets

```bash
kubectl get statefulset
```

### Manually scale a StatefulSet

```bash
kubectl scale statefulset inventory-db --replicas=2
```

---

## 3. Storage & Secrets Management

### List Secrets

```bash
kubectl get secrets
```

### Inspect Secret keys without revealing values

```bash
kubectl describe secret db-secrets
```

### Decode a Base64 Secret value in the terminal

```bash
kubectl get secret db-secrets -o jsonpath='{.data.INVENTORY_DB_PASSWORD}' | base64 --decode
```

### List Persistent Volume Claims (PVCs)

```bash
kubectl get pvc
```

### List Persistent Volumes (PVs)

```bash
kubectl get pv
```

---

## 4. Debugging & Interacting with Containers

### View live logs of a specific pod

```bash
kubectl logs -f <pod-name>
```

### View logs for a specific container

```bash
kubectl logs -f <pod-name> -c <container-name>
```

### Open an interactive Bash shell inside a container

```bash
kubectl exec -it <pod-name> -- /bin/bash
```

### If Bash is not available, use `/bin/sh`

```bash
kubectl exec -it <pod-name> -- /bin/sh
```

### Connect to PostgreSQL inside the `inventory-db-0` pod

```bash
kubectl exec -it inventory-db-0 -- psql -U appuser -d movies_db
```

---

## 5. Applying & Deleting Manifests

### Apply a single manifest

```bash
kubectl apply -f Manifests/secrets.yaml
```

### Apply all manifests in a directory

```bash
kubectl apply -f Manifests/
```

### Delete resources defined in a manifest

```bash
kubectl delete -f Manifests/inventory-db.yaml
```

### Delete a specific pod

```bash
kubectl delete pod <pod-name>
```

### Delete a specific PVC

```bash
kubectl delete pvc <pvc-name>
```

---

## 6. Remote SSH Access to Virtual Machines

### Access via Vagrant — Recommended

Run these commands from the directory containing your `Vagrantfile`.

### SSH into the Master VM

```bash
vagrant ssh master
```

### SSH into the Agent VM

```bash
vagrant ssh agent1
```

---

## 7. Access via Standard SSH — Direct IP

If you need to log in directly from the terminal without using `vagrant ssh`, first retrieve the SSH configuration details from Vagrant.

### Get SSH configuration details

```bash
vagrant ssh-config
```

### Connect directly using SSH keys

#### Connect to Master

```bash
ssh -i .vagrant/machines/master/virtualbox/private_key vagrant@192.168.56.10
```

#### Connect to Agent

```bash
ssh -i .vagrant/machines/agent1/virtualbox/private_key vagrant@<agent-ip>
```

### Affiche rabbitmq

```
kubectl exec -it $(kubectl get pod -l app=rabbit-queue -o jsonpath='{.items[0].metadata.name}') -- rabbitmqctl list_queues name messages messages_ready messages_unacknowledged
```
### Affiche rabbitmq realtime

```
 watch 'kubectl exec $(kubectl get pod -l app=rabbit-queue -o jsonpath="{.items[0].metadata.name}") -- rabbitmqctl list_queues name messages messages_ready messages_unacknowledged'
 ```
### For test rabbitmq 

- stop billing :
```
kubectl scale statefulset billing-app --replicas=0
```
- restart billing :
```
kubectl scale statefulset billing-app --replicas=1
```

---

## Quick Reference

| Task | Command |
|---|---|
| List nodes | `kubectl get nodes -o wide` |
| Cluster information | `kubectl cluster-info` |
| List pods | `kubectl get pods` |
| Watch pods | `kubectl get pods -w` |
| Describe pod | `kubectl describe pod <pod-name>` |
| List StatefulSets | `kubectl get statefulset` |
| Scale StatefulSet | `kubectl scale statefulset inventory-db --replicas=2` |
| List Secrets | `kubectl get secrets` |
| List PVCs | `kubectl get pvc` |
| List PVs | `kubectl get pv` |
| Follow pod logs | `kubectl logs -f <pod-name>` |
| Enter container | `kubectl exec -it <pod-name> -- /bin/bash` |
| Apply manifest | `kubectl apply -f <file>` |
| Apply directory | `kubectl apply -f <directory>/` |
| Delete manifest resources | `kubectl delete -f <file>` |
| SSH to Master | `vagrant ssh master` |
| SSH to Agent | `vagrant ssh agent1` |
| Show Vagrant SSH config | `vagrant ssh-config` |
