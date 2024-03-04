# Helm cluster addons

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0](https://img.shields.io/badge/AppVersion-1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| awslb.enable | bool | `true` |  |
| awslb.servers | list | `[]` |  |
| awslb.version | string | `"1.6.2"` |  |
| certManager.enable | bool | `true` |  |
| certManager.servers | list | `[]` |  |
| certManager.version | string | `"v1.13.3"` |  |
| externalSecret.enable | bool | `true` |  |
| externalSecret.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| externalSecret.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-262710596.eu-west-3.elb.amazonaws.com:6443"` |  |
| externalSecret.servers[0].values.installCRDs | bool | `true` |  |
| externalSecret.version | string | `"0.9.13"` |  |
| grafana.enable | bool | `true` |  |
| grafana.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| grafana.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-262710596.eu-west-3.elb.amazonaws.com:6443"` |  |
| grafana.servers[0].values.ingress.annotations."alb.ingress.kubernetes.io/load-balancer-name" | string | `"grafana-system"` |  |
| grafana.servers[0].values.ingress.annotations."alb.ingress.kubernetes.io/scheme" | string | `"internal"` |  |
| grafana.servers[0].values.ingress.annotations."alb.ingress.kubernetes.io/tags" | string | `"tactile5g/digital-twins=grafana-system"` |  |
| grafana.servers[0].values.ingress.annotations."alb.ingress.kubernetes.io/target-type" | string | `"instance"` |  |
| grafana.servers[0].values.ingress.className | string | `"alb"` |  |
| grafana.servers[0].values.ingress.enabled | bool | `false` |  |
| grafana.servers[0].values.ingress.environment | string | `"region"` |  |
| grafana.version | string | `"main"` |  |
| ingress.enable | bool | `false` |  |
| ingress.servers | list | `[]` |  |
| ingress.version | string | `"4.9.0"` |  |
| kubeClarity.enable | bool | `true` |  |
| kubeClarity.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| kubeClarity.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-262710596.eu-west-3.elb.amazonaws.com:6443"` |  |
| kubeClarity.servers[0].values.kubeclarity.ingress.annotations."alb.ingress.kubernetes.io/load-balancer-name" | string | `"kubeclarify-system"` |  |
| kubeClarity.servers[0].values.kubeclarity.ingress.annotations."alb.ingress.kubernetes.io/scheme" | string | `"internal"` |  |
| kubeClarity.servers[0].values.kubeclarity.ingress.annotations."alb.ingress.kubernetes.io/tags" | string | `"tactile5g/digital-twins=kubeclarify-system"` |  |
| kubeClarity.servers[0].values.kubeclarity.ingress.annotations."alb.ingress.kubernetes.io/target-type" | string | `"instance"` |  |
| kubeClarity.servers[0].values.kubeclarity.ingress.enabled | bool | `false` |  |
| kubeClarity.servers[0].values.kubeclarity.ingress.ingressClassName | string | `"alb"` |  |
| kubeClarity.servers[0].values.kubeclarity.service.type | string | `"LoadBalancer"` |  |
| kubeClarity.version | string | `"v2.23.1"` |  |
| longhorn.enable | bool | `true` |  |
| longhorn.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| longhorn.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-262710596.eu-west-3.elb.amazonaws.com:6443"` |  |
| longhorn.servers[0].values.ingress.enabled | bool | `false` |  |
| longhorn.servers[0].values.ingress.host | string | `"storage.tactile5g.int"` |  |
| longhorn.servers[0].values.ingress.ingressClassName | string | `"nginx"` |  |
| longhorn.version | string | `"1.6.0"` |  |
| metalLB.enable | bool | `false` |  |
| metalLB.servers | list | `[]` |  |
| metalLB.version | string | `"0.13.12"` |  |
| metricServer.enable | bool | `true` |  |
| metricServer.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| metricServer.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-942763084.eu-west-3.elb.amazonaws.com:6443"` |  |
| metricServer.version | string | `"6.9.3"` |  |
| project | string | `"telefonica"` |  |
| prometheus.enable | bool | `true` |  |
| prometheus.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| prometheus.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-262710596.eu-west-3.elb.amazonaws.com:6443"` |  |
| prometheus.servers[0].values.ingress.className | string | `"alb"` |  |
| prometheus.servers[0].values.ingress.enabled | bool | `false` |  |
| prometheus.servers[0].values.ingress.environment | string | `"region"` |  |
| prometheus.version | string | `"main"` |  |
| skooner.enable | bool | `true` |  |
| skooner.servers[0].name | string | `"telefonica-region-example-region-0"` |  |
| skooner.servers[0].url | string | `"https://internal-kiq4etp7ipf0gzp7qnbo01gtp7ew-k8s-262710596.eu-west-3.elb.amazonaws.com:6443"` |  |
| skooner.servers[0].values.ingress.className | string | `"alb"` |  |
| skooner.servers[0].values.ingress.enabled | bool | `false` |  |
| skooner.servers[0].values.ingress.environment | string | `"region"` |  |
| skooner.version | string | `"main"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
