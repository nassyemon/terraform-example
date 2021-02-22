// IAM Role + Policy attach for Enhanced Monitoring
data aws_iam_policy_document monitoring_rds_assume_role_policy {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource aws_iam_role rds_enhanced_monitoring {
  name        = "${var.project}-${var.env}-rds-enhanced-monitoring"
  assume_role_policy = data.aws_iam_policy_document.monitoring_rds_assume_role_policy.json
}

resource aws_iam_role_policy_attachment rds_enhanced_monitoring_policy_attach {
  role       = aws_iam_role.rds_enhanced_monitoring.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
