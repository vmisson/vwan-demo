output "id" {
  value = module.virtual-network.id
}

output "subnets-id" {
  value = values(module.subnet).*.subnet_id
}