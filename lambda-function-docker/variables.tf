variable "function_name" {
  type = string
}

variable "iam_role_arn" {
  type = string
}


variable "memory" {
  type = number
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

variable "image_uri" {
  type = string
}