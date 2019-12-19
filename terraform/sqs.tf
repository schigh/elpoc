resource "aws_sqs_queue" "ping_queue" {
  name = "ping-queue"
  max_message_size = 2048
  delay_seconds = 60
  receive_wait_time_seconds = 10
  message_retention_seconds = 86400
  tags = {
    Name = "elasticache_poc_ping_queue"
    Author = "stevehigh"
    Provisioner = "terraform"
  }
}
