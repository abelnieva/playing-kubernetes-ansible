variable "AppEnvToDeploy" {
    default = "all"
}

variable "tags" {
    default = {
    environment = "cluster kubernetes"
    owner = "abel"
  }
} 