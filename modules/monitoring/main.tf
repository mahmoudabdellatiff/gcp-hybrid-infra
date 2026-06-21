resource "google_monitoring_uptime_check_config" "nginx_uptime" { // to monitor the service if it is available for the user or not 
  display_name = "nginx-uptime-check"
  timeout      = "10s"
  period       = "60s"
  project      = var.project_id

  http_check {
    path         = "/"
    port         = 80
    use_ssl      = false // don`t use https 
    validate_ssl = false // do not care about ssl certificate 
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.public_vm_ip
    }
  }
}

resource "google_monitoring_notification_channel" "email" { // to send notification 
  display_name = "DevOps alert email"
  type         = "email"
  project      = var.project_id
  labels = {
    email_address = var.alert_email
  }
}

resource "google_monitoring_alert_policy" "nginx_down" {
  display_name = "nginx_down-alert"
  combiner     = "OR" // if get more condition , one condition enough 
  project      = var.project_id

  conditions {
    display_name = "uptime check failed"
    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\""
      duration        = "120s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.host"]
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.id
  ]

  alert_strategy {
    auto_close = "1800s"
  }

}
