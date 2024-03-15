#!/bin/bash -x
# Initialize counter
num_files=0
# Parse command-line options
while getopts d:z:dt: option
do
    case "${option}"
    in
        d) dir=${OPTARG};;
        z) zone=${OPTARG};;
        b) dt=${OPTARG};;
    esac
done
# Print the paths of the files and the cluster name if a YAML file exists
find "$dir" -name '*.yaml' -print0 | while IFS= read -r -d '' file
do
    echo "Path: $file"
    if [ -f "$file" ]; then
        cluster_name=$(yq e '.clusters[0].name' "$file")
        echo "The cluster name in the YAML file is: $cluster_name"
        helm template -n $cluster_name auto-ztp/templates/helm-$zone-chart -f $file > auto-ztp/sites/$dt/$zone/$cluster_name.yaml 2> /dev/null
    fi
    ((num_files++))
done

echo "Found $num_files YAML files in the $dir directory."
