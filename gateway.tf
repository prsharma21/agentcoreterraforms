resource "aws_bedrockagentcore_gateway" "this" {
  name     = "${var.name_prefix}-gateway"
  role_arn = aws_iam_role.gateway.arn

  authorizer_type = "AWS_IAM"
  protocol_type   = "MCP"

  description = "Terraform-managed AgentCore MCP gateway (IAM inbound auth)."

  depends_on = [aws_iam_role.gateway]
}
