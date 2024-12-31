output "role_id" {
  value   = vault_approle_auth_backend_role.bitlocker_approle_role.role_id
  sensitive = true
}

output "secret_id" {
  value   = vault_approle_auth_backend_role_secret_id.id.secret_id
  sensitive = true
}