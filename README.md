# agentcoreterraforms

Terraform configuration for [Amazon Bedrock AgentCore](https://aws.amazon.com/bedrock/agentcore/) on AWS: an **AgentCore Gateway** (MCP, AWS IAM inbound auth) and an **AgentCore Agent Runtime** (direct Python code from S3).

**Repository:** [https://github.com/prsharma21/agentcoreterraforms](https://github.com/prsharma21/agentcoreterraforms)

## What is in this repo

| Area | Terraform file | AWS resource |
|------|----------------|--------------|
| Gateway | [`gateway.tf`](gateway.tf) | `aws_bedrockagentcore_gateway` — MCP, `authorizer_type = "AWS_IAM"` |
| Runtime | [`runtime.tf`](runtime.tf) | `aws_bedrockagentcore_agent_runtime` — code package in S3, HTTP protocol |
| IAM | [`iam.tf`](iam.tf) | Roles trusted by `bedrock-agentcore.amazonaws.com`; runtime S3 + CloudWatch Logs |
| Agent code | [`agent_code/main.py`](agent_code/main.py) | Minimal `/ping` and `/invocations` HTTP contract for direct code deploy |

Supporting files: [`versions.tf`](versions.tf), [`providers.tf`](providers.tf), [`variables.tf`](variables.tf), [`data.tf`](data.tf), [`outputs.tf`](outputs.tf).

## Prerequisites

- Terraform `>= 1.4`
- AWS credentials with permission to create IAM, S3, and Bedrock AgentCore resources
- AgentCore available in the chosen region (default `us-east-1` in [`variables.tf`](variables.tf))

## Usage

```bash
terraform init
terraform plan
terraform apply
```

Optional:

```bash
terraform apply -var='aws_region=us-east-1' -var='name_prefix=my-demo'
```

## Outputs

After apply, Terraform prints gateway identifiers, runtime ARN/ID, gateway URL, and the S3 artifact bucket. See [`outputs.tf`](outputs.tf).

## Notes

- **Not** generic EC2: this stack targets **Bedrock AgentCore** gateway and runtime APIs.
- State file is not committed; use a remote backend for teams if needed.
