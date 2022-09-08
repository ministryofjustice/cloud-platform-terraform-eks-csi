# cloud-platform-terraform-eks-csi

EKS CSI storage backend for Kubernetes (EBS volumes). Required for GP3 support and for K8s >1.22

## Usage

See the [examples/](examples/) folder.

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->

## Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidance](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |

## Reading Material

Chart: https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/charts/aws-ebs-csi-driver

Installation docs: https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md
