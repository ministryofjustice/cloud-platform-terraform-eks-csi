
resource "helm_release" "aws_ebs" {
  name       = "aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.10.1"

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
  })]
}
