#!/bin/bash

kubectl delete -n crud-app deployment backend-deployment   
kubectl delete -n crud-app deployment postgres-deployment
kubectl delete pvc --all
kubectl delete secrets --all -n crud-app
