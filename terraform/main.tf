resource "vault_mount" "kv_ad_mount" {
  path        = "ad"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount for Active Directory resources"
}

resource "vault_kv_secret_backend_v2" "kv_ad_backend" {
  mount = vault_mount.kv_ad_mount.path
}

resource "vault_policy" "bitlocker_policy" {
  name = "bitlocker-policy"

  policy = <<EOT
path "ad/data/*" {
  capabilities = ["list", "create", "read", "update"]
}
EOT
}

resource "vault_auth_backend" "bitlocker_approle" {
  type = "approle"
  path = "bitlocker"
}

resource "vault_approle_auth_backend_role" "bitlocker_approle_role" {
  backend        = vault_auth_backend.bitlocker_approle.path
  role_name      = "bitlocker-role"
  token_policies = ["bitlocker-policy"]
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.bitlocker_approle.path
  role_name = vault_approle_auth_backend_role.bitlocker_approle_role.role_name
}

output "role_id" {
  value   = vault_approle_auth_backend_role.bitlocker_approle_role.role_id
  sensitive = true
}

output "secret_id" {
  value   = vault_approle_auth_backend_role_secret_id.id.secret_id
  sensitive = true
}
