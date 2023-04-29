variable "name" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "zone" {
  type    = string
  default = null
}

variable "additional_tags" {
  default = {}
  type    = map(string)
}

variable "initialize_params" {
  type = object({
    image  = string
    labels = map(string)
  })
  default = {
    image = "debian-cloud/debian-11"
    labels = {
      my_label = "value"
    }
  }
}

# subnetwork must exist in the same region this instance will be created in
variable "network_interface" {
  type = object({
    network_name    = string
    subnetwork_name = string
  })
}
