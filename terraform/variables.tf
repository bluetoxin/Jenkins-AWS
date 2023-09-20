variable "AWS_REGION" {
  default = "eu-north-1"
  type    = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.AWS_REGION))
    error_message = "AWS_REGION isn't valid. It should be in format 'us-west-1'"
  }
}

variable "AWS_AMI_CONTROLLER" {
  default = "ami-0989fb15ce71ba39e" # Ubuntu 22.04 (x86-64)
  type    = string
  validation {
    condition     = substr(var.AWS_AMI_CONTROLLER, 0, 4) == "ami-" && length(var.AWS_AMI_CONTROLLER) > 4
    error_message = "AWS_AMI_CONTROLLER isn't valid. It should be in format 'ami-1235aa'"
  }
}

variable "AWS_AMI_AGENT" {
  default = "ami-0ebb6753c095cb52a" # Ubuntu 22.04 (ARM64)
  type    = string
  validation {
    condition     = substr(var.AWS_AMI_AGENT, 0, 4) == "ami-" && length(var.AWS_AMI_AGENT) > 4
    error_message = "AWS_AMI_AGENT isn't valid. It should be in format 'ami-1235aa'"
  }
}

variable "AWS_INSTANCE_TYPE_CONTROLLER" {
  default = "t3.micro"
  type    = string
  validation {
    condition     = can(regex("^[a-z0-9]+.[a-z0-9]+$", var.AWS_INSTANCE_TYPE_CONTROLLER))
    error_message = "AWS_INSTANCE_TYPE_CONTROLLER isn't valid. It should be in format 't3.micro'"
  }
}

variable "AWS_INSTANCE_TYPE_AGENT" {
  default = "t4g.small"
  type    = string
  validation {
    condition     = can(regex("^[a-z0-9]+.[a-z0-9]+$", var.AWS_INSTANCE_TYPE_AGENT))
    error_message = "AWS_INSTANCE_TYPE_AGENT isn't valid. It should be in format 't3.micro'"
  }
}

variable "AWS_AGENT_AMOUNT" {
  default = 2
  type    = number
}

variable "OPEN_PORTS" {
  default = [
    8080,
    22
  ]
  type = set(number)
}
