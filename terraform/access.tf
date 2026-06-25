# ── Access: optional auth gate on the hostname ────────────────────────
# When access_enabled = true, only identities passing the policy reach the
# cloudflared origin (Cloudflare Access shows a login page first). When false,
# the hostname is open to everyone (tunnel + DNS only). Access is a hostname-
# layer control — it does NOT touch the tunnel, ConfigMap, or ArgoCD sync.

resource "cloudflare_zero_trust_access_application" "demo_argo" {
  count            = var.access_enabled ? 1 : 0
  account_id       = var.cloudflare_account_id
  name             = "Demo Argo (k8s)"
  domain           = var.hostname
  type             = "self_hosted"
  session_duration = "1h"

  # Offer the configured IdPs (Entra SSO and/or One-time PIN) and show the
  # login picker. compact() drops blank ids. Empty list = all available IdPs.
  allowed_idps              = compact([var.entra_idp_id, var.otp_idp_id])
  auto_redirect_to_identity = false

  # v5: the app references its policies inline by id + precedence.
  policies = [{
    id         = cloudflare_zero_trust_access_policy.demo_argo_allow[0].id
    precedence = 1
  }]
}

resource "cloudflare_zero_trust_access_policy" "demo_argo_allow" {
  count      = var.access_enabled ? 1 : 0
  account_id = var.cloudflare_account_id
  name       = "Allow ${var.allowed_email_domain}"
  decision   = "allow"
  include = [
    { email_domain = { domain = var.allowed_email_domain } }
  ]
}
