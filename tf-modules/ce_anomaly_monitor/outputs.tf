output "aws_ce_anomaly_monitor_ids" {
  description = "The IDs of the anomaly monitors"
  value       = [for i in aws_ce_anomaly_monitor.this : i.id]
}

output "aws_ce_anomaly_monitor_arns" {
  description = "The ARNs of the anomaly monitors"
  value       = [for i in aws_ce_anomaly_monitor.this : i.arn]
}
