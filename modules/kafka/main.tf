resource "aws_instance" "kafka_broker" {
  count                  = var.kafka_broker_count
  ami                    = var.kafka_ami
  instance_type          = var.kafka_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.kafka_sg.id]
  subnet_id              = element(var.subnet_ids, count.index)

  tags = {
    Name        = "${var.prefix}-kafka-broker-${count.index + 1}"
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              # Install Java
              sudo apt-get update
              sudo apt-get install -y openjdk-8-jdk

              # Download and install Kafka
              wget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz
              tar -xzf kafka_2.13-2.8.1.tgz
              sudo mv kafka_2.13-2.8.1 /opt/kafka

              # Configure Kafka
              echo "broker.id=${count.index}" >> /opt/kafka/config/server.properties
              echo "listeners=PLAINTEXT://0.0.0.0:9092" >> /opt/kafka/config/server.properties
              echo "advertised.listeners=PLAINTEXT://${aws_instance.kafka_broker[count.index].private_ip}:9092" >> /opt/kafka/config/server.properties
              echo "zookeeper.connect=${join(",", aws_instance.zookeeper.*.private_ip)}:2181" >> /opt/kafka/config/server.properties

              # Start Kafka
              sudo /opt/kafka/bin/kafka-server-start.sh -daemon /opt/kafka/config/server.properties
              EOF
}

resource "aws_instance" "zookeeper" {
  count                  = 3
  ami                    = var.kafka_ami
  instance_type          = var.kafka_instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.kafka_sg.id]
  subnet_id              = element(var.subnet_ids, count.index)

  tags = {
    Name        = "${var.prefix}-zookeeper-${count.index + 1}"
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              # Install Java
              sudo apt-get update
              sudo apt-get install -y openjdk-8-jdk

              # Download and install Kafka (which includes ZooKeeper)
              wget https://downloads.apache.org/kafka/2.8.1/kafka_2.13-2.8.1.tgz
              tar -xzf kafka_2.13-2.8.1.tgz
              sudo mv kafka_2.13-2.8.1 /opt/kafka

              # Configure ZooKeeper
              echo "${count.index}" > /opt/kafka/myid
              echo "tickTime=2000" >> /opt/kafka/config/zookeeper.properties
              echo "dataDir=/var/lib/zookeeper" >> /opt/kafka/config/zookeeper.properties
              echo "clientPort=2181" >> /opt/kafka/config/zookeeper.properties
              echo "initLimit=5" >> /opt/kafka/config/zookeeper.properties
              echo "syncLimit=2" >> /opt/kafka/config/zookeeper.properties
              echo "server.1=${aws_instance.zookeeper[0].private_ip}:2888:3888" >> /opt/kafka/config/zookeeper.properties
              echo "server.2=${aws_instance.zookeeper[1].private_ip}:2888:3888" >> /opt/kafka/config/zookeeper.properties
              echo "server.3=${aws_instance.zookeeper[2].private_ip}:2888:3888" >> /opt/kafka/config/zookeeper.properties

              # Start ZooKeeper
              sudo /opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties
              EOF
}

resource "aws_security_group" "kafka_sg" {
  name_prefix = "${var.prefix}-kafka-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.prefix}-kafka-sg"
    Environment = var.environment
  }
}

resource "aws_lb" "kafka_lb" {
  name               = "${var.prefix}-kafka-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "kafka_tg" {
  name     = "${var.prefix}-kafka-tg"
  port     = 9092
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "kafka_listener" {
  load_balancer_arn = aws_lb.kafka_lb.arn
  port              = 9092
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kafka_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "kafka_tg_attachment" {
  count            = var.kafka_broker_count
  target_group_arn = aws_lb_target_group.kafka_tg.arn
  target_id        = aws_instance.kafka_broker[count.index].id
  port             = 9092
}
