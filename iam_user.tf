
resource "aws_iam_user" "candidate" {
  name = "candidate"
}

resource "aws_iam_user_login_profile" "candidate" {
  user                    = aws_iam_user.candidate.name
  password_length         = 12
  password_reset_required = false
}

resource "aws_iam_access_key" "candidate" {
  user = aws_iam_user.candidate.name
}

resource "aws_iam_user_policy_attachment" "candidate_AdministratorAccess" {
  user       = aws_iam_user.candidate.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "password" {
  value     = aws_iam_user_login_profile.candidate.password
  sensitive = true
}

output "access_key" {
  value     = aws_iam_access_key.candidate.id
  sensitive = true
}

output "secret_key" {
  value     = aws_iam_access_key.candidate.secret
  sensitive = true
}
