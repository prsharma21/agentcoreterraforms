variable "aws_region" {
  type        = string
  description = "AWS region where AgentCore resources are created (AgentCore must be available in this region)."
  default     = "us-east-1"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names (letters, numbers, hyphen)."
  default     = "demo-agentcore"
}
