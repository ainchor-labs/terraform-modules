variable "product" {
  description = "The product associated with the IAM role"
  type        = string
}

variable "name" {
  description = "The name of the IAM role"
  type        = string
}

variable "assume" {
  description = "The service that can assume the IAM role"
  type        = string
}

variable "access_policies" {
  description = "Map of services and their access level"
  type        = map(string)
}