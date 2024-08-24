data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "external" "local_ip" {
  program = ["bash", "./get_private_ip.sh"]
}
