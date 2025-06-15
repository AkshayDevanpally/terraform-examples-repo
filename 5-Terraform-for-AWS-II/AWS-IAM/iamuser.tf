# ============================================================================================
# Purpose:
# This Terraform script creates IAM users and assigns them to a group with IAMReadOnlyAccess.
# ============================================================================================

# --------------------------------------------------------------------------------------------
# IAM Users
# Creating two individual IAM users
# --------------------------------------------------------------------------------------------
resource "aws_iam_user" "adminuser1" {
  name = "adminuser1"
}

resource "aws_iam_user" "adminuser2" {
  name = "adminuser2"
}

# --------------------------------------------------------------------------------------------
# IAM Group
# Create a group to manage admin users collectively
# --------------------------------------------------------------------------------------------
resource "aws_iam_group" "admingroup" {
  name = "admingroup"
}

# --------------------------------------------------------------------------------------------
# IAM Group Membership
# Assign both users to the created admin group
# --------------------------------------------------------------------------------------------
resource "aws_iam_group_membership" "admin-users" {
  name = "admin-users"
  users = [
    aws_iam_user.adminuser1.name,
    aws_iam_user.adminuser2.name
  ]
  group = aws_iam_group.admingroup.name
}

# --------------------------------------------------------------------------------------------
# IAM Policy Attachment
# Grant the IAMReadOnlyAccess policy to the group
# --------------------------------------------------------------------------------------------
resource "aws_iam_policy_attachment" "admin-users-attach" {
  name       = "admin-users-attach"
  groups     = [aws_iam_group.admingroup.name]
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

