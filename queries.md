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

```

```#!/bin/bash

# Define the output file
output_file="deployments_with_v1d1.txt"

# Clear the output file if it exists
> "$output_file"

# Get all deployments in all namespaces and filter for those containing 'v1d1'
kubectl get deployments --all-namespaces -o jsonpath='{range .items[?(@.metadata.name contains "v1d1")]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}' >> "$output_file"

echo "Deployment names containing 'v1d1' and their namespaces have been written to $output_file."
