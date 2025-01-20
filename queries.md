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

```
output_file="cpu_requests_summary.txt"

# Clear the file if it already exists
> "$output_file"

echo "Namespace,CPU_Requests_Millicores" | tee -a "$output_file"

while read namespace; do
  cpu_requests=$(kubectl get pods -n "$namespace" -o jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}' | tr ' ' '\n' | awk '
    BEGIN {sum = 0}
    {
      if ($1 ~ /m$/) {
        sum += substr($1, 1, length($1)-1)
      } else {
        sum += $1 * 1000
      }
    } 
    END {
      print sum
    }
  ')
  echo "$namespace,$cpu_requests" | tee -a "$output_file"
done < namespaces.txt

echo "Results have been written to $output_file"
