import json
import argparse
import yaml

class NoAliasDumper(yaml.SafeDumper):
    def ignore_aliases(self, data):
        return True

def main(new_server_json, operation, file, project):
    # Get the variables
    print("PROJECT: ",project)
    
    # Get the path to the YAML file from the command-line arguments
    file_path = args.file

    # Load the YAML file
    with open(file_path, 'r') as file:
        values = yaml.safe_load(file)

    # Convert the new server JSON string to a dictionary
    new_server = json.loads(new_server_json)

    # Check if the new server exists in the servers list for addons
    for section in ['certManager', 'ingress', 'metalLB', 'longhorn', 'prometheus', 'grafana', 'awslb','skooner']:
        if operation == 'add' and new_server not in values[section]['servers']:
            # If operation is add and it doesn't exist, add the new server
            values[section]['servers'].append(new_server)
            print(f"Added server with name: {new_server['name']} and URL: {new_server['url']}")
        elif operation == 'delete' and new_server in values[section]['servers']:
            # If operation is delete and it exists, remove the new server
            values[section]['servers'].remove(new_server)
            print(f"Deleted server with name: {new_server['name']} and URL: {new_server['url']}")

    values['project'] = project
    # Write the modified values back to the YAML file
    with open(file_path, 'w') as file:
        yaml.dump(values, file, Dumper=NoAliasDumper, default_flow_style=False)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--file', required=True, help='Path of the values.yaml file')
    parser.add_argument('--operation', choices=['add', 'delete'], required=True)
    parser.add_argument('--server', required=True)
    parser.add_argument('--project', required=False, help='New project value')
    args = parser.parse_args()

    main(args.server, args.operation, args.file, args.project)