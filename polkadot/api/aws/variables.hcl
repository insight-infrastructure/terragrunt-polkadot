locals {
  ######################
  # Deployment Variables
  ######################
  namespace = "polkadot"
  stack = "api"
  provider = "aws"
  network_name = "kusama"
  environment = "dev"
  region = "eu-north-1"

  deployment_map = {
    namespace = local.namespace
    stack = local.stack
    provider = local.provider
    network_name = local.network_name
    environment = local.environment
    region = local.region
  }

  remote_state_region = "us-east-1"

  ###################
  # Environment Logic
  ###################
  env_vars = {
    dev = {}
    test = {}
    stage = {}
    prod = {}
  }[local.environment]

  deployment_id_label_order = ["namespace", "stack", "network_name", "environment","provider", "region"]
  deployment_id = join(".", [ for i in local.deployment_id_label_order : lookup(local.label_map, i)])
  deployment_vars = yamldecode(file("${find_in_parent_folders("deployments")}/${local.deployment_id}.yaml"))

  # Imports
  versions = yamldecode(file("${get_parent_terragrunt_dir()}/versions.yaml"))[local.environment]
  secrets = yamldecode(file(find_in_parent_folders("secrets.yaml")))

  ###################
  # Label Boilerplate
  ###################
  label_map = {
    namespace = local.namespace
    stack = local.stack
    provider = local.provider
    network_name = local.network_name
    environment = local.environment
    region = local.region
    global = "global"
  }

  remote_state_path_label_order = ["namespace", "stack", "provider", "network_name", "environment", "region"]
  remote_state_path = join("/", [ for i in local.remote_state_path_label_order : lookup(local.label_map, i)])

  global_remote_state_path_label_order = ["namespace", "stack", "provider", "network_name", "environment", "global"]
  global_remote_state_path = join("/", [ for i in local.global_remote_state_path_label_order : lookup(local.label_map, i)])

  id_label_order = ["namespace", "stack", "network_name", "environment"]
  id = join("-", [ for i in local.id_label_order : lookup(local.label_map, i)])

  name_label_order = ["stack", "network_name"]
  name = join("", [ for i in local.name_label_order : title(lookup(local.label_map, i))])

  tags = { for t in local.remote_state_path_label_order : t => lookup(local.label_map, t) }
}