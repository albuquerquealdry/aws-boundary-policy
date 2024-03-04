module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name_prefix = "boundary-users-operate"
  path        = "/"
  description = "boundary-users-operate"
  policy      = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid     = "IAMAccess"
        Effect  = "Allow"
        Action  = "iam:*"
        Resource = "*"
      },
      {
        Sid      = "DenyPermBoundaryIAMPolicyAlteration"
        Effect   = "Deny"
        Action   = [
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:CreatePolicyVersion",
          "iam:SetDefaultPolicyVersion"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:policy/${local.name_policy}-PermissionsBoundary"
        ]
      },
      {
        Sid      = "DenyRemovalOfPermBoundaryFromAnyUserOrRole"
        Effect   = "Deny"
        Action   = [
          "iam:DeleteUserPermissionsBoundary",
          "iam:DeleteRolePermissionsBoundary"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:user/*",
          "arn:aws:iam::${local.account_id}:role/*"
        ]
        Condition = {
          StringEquals = {
            "iam:PermissionsBoundary" = "arn:aws:iam::${local.account_id}:policy/${local.name_policy}-PermissionsBoundary"
          }
        }
      },
      {
        Sid      = "DenyAccessIfRequiredPermBoundaryIsNotBeingApplied"
        Effect   = "Deny"
        Action   = [
          "iam:PutUserPermissionsBoundary",
          "iam:PutRolePermissionsBoundary"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:user/*",
          "arn:aws:iam::${local.account_id}:role/*"
        ]
        Condition = {
          StringNotEquals = {
            "iam:PermissionsBoundary" = "arn:aws:iam::${local.account_id}:policy/${local.name_policy}-PermissionsBoundary"
          }
        }
      },
      {
        Sid      = "DenyUserAndRoleCreationWithOutPermBoundary"
        Effect   = "Deny"
        Action   = [
          "iam:CreateUser",
          "iam:CreateRole"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:user/*",
          "arn:aws:iam::${local.account_id}:role/*"
        ]
        Condition = {
          StringNotEquals = {
            "iam:PermissionsBoundary" = "arn:aws:iam::${local.account_id}:policy/${local.name_policy}-PermissionsBoundary"
          }
        }
      }
    ]
  })
  tags = local.tags
}
