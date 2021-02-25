# instance profile
resource "aws_iam_role" "operation_server" {
  name        = "${local.operation_server_name}-role"
  description = "privileges for the instance-connect for ${local.operation_server_name}"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : ["ec2.amazonaws.com", "ssm.amazonaws.com"]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "operation_server" {
  role       = aws_iam_role.operation_server.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "operation_server" {
  name = "${local.operation_server_name}-instance-profile"
  role = aws_iam_role.operation_server.id
}

# instance connect
resource "aws_iam_policy" "instance_connect" {
  name        = local.instance_connect_name
  path        = "/"
  description = "Allows use of EC2 instance connect for ${local.operation_server_name}"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "ec2-instance-connect:SendSSHPublicKey",
          "Resource" : aws_instance.operation_server.arn,
          "Condition" : {
            "StringEquals" : { "ec2:osuser" : var.os_username }
          }
        },
        {
          "Effect" : "Allow",
          "Action" : "ec2:DescribeInstances",
          "Resource" : "*"
        }
      ]
  })
}

resource "aws_iam_user_policy_attachment" "instance_connect" {
  user       = element(var.operator_users, count.index)
  policy_arn = aws_iam_policy.instance_connect.arn
  count      = length(var.operator_users)
}
