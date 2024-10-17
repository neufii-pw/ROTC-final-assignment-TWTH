#!/bin/bash

apply_resource() {
  kubectl apply -f "$1" -n crud-app
  if [[ $? -ne 0 ]]; then
    echo "Error applying $1"
    exit 1
  fi
}

apply_resource namespace.yaml
apply_resource secret.yaml
apply_resource pv.yaml
apply_resource pvc.yaml
apply_resource deployment.yaml
apply_resource service.yaml

echo "All resources applied successfully!"
