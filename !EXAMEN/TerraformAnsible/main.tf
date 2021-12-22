# Default configurations
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_ip
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "webserver-template-ubuntu" {
  name          = var.vm_template-ubuntu
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "webserver-template-centos" {
  name          = var.vm_template-centos
  datacenter_id = data.vsphere_datacenter.dc.id
}
# / Default configurations

# ================================= WEBSERVERS =================================
#
# ----------------
# WEBSERVER UBUNTU
# ----------------
resource "vsphere_virtual_machine" "vm-ubuntu" {
  count            = 1
  name             = "webserver-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.webserver-template-ubuntu.guest_id

  scsi_type = data.vsphere_virtual_machine.webserver-template-ubuntu.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.webserver-template-ubuntu.network_interface_types[0]
  }

  disk {
    label            = var.vm_disk
    size             = data.vsphere_virtual_machine.webserver-template-ubuntu.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.webserver-template-ubuntu.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.webserver-template-ubuntu.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.webserver-template-ubuntu.id

    customize {
      linux_options {
        host_name = "Webserver-${count.index}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "192.168.50.200"
        ipv4_netmask = 24
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
}
# ----------------
# WEBSERVER CENTOS
# ----------------
resource "vsphere_virtual_machine" "vm-centos" {
  firmware         = var.firmware_efi
  count            = 1
  name             = "centos-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.webserver-template-centos.guest_id

  scsi_type = data.vsphere_virtual_machine.webserver-template-centos.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.webserver-template-centos.network_interface_types[0]
  }

  disk {
    label            = var.vm_disk
    size             = data.vsphere_virtual_machine.webserver-template-centos.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.webserver-template-centos.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.webserver-template-centos.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.webserver-template-centos.id

    customize {
      linux_options {
        host_name = var.vm_hostname_centos
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "192.168.50.201"
        ipv4_netmask = 24
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
}
#
# =============================== / WEBSERVERS =================================

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ LOAD BALANCER @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
resource "vsphere_virtual_machine" "vm-lb" {
  count            = 1
  name             = "Loadbalancer-${count.index}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.webserver-template-ubuntu.guest_id

  scsi_type = data.vsphere_virtual_machine.webserver-template-ubuntu.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.webserver-template-ubuntu.network_interface_types[0]
  }

  disk {
    label            = var.vm_disk
    size             = data.vsphere_virtual_machine.webserver-template-ubuntu.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.webserver-template-ubuntu.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.webserver-template-ubuntu.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.webserver-template-ubuntu.id

    customize {
      linux_options {
        host_name = "Loadbalancer-${count.index}"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "192.168.50.20"
        ipv4_netmask = 24
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook playbook.yml -i dir-inventory.ini --vault-password-file vault-password.txt"
  }
}
#
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ / LOAD BALANCER @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

