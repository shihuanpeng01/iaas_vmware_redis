variable "ldcCode" {
    description = "(必填)数据中心"
    type = string
    default = "Datacenter"
}

variable "datastore" {
    description = "存储"
    type = string
    default = "datastore1"
}

variable "network" {
    description = "数据中心名称"
    type = string
    default = "VM Network"
}

variable "image" {
    description = "镜像"
    type = string
    default = "xiaohei-test"
}

variable "name" {
    description = "主机名称"
    type = string
    default = "xiaohei-test-01"
}

variable "instance_number" {
    default = 2
}

variable "cpu" {
    description = "CPU"
    default = 2
}

variable "memory" {
    description = "内存"
    default = 4096
}

variable "disk" {
    description = "磁盘大小"
    type = string
    default = "50"
}

variable "ips" {
    description = "每个虚拟机的ipv4网络地址,每个中间千万不能有空格"
    type = string
    default = "127.0.0.1,127.0.0.1"
}

variable "netMask" {
    description = "掩码"
    type = string
    default = "16"
}

variable "gateWay" {
    description = "网关"
    type = string
    default = "10.0.0.1"
}

variable "dns" {
    description = "域名解析"
    type = string
    default = "10.0.0.1"
}

variable "installRedis" {
    description = "是否安装"
    type = string
    default = "false"
}

variable "redisVersion" {
    description = "软件版本"
    type = string
    default = "5.0.7"
}

variable "servicePort" {
    description = "服务端口"
    type = string
    default = "7001"
}

variable "clusterModel" {
    description = "集群模式"
    type = string
    default = "1M1S"
}

variable "REDIS_DIR" {
    description = "安装目录"
    type = string
    default = "/approot/redis"
}

variable "SoftwareIp" {
    description = "介质服务器IP"
    type = string
    default = "127.0.0.1:8000"
}

variable "SoftwarePath" {
    description = "介质路径"
    type = string
    default = "soft/redis"
}
