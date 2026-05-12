output "final_public_ip" {
  value = module.compute.instance_public_ip
}

output "frontend_url" {
  value = module.storage.website_url
}

output "redis_endpoint" {
  value = module.redis.redis_endpoint
}