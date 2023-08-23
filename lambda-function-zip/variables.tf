variable "function_name" {
  type = string
}

variable "iam_role_arn" {
  type = string
}


variable "memory" {
  type = number
}

variable "product_name" {
  type = string
}

variable "timeout" {
  type = number
}

variable "env_vars" {
  type    = map(string)
  default = {
    "key" = "value"
   }
}

variable "tmp_storage" {
  type = number
  default = 512
}

variable "filename" {
  type = string
}

variable "runtime" {
  type = string
}