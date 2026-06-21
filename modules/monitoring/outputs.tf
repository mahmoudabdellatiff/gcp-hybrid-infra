output "uptime_check_id" {
  value = google_monitoring_uptime_check_config.nginx_uptime.uptime_check_id
}

output "alert_policy_name" {
  value = google_monitoring_alert_policy.nginx_down.name
}
