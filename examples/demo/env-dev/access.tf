/*
  Give a Operator Account access to the bastion a5e-dev-train-bastion-tf
 */
module "train_access" {
  source  = "../../../modules/bastion/access"
  env     = "dev"
  project = var.project
  cluster = "train"

  email = var.bastion_account

  # ensure environment has been built
  depends_on = [module.dev_environment]
}

/*
  Give a Operator Account access to the bastion a5e-dev-fe-bastion-tf
 */
module "fe_access" {
  source  = "../../../modules/bastion/access"
  env     = "dev"
  project = var.project
  cluster = "fe"

  email = var.bastion_account

  # ensure environment has been built
  depends_on = [module.dev_environment]
}
