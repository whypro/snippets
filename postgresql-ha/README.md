
## Use Case

### install etcd cluster
```
kubectl -n stolon apply -f etcd.yaml
```

### install stolon
```
helm install -f stolon-values.yaml stolon-chart/stolon/ --namespace=stolon --name=angry-toucan
```

### upgrade stolon
```
helm upgrade angry-toucan -f stolon-values.yaml stolon-chart/stolon/ --namespace=stolon
```

### get pg password

```
kubectl get secret --namespace stolon angry-toucan-stolon -o jsonpath="{.data.pg_su_password}" | base64 --decode; echo
```

## Reference

https://medium.com/@SergeyNuzhdin/how-to-deploy-ha-postgresql-cluster-on-kubernetes-3bf9ed60c64f

https://github.com/CrunchyData/crunchy-containers

https://github.com/sorintlab/stolon/

https://github.com/lwolf/stolon-chart
