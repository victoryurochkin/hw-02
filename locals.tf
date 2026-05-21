locals {
  vm_web_instance_name = "${var.vm_web_name_prefix}${var.vm_web_name}${var.vm_web_name_suffix}"
  vm_db_instance_name  = "${var.vm_db_name_prefix}${var.vm_db_env}-${var.vm_db_platform}-${var.vm_db_role}"
}
