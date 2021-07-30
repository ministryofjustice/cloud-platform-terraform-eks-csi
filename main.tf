data "aws_iam_policy_document" "ebs_doc" {
  statement {
    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:CreateVolume",
      "ec2:DetachVolume",
      "ec2:DeleteVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "sts:AssumeRoleWithWebIdentity"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ebs_policy" {
  name        = "eks-csi-policy-${var.eks_cluster}"
  path        = "/cloud-platform/"
  policy      = data.aws_iam_policy_document.ebs_doc.json
  description = "Policy for EKS CSI driver"
}

module "ebs_irsa" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=1.0.2"

  eks_cluster      = var.eks_cluster
  namespace        = "kube-system"
  service_account  = "ebs-csi-controller-sa"
  role_policy_arns = [aws_iam_policy.ebs_policy.arn]
}

resource "helm_release" "aws_ebs" {
  name       = "aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = "2.0.3"

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }

  depends_on = [module.ebs_irsa]
}
