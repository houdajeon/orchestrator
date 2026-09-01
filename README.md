# Movie Services on Kubernetes

This project runs a movie inventory and billing system on a small K3s cluster.
Vagrant creates two Debian virtual machines:

- `master`: runs the K3s server.
- `agent1`: runs as a K3s worker.

Kubernetes manages the applications, databases, network services, storage and
automatic scaling.

## Architecture

```text
Client
  |
  | localhost:3000
  v
API Gateway
  |                         |
  | HTTP                    | RabbitMQ message
  v                         v
Inventory App          RabbitMQ Queue
  |                         |
  v                         v
Inventory Database     Billing App
                            |
                            v
                       Billing Database
```

The system contains six services:

| Service | Role | Kubernetes resource |
|---|---|---|
| API Gateway | Receives public API requests | Deployment |
| Inventory App | Manages movie information | Deployment |
| Inventory Database | Stores movies | StatefulSet |
| Billing App | Processes billing messages | StatefulSet |
| Billing Database | Stores orders | StatefulSet |
| RabbitMQ Queue | Holds billing messages | Deployment |

The API Gateway and Inventory App can scale automatically from one to three
replicas when CPU usage reaches 60%.

## Requirements

Install these tools before starting:

- VirtualBox
- Vagrant
- `kubectl`
- `curl` or Postman for API tests

The computer should have at least 4 GB of free memory for the virtual machines.

## Project structure

```text
.
├── Dockerfiles/       Image definitions
├── Manifests/         Kubernetes resources
├── Scripts/           Cluster helper scripts
├── srcs/              Application source code
├── Vagrantfile        Virtual machine configuration
└── README.md          Project documentation
```

## Configuration

The Kubernetes configuration is stored in `Manifests/`:

- `configmaps.yaml` contains service addresses and ports.
- `secrets.yaml` contains database and RabbitMQ settings.
- Each application has its own manifest.

Replace sample passwords before using the project outside a local learning
environment. Do not place real production credentials in the repository.

The containers use public images from the `aymening01` Docker Hub account.

## Create the cluster

From the project directory, run:

```bash
./Scripts/orchestrator.sh create
```

This command creates both virtual machines, installs K3s, connects the worker,
configures `kubectl` and applies the Kubernetes manifests.

Check that both nodes are ready:

```bash
kubectl get nodes
```

Check the deployed resources:

```bash
kubectl get all
kubectl get pvc
```

All application pods should become `Running`, and both database claims should
be `Bound`.

## Start and stop the cluster

```bash
./Scripts/orchestrator.sh start
./Scripts/orchestrator.sh stop
```

`start` starts the virtual machines. `stop` shuts them down without deleting
the cluster data.

## API usage

The API is available at:

```text
http://localhost:3000
```

### Add a movie

Send a `POST` request to `/api/movies/` with JSON:

```json
{
  "title": "A new movie",
  "description": "Very short description"
}
```

A successful request returns status `201`.

### List movies

Send a `GET` request to `/api/movies/`.

A successful request returns status `200` and a JSON list of movies.

### Send a billing order

Send a `POST` request to `/api/billing/` with JSON:

```json
{
  "user_id": "20",
  "number_of_items": "99",
  "total_amount": "250"
}
```

A successful request returns status `200`. RabbitMQ keeps the message until
the Billing App processes it and saves the order in the billing database.

## Storage and resilience

The inventory and billing databases use persistent volume claims. Their data
remains available when Kubernetes replaces a database pod.

Billing is asynchronous. If the Billing App is temporarily stopped, the API
Gateway can still place orders in RabbitMQ. The Billing App processes the
waiting orders after it starts again.

## Useful checks

Use these commands when checking the project:

```bash
kubectl get nodes
kubectl get pods
kubectl get services
kubectl get statefulsets
kubectl get hpa
kubectl get pvc
kubectl get secrets
```

To investigate a pod that is not running:

```bash
kubectl describe pod POD_NAME
kubectl logs POD_NAME
```

## Troubleshooting

- If a pod shows `ImagePullBackOff`, check the image name and network access.
- If a pod shows `CrashLoopBackOff`, read its logs.
- If a database pod stays pending, check its persistent volume claim.
- If CPU values in the HPA are unknown, check the K3s Metrics Server.
- If `localhost:3000` is unavailable, confirm that the master VM and API
  Gateway pod are running.

## Main Kubernetes concepts

- A **manifest** describes the desired state of a Kubernetes resource.
- A **Deployment** manages replaceable application pods and supports scaling.
- A **StatefulSet** gives pods stable identities and is useful for stateful
  applications.
- A **Service** gives pods a stable network address.
- A **Secret** stores sensitive configuration used by pods.
- A **ConfigMap** stores non-sensitive configuration.
- An **HPA** changes the number of replicas based on resource usage.
- A **PVC** requests persistent storage for application data.
