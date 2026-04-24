resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "agent_artifact" {
  bucket        = "${var.name_prefix}-artifact-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "agent_artifact" {
  bucket = aws_s3_bucket.agent_artifact.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "agent_artifact" {
  bucket                  = aws_s3_bucket.agent_artifact.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "archive_file" "agent_zip" {
  type        = "zip"
  source_dir  = "${path.module}/agent_code"
  output_path = "${path.module}/.terraform/agent-runtime-code.zip"
}

resource "aws_s3_object" "agent_code" {
  bucket = aws_s3_bucket.agent_artifact.id
  key    = "agent-runtime-code.zip"
  source = data.archive_file.agent_zip.output_path
  etag   = data.archive_file.agent_zip.output_md5
}

resource "aws_bedrockagentcore_agent_runtime" "this" {
  agent_runtime_name = replace("${var.name_prefix}_runtime", "-", "_")
  description        = "Terraform-managed AgentCore runtime (direct code / HTTP contract)."
  role_arn           = aws_iam_role.runtime.arn

  agent_runtime_artifact {
    code_configuration {
      entry_point = ["main.py"]
      runtime     = "PYTHON_3_13"
      code {
        s3 {
          bucket = aws_s3_bucket.agent_artifact.bucket
          prefix = aws_s3_object.agent_code.key
        }
      }
    }
  }

  network_configuration {
    network_mode = "PUBLIC"
  }

  protocol_configuration {
    server_protocol = "HTTP"
  }

  depends_on = [
    aws_iam_role_policy.runtime_execution,
    aws_s3_object.agent_code,
  ]
}
