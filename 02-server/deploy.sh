#!/bin/bash

set -e

export PATH="$(pwd)/../bin:${PATH}"
export $(cat ../ENVIRONMENT)
SNAPSHOT_ID=$(cat ../SNAPSHOT)

terraform init
terraform validate
terraform plan -var css_snapshot_id="${SNAPSHOT_ID}" -out tfplan
terraform apply tfplan