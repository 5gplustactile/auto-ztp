import json
import yaml
import argparse
import os
import glob

# Set up command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('--path-ot-subnet-id', required=True, help='Path to outpost_subnet_ids.json')
parser.add_argument('--path-private-subnet-id', required=True, help='Path to private_subnet_ids.json')
parser.add_argument('--path-dir', required=True, help='Path to directory with YAML files')
parser.add_argument('--path-dest', required=True, help='Path to destination directory')
args = parser.parse_args()

# Read the JSON files
with open(args.path_ot_subnet_id, 'r') as f:
    outpost_subnets = json.load(f)
with open(args.path_private_subnet_id, 'r') as f:
    private_subnets = json.load(f)

# Convert the JSON values to lists
outpost_subnets_list = {k: [v] for k, v in outpost_subnets.items()}
private_subnets_list = {}
for k, v in private_subnets.items():
    name = k.rsplit('-', 1)[0]
    if name not in private_subnets_list:
        private_subnets_list[name] = []
    private_subnets_list[name].append(v)

# Check if there are any YAML files in the specified directory
yaml_files = glob.glob(os.path.join(args.path_dir, '*.yaml'))
if not yaml_files:
    print(f"No YAML files found in {args.path_dir}. No changes were made.")
else:
    # Iterate over all YAML files in the specified directory
    for yaml_file_path in yaml_files:
        # Check if the file exists
        if os.path.exists(yaml_file_path):
            # Read the YAML file
            with open(yaml_file_path, 'r') as f:
                values = yaml.safe_load(f)

            # Check if 'clusters' is a list
            if isinstance(values.get('clusters'), list):
                # Update the YAML file
                for cluster in values['clusters']:
                    if 'name' in cluster:
                        if cluster['name'] in outpost_subnets_list and cluster['name'] in private_subnets_list:
                            cluster['subnetOutpost'] = outpost_subnets_list[cluster['name']]
                            cluster['subnetRegion'] = private_subnets_list[cluster['name']]
                        else:
                            print(f"Cluster name '{cluster['name']}' in file {yaml_file_path} does not match any keys in the subnet JSON files. No changes were made to this cluster.")
                    else:
                        print(f"No 'name' field found in cluster in file {yaml_file_path}. No changes were made to this cluster.")

                # Write the updated values back to a new YAML file in the destination directory
                dest_file_path = os.path.join(args.path_dest, os.path.basename(yaml_file_path))
                with open(dest_file_path, 'w') as f:
                    yaml.safe_dump(values, f)
            else:
                print(f"'clusters' is not a list in file {yaml_file_path}. No changes were made.")
        else:
            print(f"File {yaml_file_path} does not exist. No changes were made.")
