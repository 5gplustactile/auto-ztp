resource "aws_ssm_document" "netplan" {
  name          = "${var.name_digital_twins}-netplan-document"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2",
    description   = "Run a bash script on the instance",
    parameters    = {
      commands = {
        type        = "StringList",
        description = "The bash commands to run",
        default     = ["sudo netplan apply && sudo ip link set ens6 up"]
      }
    },
    mainSteps = [
      {
        action = "aws:runShellScript",
        name   = "runShellScript",
        inputs = {
          runCommand = ["{{ commands }}"]
        }
      }
    ]
  })
}

resource "aws_ssm_association" "netplan_ssm" {
  for_each = var.instances
  name     = aws_ssm_document.netplan.name
  targets {
    key = "InstanceIds"
    values = [ each.key ]
 }
}
