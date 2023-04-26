#######################################################################################################
#############################    Don't modify the code here           #################################
#######################################################################################################

# Create security group without any rules, because firewall team will allow required ports.
resource "aws_security_group" "security_group" {
  name                                      = var.kmbl_security_group_name
  description                               = var.kmbl_security_group_name
  vpc_id                                    = var.kmbl_vpc_id
  tags                                      = var.kmbl_common_tags
}

# Create EC2 instance.
##  using bootstrap script.
## root volume encrypted using CMK.
resource "aws_instance" "ec2_instance" {
  count                                     = var.kmbl_instance_count
  ami                                       = var.kmbl_ami_id
  availability_zone                         = element(var.kmbl_availability_zones, count.index % 2)
  subnet_id                                 = element(var.kmbl_subnet_ids, count.index % 2)
  associate_public_ip_address               = var.kmbl_associate_public_ip ? true : false
  instance_type                             = var.kmbl_instance_type
  vpc_security_group_ids                    = [aws_security_group.security_group.id,var.kmbl_arcos_security_group]
  iam_instance_profile                      = var.kmbl_instance_profile_name
  user_data                                 = var.kmbl_os_type=="linux" ? "${file("bootstrap.sh")}" : "${file("bootstrap.ps1")}"

  root_block_device {
    volume_type                             = "gp3"
    delete_on_termination                   = true
    encrypted                               = true
    kms_key_id                              = var.kmbl_ebs_encryption_key
  }

  lifecycle {
    create_before_destroy                   = true
  }

  depends_on                                = [
    aws_security_group.security_group
 ]

  tags                                      = var.kmbl_common_tags

}

# Create EBS volumes.
## EBS volumes are encrypted using CMK.
resource "aws_ebs_volume" "ebs_volume" {
  count                                     = var.kmbl_instance_count * var.kmbl_ebs_volume_count
  availability_zone                         = element(aws_instance.ec2_instance.*.availability_zone, floor(count.index / var.kmbl_ebs_volume_count))
  size                                      = var.kmbl_ec2_ebs_volume_size[count.index % var.kmbl_ebs_volume_count]
  encrypted                                 = true
  kms_key_id                                = var.kmbl_ebs_encryption_key

  tags                                      = var.kmbl_common_tags
}

# Attach EBS volumes to EC2 instances.
resource "aws_volume_attachment" "volume_attachement" {
  count                                    = var.kmbl_instance_count * var.kmbl_ebs_volume_count
  volume_id                                = aws_ebs_volume.ebs_volume.*.id[count.index]
  device_name                              = var.kmbl_ec2_device_names[count.index % var.kmbl_ebs_volume_count]
  instance_id                              = element(aws_instance.ec2_instance.*.id, floor(count.index / var.kmbl_ebs_volume_count))
}

# Create security rules.
resource "aws_security_group_rule" "security_group_rule_tcp" {
  count                                    = var.kmbl_ingress_tcp_ports_count
  type                                     = "ingress"
  from_port                                = element(var.kmbl_ingress_ports_tcp_port,count.index)
  to_port                                  = element(var.kmbl_ingress_ports_tcp_port,count.index)
  protocol                                 = "tcp"
  cidr_blocks                              = [element(var.kmbl_ingress_ports_tcp_source,count.index)]
  security_group_id                        = aws_security_group.security_group.id
  description                              = element(var.kmbl_ingress_ports_tcp_remedy,count.index)
}

# Create security rules.
resource "aws_security_group_rule" "security_group_rule_udp" {
  count                                    = var.kmbl_ingress_udp_ports_count
  type                                     = "ingress"
  from_port                                = element(var.kmbl_ingress_ports_udp_port,count.index)
  to_port                                  = element(var.kmbl_ingress_ports_udp_port,count.index)
  protocol                                 = "udp"
  cidr_blocks                              = [element(var.kmbl_ingress_ports_udp_source,count.index)]
  security_group_id                        = aws_security_group.security_group.id
  description                              = element(var.kmbl_ingress_ports_udp_remedy,count.index)
}

# Create security rules.
resource "aws_security_group_rule" "security_group_rule_icmp" {
  count                                    = var.kmbl_ingress_icmp_ports_count
  type                                     = "ingress"
  from_port                                = element(var.kmbl_ingress_ports_icmp_port,count.index)
  to_port                                  = element(var.kmbl_ingress_ports_icmp_port,count.index)
  protocol                                 = "icmp"
  cidr_blocks                              = [element(var.kmbl_ingress_ports_icmp_source,count.index)]
  security_group_id                        = aws_security_group.security_group.id
  description                              = element(var.kmbl_ingress_ports_icmp_remedy,count.index)
}

# Create and attach multiple ENIs for EC2 instances if required.
resource "aws_network_interface" "network_interface" {
  count                                    = var.kmbl_is_multi_eni ? var.kmbl_instance_count * var.kmbl_eni_count : 0
  subnet_id                                = element(aws_instance.ec2_instance.*.subnet_id, floor(count.index / var.kmbl_eni_count))
  security_groups                          = [aws_security_group.security_group.id,var.kmbl_arcos_security_group]
  description                              = "Additional ENI - ${count.index + 1}"
  tags                                     = var.kmbl_common_tags
}

# Attach create ENIs to EC2 instances.
resource "aws_network_interface_attachment" "network_interface_attach" {
  count                = var.kmbl_is_multi_eni ? var.kmbl_instance_count * var.kmbl_eni_count : 0
  instance_id          = element(aws_instance.ec2_instance.*.id, floor(count.index / var.kmbl_eni_count))
  network_interface_id = aws_network_interface.network_interface[count.index].id
  device_index         = 1
}
