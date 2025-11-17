

variable "access_key_id"  {}
variable "secret_key_id"  {}
variable "region"  {}


#resource "terraform_data" "Variables_packer" {
# input = var.secret_key_id
# provisioner "local-exec" {
#   working_dir = "./"
#   command = env
#   environment = {
#   OUTSCALE_ACCESSKEYID = "${var.access_key_id}"
#   OUTSCALE_SECRETKEYID = "${var.secret_key_id}"
#   }
# }
#}

