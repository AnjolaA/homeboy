```
while read namespace; do
  echo "Namespace: $namespace"
  kubectl get pods -n "$namespace" -o jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}' | tr ' ' '\n' | awk '{sum += $1} END {print "Total CPU Requests:", sum}'
done < namespaces.txt
```