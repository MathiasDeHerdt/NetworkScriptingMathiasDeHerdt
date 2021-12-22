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

data "vsphere_virtual_machine" "webserver-template-windows" {
  name          = var.vm_template-windows
  datacenter_id = data.vsphere_datacenter.dc.id
}
# / Default configurations

# ================================= VM's =================================
#
# ----------------
# Windows VM
# ----------------
resource "vsphere_virtual_machine" "vm-windows" {
  count            = 1
  name             = "mathias-win"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 1
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.webserver-template-windows.guest_id

  scsi_type = data.vsphere_virtual_machine.webserver-template-windows.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.webserver-template-windows.network_interface_types[0]
  }

  disk {
    label            = var.vm_disk
    size             = data.vsphere_virtual_machine.webserver-template-windows.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.webserver-template-windows.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.webserver-template-windows.disks[0].thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.webserver-template-windows.id

    customize {
      windows_options {
        computer_name = var.vm_hostname_win
        # domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "192.168.50.100"
        ipv4_netmask = 24
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
}

# ----------------
# UBUNTU VM
# ----------------
resource "vsphere_virtual_machine" "vm-ubuntu" {
  count            = 1
  name             = "mathias-ubu"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
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
        host_name = var.vm_hostname_ubu
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = "192.168.50.101"
        ipv4_netmask = 24
      }

      ipv4_gateway    = var.gateway
      dns_server_list = var.dns_servers
    }
  }
}
#
# =============================== / VM's =================================