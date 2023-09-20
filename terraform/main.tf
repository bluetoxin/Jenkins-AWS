resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "jenkins"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "jenkins_ansible_pk" {
  filename        = "../ansible/jenkins.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0600"
}

resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins_sg"
  vpc_id = data.aws_vpc.default_vpc.id

  dynamic "ingress" {
    for_each = var.OPEN_PORTS
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    }
  }

  # Allow everything within Security Group
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Jenkins SG"
  }
}

# Create Controller
resource "aws_instance" "jenkins_controller" {
  ami             = var.AWS_AMI_CONTROLLER
  instance_type   = var.AWS_INSTANCE_TYPE_CONTROLLER
  key_name        = aws_key_pair.kp.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "jenkins_controller"
  }
}

# Create Agents
resource "aws_instance" "jenkins_agents" {
  count = var.AWS_AGENT_AMOUNT

  ami             = var.AWS_AMI_AGENT
  instance_type   = var.AWS_INSTANCE_TYPE_AGENT
  key_name        = aws_key_pair.kp.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "jenkins_agent_${count.index + 1}"
  }
}

resource "local_file" "ansible_inventory" {
  content = "[controller]\n${aws_instance.jenkins_controller.tags.Name} ansible_host=${aws_instance.jenkins_controller.public_ip}\n\n[agents]\n${join("\n",
    formatlist(
      "%s ansible_host=%s",
      aws_instance.jenkins_agents.*.tags.Name, aws_instance.jenkins_agents.*.public_ip
  ))}\n\n[all:vars]\nansible_python_interpreter=/usr/bin/python3\nansible_ssh_extra_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'\nansible_ssh_private_key_file=jenkins.pem\nansible_user=ubuntu"

  file_permission = "0600"
  filename        = "../ansible/inventory"
}