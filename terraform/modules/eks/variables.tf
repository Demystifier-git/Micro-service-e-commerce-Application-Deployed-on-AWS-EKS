variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs where worker nodes will run"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private access to the Kubernetes API server"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public access to the Kubernetes API server"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to all EKS resources"
  type        = map(string)
  default     = {}
}



