# ── Variables ─────────────────────────────────────────────────────────
# HYBRID model: the demo-argo tunnel/connector is built MANUALLY (cloudflared
# CLI or the dashboard, see README Step 1). Terraform here manages only the
# DNS route to that tunnel + the Cloudflare Access auth gate — the parts that
# benefit from IaC. TF does NOT create the tunnel.

variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Scoped API token: Zone DNS Edit + Access (Apps/Policies, Orgs/IdP/Groups) Edit."
}

variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare account ID that owns the Access org + tunnel."
}

variable "zone_id" {
  type        = string
  description = "Zone ID for the hostname's domain (e.g. itlinux.cc)."
}

variable "hostname" {
  type        = string
  default     = "demo-argo.itlinux.cc"
  description = "Public hostname routed to the tunnel. MUST match the ConfigMap ingress hostname."
}

# The MANUALLY-created tunnel's ID. Get it after `cloudflared tunnel create demo-argo`
# (or from the dashboard Connectors view): cloudflared tunnel list.
variable "tunnel_id" {
  type        = string
  description = "ID of the manually-built demo-argo tunnel (CNAME target = <tunnel_id>.cfargotunnel.com)."
}

# ── Access (auth gate) toggle + identities ────────────────────────────
variable "access_enabled" {
  type        = bool
  default     = true
  description = "true = gate the hostname behind Cloudflare Access (SSO/PIN). false = open to everyone."
}

variable "allowed_email_domain" {
  type        = string
  default     = "itlinux.cc"
  description = "Email domain allowed through the Access policy."
}

variable "entra_idp_id" {
  type        = string
  default     = ""
  description = "Optional azureAD IdP id to offer as a login method. Blank = omit."
}

variable "otp_idp_id" {
  type        = string
  default     = ""
  description = "Optional One-time PIN IdP id to offer as a login method. Blank = omit."
}
