output "private-sg-ecs" {
  value = aws_security_group.PrivateEcsSg.id
}
output "public-sg-ecs" {
  value = aws_security_group.PublicEcsSg.id
}

output "alb-sg" {
  value = aws_security_group.AlbSg.id
}


output "rds-sg" {
  value = aws_security_group.RDS-Sg.id
}