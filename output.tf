#######################################################################################################
#############################    Don't modify the code here           #################################
#######################################################################################################

# Print primary Instance ID and Private IP address to screen.  
output "instance_id_ip_address" {
  value                                    = zipmap(aws_instance.ec2_instance.*.id,aws_instance.ec2_instance.*.private_ip)
}

