# ── DNS: route the public hostname to the manually-built tunnel ───────
# Proxied CNAME  hostname -> <tunnel_id>.cfargotunnel.com  (orange-cloud).
# This is the Terraform equivalent of `cloudflared tunnel route dns`. The
# tunnel itself is created out-of-band (manual); we only point DNS at it.
resource "cloudflare_dns_record" "tunnel" {
  zone_id = var.zone_id
  name    = var.hostname
  type    = "CNAME"
  content = "${var.tunnel_id}.cfargotunnel.com"
  proxied = true
  ttl     = 1 # 1 = automatic (required when proxied)
  comment = "demo-argo k8s tunnel route (managed by Terraform)"
}
