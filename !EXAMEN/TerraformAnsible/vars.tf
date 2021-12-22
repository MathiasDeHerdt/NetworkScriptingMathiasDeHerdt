# Credentials ------------------------------------------------------------------------------------------
variable "vsphere_user" {
  type = string
  sensitive = true
}

variable "vsphere_password" {
  type = string
  sensitive = true
}

variable "ubuntu_pass" {
  type = string
  sensitive = true
}

variable "connection_user" {
  default = "student"
}


# Templates for VM --------------------------------------------------------------------------------
variable "vm_template-ubuntu" {
  default = "ubuntu-template"
}

variable "vm_template-centos" {
  default = "centos-template"
}

variable "vm_template-windows" {
  default = "win-template"
}


# VM Hostname --------------------------------------------------------------------------------------
variable "vm_hostname" {
  default = "webserver"
}

variable "vm_hostname_lb" {
  default = "balancer"
}

variable "vm_hostname_centos" {
  default = "Webserver-CENTOS"
}

# Network Stuff ------------------------------------------------------------------------------------
variable "vsphere_network" {
  default = "VM Network"
}

variable "vsphere_ip" {
  default = "192.168.50.10"
}

variable "vm_network_interface" {
  default = "192.168.50.100"
}

variable "vm_network_interface_balancer" {
  default = "192.168.50.20"
}

variable "gateway" {
  default = "192.168.50.1"
}

variable "dns_servers" {
  default = ["172.20.0.2", "172.20.0.3"]
}

variable "connection_type_ssh" {
  default = "ssh"
}


# VM Configurations ----------------------------------------------------------------------------------------
variable "vsphere_datacenter" {
  default = "StudentDatacenter"
}

variable "vsphere_datastore" {
  default = "deherdt-mathias"
}

variable "vsphere_cluster" {
  default = "StudentCluster"
}

variable "vm_disk" {
  default = "disk0"
}

variable "vm_domain" {
  default = "lab.local"
}

variable "firmware_efi" {
  default = "efi"
}







