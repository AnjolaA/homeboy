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

while read namespace; do
  echo "Namespace: $namespace" | tee -a "$output_file"
  kubectl get pods -n "$namespace" -o jsonpath='{.items[*].spec.containers[*].resources.requests.cpu}' | tr ' ' '\n' | awk '
    BEGIN {sum = 0}
    {
      if ($1 ~ /m$/) {
        sum += substr($1, 1, length($1)-1)
      } else {
        sum += $1 * 1000
      }
    } 
    END {
      printf "Total CPU Requests: %s m\n", sum
    }
  ' | tee -a "$output_file"
  echo "" | tee -a "$output_file"  # Add a blank line for readability
done < namespaces.txt

echo "Results have been written to $output_file"
