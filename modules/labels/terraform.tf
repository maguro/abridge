terraform {
  # Terraform can be installed using Homebrew on macOS. However, the latest version is not
  # available in Homebrew core because Hashicorp adopted an incompatible license. So you need
  # to add the Hashicorp tap to Homebrew:
  #    brew tap hashicorp/tap
  # Then you can install the latest version with:
  #    brew install hashicorp/tap/terraform
  required_version = "~> 1.10.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.19.0"
    }
  }
}
