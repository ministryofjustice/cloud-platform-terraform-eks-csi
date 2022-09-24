
resource "helm_release" "aws_ebs" {
  name       = "aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.11.1"

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }

  depends_on = [module.ebs_irsa]
}
