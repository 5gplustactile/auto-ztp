# auto-ztp
This repo is aimed is to store templates of modules and workspaces to be consumed by automatically by the iac and provisioning repository 

## Process to create vpc peering

 Follow the next [link](https://www.howtoforge.com/how-to-create-a-vpc-peering-between-2-vpcs-on-aws/)

### Results of VPC Peering

<p align="center">
<img src="images/vpc-peering-0.png" alt="vpcprn-0" title=vpcprn-1 Resource>
</p>

<p align="center">
<img src="images/vpc-peering-1.png" alt="vpcprn-1" title=vpcprn-1 Resource>
</p>

You will see the Route tables once you configured these in the security groups

<p align="center">
<img src="images/vpc-peering-2.png" alt="vpcprn-2" title=vpcprn-2 Resource>
</p>

 ### Results of Route Tables

<p align="center">
<img src="images/route-table-0.png" alt="rt-0" title=rt-0 Resource>
</p>

<p align="center">
<img src="images/route-table-1.png" alt="rt-1" title=rt-1 Resource>
</p>

<p align="center">
<img src="images/route-table-2.png" alt="rt-2" title=rt-2 Resource>
</p>

<p align="center">
<img src="images/route-table-3.png" alt="rt-3" title=rt-3 Resource>
</p>

<p align="center">
<img src="images/route-table-4.png" alt="rt-4" title=rt-4 Resource>
</p>

 ### Results Security Groups

The sg-0a751dd2164c97cd1/c0-lb is of the load balancer to cluster api
<p align="center">
<img src="images/sgs-0.png" alt="sgs-0" title=sgs-0 Resource>
</p>


The sg-064b13cdf2503140e / rke2_cluster_sgs is part of the sgs cluster-mgmt

<p align="center">
<img src="images/sgs-1.png" alt="sgs-1" title=sgs-1 Resource>
</p>

## Attach the sgs to instances and lb

1. Attach the vpc_peering_clusters_api_to_cluster_mgmt to lb
<p align="center">
<img src="images/attach-0.png" alt="atth-0" title=atth-0 Resource>
</p>

1. Attach the vpc_peering_cluster_mgmt_to_clusters_api to cluster-mgmt's instances

<p align="center">
<img src="images/attach-1.png" alt="atth-1" title=atth-1 Resource>
</p>

<p align="center">
<img src="images/attach-2.png" alt="atth-2" title=atth-2 Resource>
</p>

<p align="center">
<img src="images/attach-3.png" alt="atth-3" title=atth-3 Resource>
</p>

<p align="center">
<img src="images/attach-4.png" alt="atth-4" title=atth-4 Resource>
</p>