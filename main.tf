provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "123456"
  vsphere_server = "127.0.0.1"


  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.ldcCode
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "xiaohei-test"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "xiaohei-test"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count      = var.instance_number
  name             = var.instance_number > 1  ? format("%s%03d", var.name, count.index + 1) : var.name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  wait_for_guest_net_timeout = 0
  # 用这个参数可以控制等待ip 出来的结果
  wait_for_guest_ip_timeout = 2
  num_cpus = 2
  memory   = 1024
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 50
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.instance_number > 1  ? format("%s%03d", "terraform", count.index + 1) : "terraform-test"
        domain    = "test.internal"
      }

      network_interface {
         ipv4_address = split(",", var.ips)[count.index]
         ipv4_netmask = 16
      }
      ipv4_gateway = var.gateWay
      dns_server_list = [var.dns]

    }

  }
}

output "vm" {
  value = vsphere_virtual_machine.vm[*].default_ip_address
}

// 为每个计算资源创建一个对应的 ansible_host 资源，
// 执行 ansible playbook 前会基于 ansible_host 资源自动生成 inventory 文件。
resource "ansible_host" "redis" {
  count = "2"

  // 配置机器的 hostname，一般配置为计算资源的 public_ip (或 private_ip)
  inventory_hostname = vsphere_virtual_machine.vm[count.index].default_ip_address

  // 配置机器所属分组
  groups = ["redis"]

  // 传给 ansible 的 vars，可在 playbook 文件中引用
  vars = {
    wait_connection_timeout = 600
    install_Redis = var.installRedis
    Version = var.redisVersion
    PORT = var.servicePort
    cluster_Model = var.clusterModel
    REDISDIR = var.REDIS_DIR
    Software_Ip = var.SoftwareIp
    Software_redisPath = var.SoftwarePath
  }
}
