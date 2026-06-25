# ── Outputs ───────────────────────────────────────────────────────────
output "hostname_url" {
  value       = "https://${var.hostname}"
  description = "Public URL served by the tunnel."
}

output "cname_target" {
  value       = "${var.tunnel_id}.cfargotunnel.com"
  description = "Proxied CNAME target the hostname points at."
}

output "access_gated" {
  value       = var.access_enabled
  description = "Whether the hostname is behind Cloudflare Access (true) or open (false)."
}

output "access_app_id" {
  value       = var.access_enabled ? cloudflare_zero_trust_access_application.demo_argo[0].id : "(open — no Access app)"
  description = "Access application id, when the auth gate is enabled."
}
