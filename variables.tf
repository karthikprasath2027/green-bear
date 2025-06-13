variable "internet_IP" {
  default = ["0.0.0.0/32"]
}

variable "ingress_port" {
  type = list(number)
  default = [22,80,443]
}


variable "egress_port" {
  type = list(number)
  default = [0,8080]
}