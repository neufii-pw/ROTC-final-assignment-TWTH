#!/bin/bash

kubectl delete deployment --all -n crud-app
kubectl delete services --all -n crud-app
kubectl delete pv --all
kubectl delete pvc --all -n crud-app
kubectl delete secrets --all -n crud-app
kubectl delete namespace crud-app
