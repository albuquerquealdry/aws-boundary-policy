module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name                           = "user_default"
  create_iam_user_login_profile  = true
  create_iam_access_key          = false
  tags                           = local.tags
  policy_arns                    = [dependency.policy_user.outputs.arn]
  permissions_boundary           = dependency.boundary_policy.outputs.arn
}