# Backend bootstrap

This repository uses a local MinIO service as the remote Terraform backend.

## Bootstrap process

1. Start MinIO

```bash
docker compose up -d
```

2. Wait for MinIO readiness

```bash
./bootstrap/wait-for-minic.sh
```

3. Create the bucket

```bash
./bootstrap/create-bucket.sh
```

4. Initialize Terraform

```bash
terraform init -reconfigure
```

The MinIO service is therefore the backend storage container for Terraform state, and it is started inside the local Docker Compose environment before the first `terraform init`.