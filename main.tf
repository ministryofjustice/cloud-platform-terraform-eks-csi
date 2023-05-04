resource "helm_release" "aws_ebs" {
  name       = "aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.10.1"

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }

  dynamic "toleration" {
    for_each = var.tolerations
    content {
      key      = toleration.value["key"]
      operator = toleration.value["operator"]
      value    = toleration.value["value"]
      effect   = toleration.value["effect"]
    }
  }

  depends_on = [module.ebs_irsa]
}
