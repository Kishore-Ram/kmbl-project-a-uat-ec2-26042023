#############################################################################################################
######################################  Update required variables here ######################################
#############################################################################################################

#################################### Region #################################################################
kmbl_region                   = "ap-south-1"

################################### EC2 instance details ####################################################
kmbl_instance_count           = 1
kmbl_instance_type            = "t2.micro"
kmbl_ami_id                   = "ami-067434173b218f10f"
kmbl_os_type                  = "linux"

################################### EBS volume details #####################################################
kmbl_ebs_volume_count         = 0
kmbl_ec2_ebs_volume_size      = [1]
kmbl_ec2_device_names         = ["/dev/sdd"]
kmbl_ebs_encryption_key       = "arn:aws:kms:ap-south-1:249176918067:key/2bfdfd30-d968-4949-af5f-e56e17544e15"

################################## VPC/Subnet Details ######################################################
kmbl_subnet_ids               = ["subnet-09b1bee051b7a1a19","subnet-09d06be82abdbc2d5"]
kmbl_availability_zones       = ["ap-south-1a","ap-south-1b"]
kmbl_vpc_id                   = "vpc-048762609a948067e"

################################# Associate Public IP ######################################################
kmbl_associate_public_ip      = false

############################## Instance Profile (IAM Role) #################################################
kmbl_instance_profile_name    = "AWS_SSM_Role"

############################## Common Tags #################################################################
kmbl_common_tags               = {
    "Project Name"             = "Project A"
    "Project Owner"            = "Kavindra"
    "Name"                     = "kmbl-projecta-uat-ec2-26042023-1"
    "Environment"              = "uat"
    "Remedy ID"                = "REQ0000012345"
}

########################### Security group details #########################################################
kmbl_security_group_name      = "projecta_uat_project_sg"
kmbl_arcos_security_group     = "sg-093aa2cacceec92ed"


############################ Multi-ENI support - Max 1 additional ENI ######################################
kmbl_is_multi_eni             = false
kmbl_eni_count                = 0

###################### Security Rules for Security Group ###################################################
kmbl_ingress_tcp_ports_count  = 1
kmbl_ingress_ports_tcp_port   = ["80"]
kmbl_ingress_ports_tcp_source = ["1.1.1.1/32"]
kmbl_ingress_ports_tcp_remedy = ["REQ0000000001"]


kmbl_ingress_udp_ports_count  = 0
kmbl_ingress_ports_udp_port   = ["80"]
kmbl_ingress_ports_udp_source = ["2.2.2.2/32"]
kmbl_ingress_ports_udp_remedy = ["REQ0000000001"]


kmbl_ingress_icmp_ports_count  = 0
kmbl_ingress_ports_icmp_port   = ["-1"]
kmbl_ingress_ports_icmp_source = ["2.2.2.2/32"]
kmbl_ingress_ports_icmp_remedy = ["REQ0000000001"]

