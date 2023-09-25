variable "vpc-id" {
  type = string
}
variable "alb_sg_name" {
  type = string
}
variable "rds_sg_name" {
  type = string
}
variable "private_ecs_sg_name" {
  type = string
}
variable "app_subnets" {
  type = list(string)
  default = []
}