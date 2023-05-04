resource "aws_iam_policy" "dynamodb" {
  name        = "app-task-policy-dynamodb"
  description = "Policy that allows access to DynamoDB"
 
 policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "dynamodb:DescribeTable",
               "dynamodb:ListTables",
               "dynamodb:GetItem",
               "dynamodb:Scan",
               "dynamodb:Query"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = var.ecs_task_role_name
  policy_arn = aws_iam_policy.dynamodb.arn
}