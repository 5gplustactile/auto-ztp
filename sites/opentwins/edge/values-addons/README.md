# How to update the Addons?

````
# execute this command to update the app-NAME_DT.yaml file.
# example:
$ helm template auto-ztp/templates/helm-cluster-addons -f auto-ztp/sites/opentwins/edge/values-addons/ad-opentwins.yaml > auto-ztp/sites/opentwins/edge/addons/app-opentwins.yaml

# push the changes in auto-ztp repository in main branch. ArgoCD automatically updathe the changes.
````
