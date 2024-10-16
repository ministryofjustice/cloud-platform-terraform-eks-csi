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

  statement {
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "CreateVolume",
        "CreateSnapshot"
      ]
    }
  }


  statement {
    actions = [
      "ec2:DeleteTags"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
  }

  statement {
    actions = [
      "ec2:CreateVolume"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }

  statement {
    actions = [
      "ec2:CreateVolume"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values = [
        "true"
      ]
    }
  }

  statement {
    actions = [
      "ec2:CreateVolume"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values = [
        "owned"
      ]
    }
  }

  statement {
    actions = [
      "ec2:DeleteVolume"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }

  statement {
    actions = [
      "ec2:DeleteVolume"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values = [
        "true"
      ]
    }
  }

  statement {
    actions = [
      "ec2:DeleteVolume"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/kubernetes.io/cluster/*"
      values = [
        "owned"
      ]
    }
  }

  statement {
    actions = [
      "ec2:DeleteSnapshot"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values = [
        "*"
      ]
    }
  }

  statement {
    actions = [
      "ec2:DeleteSnapshot"
    ]
    resources = [
      "*",
    ]
    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:CreateGrant"
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
  source = "github.com/ministryofjustice/cloud-platform-terraform-irsa?ref=2.0.0"

  eks_cluster      = var.eks_cluster
  namespace        = "kube-system"
  service_account  = "ebs-csi-controller-sa"
  role_policy_arns = [aws_iam_policy.ebs_policy.arn]
}
