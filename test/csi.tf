module "csi" {
  source = "../"
  # "github.com/ministryofjustice/cloud-platform-terraform-eks-csi?ref=1.0.0"
  eks_cluster = "csi-test"
}
