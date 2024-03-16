#!/bin/bash
# Parse command-line options
while getopts d:e:t: option
do
    case "${option}"
    in
        d) dir=${OPTARG};;
        e) zone=${OPTARG};;
        t) dt=${OPTARG};;
    esac
done
# Print the paths of the files and the cluster name if a YAML file exists
find "$dir" -name '*.yaml' -print0 | while IFS= read -r -d '' file
do
    echo "Path: $file"
    if [ -f "$file" ]; then
        cluster_name=$(yq e '.clusters[0].name' "$file")
        echo "The cluster name in the YAML file is: $cluster_name"
        helm template -n $cluster_name templates/helm-$zone-chart -f $file | tee sites/$dt/$zone/$cluster_name.yaml
    fi
done