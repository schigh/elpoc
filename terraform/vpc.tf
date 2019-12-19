resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "elasticache-test-vpc"
    Author = "stevehigh"
    Provisioner = "terraform"
  }
}

resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "elasticache-test-sg"
    Author = "stevehigh"
    Provisioner = "terraform"
  }
}

resource "aws_security_group_rule" "redis_sg_rule" {
  security_group_id = aws_security_group.redis_sg.id
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_subnet" "redis_sn" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "elasticache-test-sn"
    Author = "stevehigh"
    Provisioner = "terraform"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name = "elasticache-test-sn-grp"
  subnet_ids = [aws_subnet.redis_sn.id]
}
