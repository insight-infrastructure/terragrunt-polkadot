terraform {
  source = "."
}

include {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("global.yaml")}"))
  secrets = yamldecode(file("${get_terragrunt_dir()}/${find_in_parent_folders("secrets.yaml")}"))
}

inputs = {
  name = local.global.packet_hostname
  project_name = local.global.packet_project_name
  public_key = file(local.secrets["public_key_path"])
}
