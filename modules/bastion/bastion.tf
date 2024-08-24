resource "aws_instance" "bastion" {
  ami           = "ami-0c2acfcb2ac4d02a0"  # Amazon Linux 2 AMI (region-specific)
  instance_type = "t3.medium"
  subnet_id     = var.subnets_public_ids[0]
  key_name      = var.eks_cluster_info.remote_access_key  # SSH 키 페어 이름

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "${var.common_info.env}-${var.common_info.service_name}-bastion-server"
  }

}
