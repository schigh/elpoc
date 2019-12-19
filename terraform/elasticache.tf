resource "aws_elasticache_cluster" "redis" {
  cluster_id = "poc-test-cluster"
  engine = "redis"
  node_type = "cache.t2.small"
  parameter_group_name = "default.redis5.0"
  port = 6379
  num_cache_nodes = 1
  engine_version = "5.0.6"
  security_group_ids = [aws_security_group.redis_sg.id]
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name
  tags = {
    Name = "poc-test-cluster"
    Author = "stevehigh"
    Provisioner = "terraform"
  }
}
