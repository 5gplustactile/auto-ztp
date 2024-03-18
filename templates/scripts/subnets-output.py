import json
import yaml
import argparse
import os
import glob
import subprocess
import shutil

# Set up command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('--path-ot-subnet-id', required=True, help='Path to outpost_subnet_ids.json')
parser.add_argument('--path-private-subnet-id', required=True, help='Path to private_subnet_ids.json')
parser.add_argument('--path-dir', required=True, help='Path to directory with YAML files')
parser.add_argument('--path-dest', required=True, help='Path to destination directory')
parser.add_argument('--git-token', required=True, help='GitHub token')
parser.add_argument('--git-src', required=True, help='Local path to clone the GitHub repository')
parser.add_argument('--user-name', required=True, help='User name for git config')
parser.add_argument('--user-email', required=True, help='User email for git config')
args = parser.parse_args()

# Create a new directory for the cloned repository
git_clone_dir = os.path.join(args.git_src, 'cloned_repo')

# Check if the directory exists and is empty
if os.path.exists(git_clone_dir) and os.listdir(git_clone_dir):
    print(f"Directory {git_clone_dir} already exists and is not empty. Please provide an empty directory for cloning the repository.")
    exit(1)

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
    # Clone the GitHub repository
    subprocess.run(['git', 'clone', f'https://{args.git_token}@github.com/5gplustactile/auto-ztp.git', git_clone_dir])

    # Set the local user.name and user.email for the repository
    subprocess.run(['git', '-C', git_clone_dir, 'config', '--local', 'user.name', args.user_name])
    subprocess.run(['git', '-C', git_clone_dir, 'config', '--local', 'user.email', args.user_email])

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
                        if cluster['name'] in outpost_subnets_list:
                            cluster['subnetOutpost'] = outpost_subnets_list[cluster['name']]
                        else:
                            print(f"subnetOutpost - Cluster name '{cluster['name']}' in file {yaml_file_path} does not match any keys in the subnet JSON files. No changes were made to this cluster.")

                        if cluster['name'] in private_subnets_list:
                            cluster['subnetRegion'] = private_subnets_list[cluster['name']]
                        else:
                            print(f"subnetRegion - Cluster name '{cluster['name']}' in file {yaml_file_path} does not match any keys in the subnet JSON files. No changes were made to this cluster.")
                    else:
                        print(f"No 'name' field found in cluster in file {yaml_file_path}. No changes were made to this cluster.")
                # Write the updated values back to a new YAML file in the destination directory
                dest_file_path = os.path.join(args.path_dest, os.path.basename(yaml_file_path))
                with open(dest_file_path, 'w') as f:
                    yaml.safe_dump(values, f)
                # Add the file to the git staging area
                subprocess.run(['git', '-C', git_clone_dir, 'add', dest_file_path])
            else:
                print(f"'clusters' is not a list in file {yaml_file_path}. No changes were made.")
        else:
            print(f"File {yaml_file_path} does not exist. No changes were made.")
    # Commit the changes
    subprocess.run(['git', '-C', git_clone_dir, 'commit', '-m', 'Update YAML files'])

    # Push the changes to the GitHub repository
    subprocess.run(['git', '-C', git_clone_dir, 'push'])

    # Delete the cloned repository
    shutil.rmtree(git_clone_dir)