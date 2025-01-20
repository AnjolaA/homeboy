```
while read namespace; do
  echo "Namespace: $namespace"
  kubectl get pods -n "$namespace" -o jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}' | tr ' ' '\n' | awk '{sum += $1} END {print "Total CPU Requests:", sum}'
done < namespaces.txt
```

```
while read namespace; do
  echo "Namespace: $namespace"
  kubectl get pods -n "$namespace" -o jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}' | tr ' ' '\n' | awk '
    {
      if ($1 ~ /m$/) {
        sum += substr($1, 1, length($1)-1)
      } else {
        sum += $1 * 1000
      }
    } 
    END {
      print "Total CPU Requests:", sum, "m"
    }
  '
done < namespaces.txt
```