terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.2.0"
    }
  }
}
data "vsphere_datacenter" "dc" {
  name = "dc1"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "esxi1/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "172.16.27.0"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_host" "host" {
  name          = "esxi-01.example.com"
  datacenter_id = data.vsphere_datacenter.dc.id
}


resource "vsphere_virtual_machine" "vm" {
  name             = "demo"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus = 1
  memory   = 1024
  guest_id = "centos7_64Guest"

  ignored_guest_ips = []


  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = "vmxnet3"
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    path          =  "sbc-c8-F7.40A.005.619.iso"
    
  }

  disk {
    label            = "demo"
    size             = 50
    thin_provisioned = true
  }

}
