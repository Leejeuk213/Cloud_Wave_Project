#BASION에 할당 할 탄력적 ip생성
resource "aws_eip" "bastion-eip" {
  tags = {
    "Name" = "${var.eks_cluster_info.cluster_name}-bastion-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion-eip.id
}