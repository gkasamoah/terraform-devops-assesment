#!/bin/bash

set -e

mc alias set local http://localhost:9000 minioadmin minioadmin

mc mb local/terraform-state --ignore-existing

echo "Bucket created."