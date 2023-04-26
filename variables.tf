###############################################
######    Don't modify this file.      ########
###############################################

variable "kmbl_region" {
  type        = string
  description = "AWS region."
}

variable "kmbl_os_type" {
  type        = string
  description = "Os type for EC2 instance (windows/linux)"
}

variable "kmbl_instance_count" {
  type        = number
  default     = 1
  description = "The number EC2 instance(s) that we want to create."
}

variable "kmbl_ami_id" {
  type        = string
  default     = "ami-006dcf34c09e50022"
  description = "AMI ID to be used for EC2 instance(s), default is RHEL golden AMI"

  validation {
    condition     = length(var.kmbl_ami_id) > 4 && substr(var.kmbl_ami_id, 0, 4) == "ami-"
    error_message = "The kmbl_ami_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "kmbl_instance_type" {
  type        = string
  nullable    = false
  description = "The instance type to be used for EC2 instance(s)-(Technically size of VM)."
}

variable "kmbl_ebs_volume_count" {
  type        = number
  default     = 0
  description = "Number of EBS volumes required to be attached to EC2 instance(s)."
}

variable "kmbl_ec2_ebs_volume_size" {
  type        = list(any)
  description = "required EBS volume size in GB to be attached to EC2 instance(s)."
  default     = [
    0
  ]
}

variable "kmbl_associate_public_ip" {
  type        = bool
  default     = false
  description = "Enable Public IP association to EC2 if required."
}

variable "kmbl_ec2_device_names" {
  type        = list(any)
  description = "Device names for EBS volumes to be attached to EC2 instance(s)."
}

variable "kmbl_availability_zones" {
  type        = list(any)
  nullable    = false
  description = "List of availability zones for EC2 instance(s)."
}

variable "kmbl_subnet_ids" {
  type        = list(any)
  nullable    = false
  description = "Subnet for EC2 instance(s)."
}

variable "kmbl_vpc_id" {
  type        = string
  nullable    = false
  description = "VPC for EC2 instance(s)."
}

variable "kmbl_instance_profile_name" {
  type        = string
  nullable    = false
  description = "IAM role for EC2 instance(s). Default is SSM_Role."
}

variable "kmbl_ebs_encryption_key" {
  type        = string
  nullable    = false
  description = "KMS key for EBS volume encryption. Default is EBS-KEY"
}

variable "kmbl_security_group_name" {
  type        = string
  nullable    = false
  description = "Security groups for EC2 instance(s). Default ARCOS security groups and empty application security group."
}

variable "kmbl_arcos_security_group" {
  type        = string
  nullable    = false
  description = "Empty security group for application. Rules will be added by firewall team once they receive remedy from application team."
}

### Ingress TCP rules.
variable "kmbl_ingress_tcp_ports_count" {
  type        = number
}

variable "kmbl_ingress_ports_tcp_port" {
  type        = list(string)
}

variable "kmbl_ingress_ports_tcp_source" {
  type        = list
}

variable "kmbl_ingress_ports_tcp_remedy" {
  type        = list
}

### Ingress UDP rules.
variable "kmbl_ingress_udp_ports_count" {
  type        = number
}

variable "kmbl_ingress_ports_udp_port" {
  type        = list(string)
}

variable "kmbl_ingress_ports_udp_source" {
  type        = list
}

variable "kmbl_ingress_ports_udp_remedy" {
  type        = list
}

### Ingress ICMP rules.
variable "kmbl_ingress_icmp_ports_count" {
  type        = number
}

variable "kmbl_ingress_ports_icmp_port" {
  type        = list(string)
}

variable "kmbl_ingress_ports_icmp_source" {
  type        = list
}

variable "kmbl_ingress_ports_icmp_remedy" {
  type        = list
}

variable "kmbl_common_tags" {
  type        = map
}

#Multi-ENI support.
variable "kmbl_is_multi_eni" {
  type        = bool
  description = "Enable multiple ENI required for EC2 instance(s)."
  default     = false
}

variable "kmbl_eni_count" {
  type        = number
  description = "Number of additional ENI for EC2 instance(s)."
  default     = 0
}
