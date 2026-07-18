# Database Isolation Verification

This repository implements a two-tier private network model:

- `edge` network: only the public-facing NGINX container is attached.
- `internal` network: the API container runs here.
- `database` network: PostgreSQL runs here and is not reachable from the edge network.

## Verification command

```bash
make verify
```

## What the verification does

1. Confirms the `staging-nginx`, `staging-api`, and `staging-postgres` containers are running.
2. Uses `nc` from the API container to verify the database port `5432` is reachable.
3. Uses `nc` from the NGINX edge container to verify the database port is unreachable.

## Expected result

- `PASS: compute tier can reach PostgreSQL`
- `PASS: edge tier cannot reach PostgreSQL`
