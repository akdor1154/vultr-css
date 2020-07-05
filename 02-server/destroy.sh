#!/bin/sh

set -e

export PATH="$(pwd)/../bin:${PATH}"
export $(cat ../ENVIRONMENT)

terraform destroy -var-file ../snapshot.tfvars