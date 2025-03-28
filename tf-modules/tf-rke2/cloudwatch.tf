resource "aws_sns_topic" "alarm" {
  count = var.monitoring ? 1 : 0

  name = "${var.vpc_name}-topic"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.monitoring ? length(var.email_list) : 0

  topic_arn = aws_sns_topic.alarm[0].arn
  protocol  = "email"
  endpoint  = var.email_list[count.index]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_masters" {
    count = var.monitoring ? length(local.list_ec2) : 0

    alarm_name          = "master-memory-high-${element(local.list_ec2, count.index)}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "mem_used_percent"
    namespace           = "CWAgent"
    period              = "1800"
    statistic           = "Average"
    threshold           = "80"
    alarm_description   = "This metric checks if memory utilization is greater than 80%"
    alarm_actions       = [aws_sns_topic.alarm[0].arn]
    dimensions = {
      InstanceId = element(local.list_ec2, count.index)
    }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization_workers" {
    count = var.monitoring ?  length(local.list_ec2_workers) : 0

    alarm_name          = "worker-memory-high-${element(local.list_ec2_workers, count.index)}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "mem_used_percent"
    namespace           = "CWAgent"
    period              = "1800"
    statistic           = "Average"
    threshold           = "80"
    alarm_description   = "This metric checks if memory utilization is greater than 80%"
    alarm_actions       = [aws_sns_topic.alarm[0].arn]
    dimensions = {
      InstanceId = element(local.list_ec2_workers, count.index)
    }
}

resource "aws_cloudwatch_metric_alarm" "disk_space_utilization_masters" {
    count = var.monitoring ? length(local.list_ec2) : 0

    alarm_name          = "master-disk-space-high-${element(local.list_ec2, count.index)}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "disk_used_percent"
    namespace           = "CWAgent"
    period              = "1800"
    statistic           = "Average"
    threshold           = "80"
    alarm_description   = "This metric checks if disk space utilization is greater than 80%"
    dimensions = {
      InstanceId = element(local.list_ec2, count.index)
      path       = "/"
      device     = "nvme0n1p1"
      fstype     = "ext4"
    }
}


resource "aws_cloudwatch_metric_alarm" "disk_space_utilization_workers" {
    count = var.monitoring ? length(local.list_ec2_workers) : 0

    alarm_name          = "worker-disk-space-high-${element(local.list_ec2_workers, count.index)}"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "disk_used_percent"
    namespace           = "CWAgent"
    period              = "1800"
    statistic           = "Average"
    threshold           = "80"
    alarm_description   = "This metric checks if disk space utilization is greater than 80%"
    dimensions = {
      InstanceId = element(local.list_ec2_workers, count.index)
      path       = "/"
      device     = "nvme0n1p1"
      fstype     = "ext4"
    }
}

resource "aws_cloudwatch_dashboard" "dashboard_cluster" {
  count = var.monitoring ? 1 : 0

  dashboard_name = "${var.vpc_name}-dashboard"
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ${join(",\n", [for instance in values(module.ec2_instance) : "[ \"CWAgent\", \"disk_used_percent\", \"InstanceId\", \"${instance.id != "" ? instance.id : ""}\", \"path\", \"/\", \"device\", \"nvme0n1p1\", \"fstype\", \"ext4\" ]"])}
        ],
        "period": 1800,
        "stat": "Average",
        "region": "${local.region}",
        "title": "Masters Disk Used Percent"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ${join(",\n", [for instance in values(module.ec2_instance) : "[ \"CWAgent\", \"mem_used_percent\", \"InstanceId\", \"${instance.id != "" ? instance.id : ""}\" ]"])}
        ],
        "period": 1800,
        "stat": "Average",
        "region": "${local.region}",
        "title": "Masters Memory Used Percent"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 12,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ${join(",\n", [for instance in values(aws_instance.ec2_instance_workers) : "[ \"CWAgent\", \"disk_used_percent\", \"InstanceId\", \"${instance.id != "" ? instance.id : ""}\", \"path\", \"/\", \"device\", \"nvme0n1p1\", \"fstype\", \"ext4\" ]"])}
        ],
        "period": 1800,
        "stat": "Average",
        "region": "${local.region}",
        "title": "Workers Disk Used Percent"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 18,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ${join(",\n", [for instance in values(aws_instance.ec2_instance_workers) : "[ \"CWAgent\", \"mem_used_percent\", \"InstanceId\", \"${instance.id != "" ? instance.id : ""}\" ]"])}
        ],
        "period": 1800,
        "stat": "Average",
        "region": "${local.region}",
        "title": "Workers Memory Used Percent"
      }
    }
  ]
}
EOF
}