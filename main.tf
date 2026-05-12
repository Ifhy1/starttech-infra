terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source = "./modules/networking"
}

module "storage" {
  source      = "./modules/storage"
  environment = "dev"
}

# COMBINED COMPUTE MODULE
module "compute" {
  source          = "./modules/compute"
  vpc_id          = module.networking.vpc_id
  public_subnet_1 = module.networking.public_subnet_1
  public_subnet_2 = module.networking.public_subnet_2 
}

module "redis" {
  source            = "./modules/redis"
  vpc_id            = module.networking.vpc_id
  private_subnet_id = module.networking.private_subnet_id
  backend_sg_id     = module.compute.backend_sg_id 
}

output "alb_dns_name" {
  value = module.compute.alb_dns_name
}