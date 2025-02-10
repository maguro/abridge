##
## Give a Bastion Account access to the bastion a5e-dev-train-bastion-tf
##
module "train_access" {
  source  = "../../../modules/bastion/access"
  env     = "dev"
  project = var.project
  cluster = "train"

  ##
  ## Replace w/ desired Bastion Account
  ##
  email   = "alan.cabrera@gmail.com"

  depends_on = [module.dev_environment]
}

##
## Give a Bastion Account access to the bastion a5e-dev-fe-bastion-tf
##
module "fe_access" {
  source  = "../../../modules/bastion/access"
  env     = "dev"
  project = var.project
  cluster = "fe"

  ##
  ## Replace w/ desired Bastion Account
  ##
  email   = "alan.cabrera@gmail.com"

  depends_on = [module.dev_environment]
}
