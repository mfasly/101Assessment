variable "cluster_name" {
  type = string
}

variable "eks_version" {
  type = string
}

variable "iam_role_arn" {
  type = string
}

variable "subnet_id_list" {
  type = list(string)
}

variable "iam_node_role_arn" {
  type = string
}

variable "node_group_desired_size" {
  type = number
}

variable "node_group_max_size" {
  type = number
}

variable "node_group_min_size" {
  type = number
}

#variable "security_group_ids" {
#  type = list(string)
#}