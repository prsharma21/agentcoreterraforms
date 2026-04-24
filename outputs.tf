output "gateway_id" {
  value       = aws_bedrockagentcore_gateway.this.gateway_id
  description = "AgentCore gateway identifier."
}

output "gateway_arn" {
  value       = aws_bedrockagentcore_gateway.this.gateway_arn
  description = "AgentCore gateway ARN."
}

output "gateway_url" {
  value       = aws_bedrockagentcore_gateway.this.gateway_url
  description = "AgentCore gateway endpoint URL."
}

output "agent_runtime_id" {
  value       = aws_bedrockagentcore_agent_runtime.this.agent_runtime_id
  description = "AgentCore agent runtime ID."
}

output "agent_runtime_arn" {
  value       = aws_bedrockagentcore_agent_runtime.this.agent_runtime_arn
  description = "AgentCore agent runtime ARN."
}

output "artifact_bucket" {
  value       = aws_s3_bucket.agent_artifact.bucket
  description = "S3 bucket holding the runtime deployment zip."
}
