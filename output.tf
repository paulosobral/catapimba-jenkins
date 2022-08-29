output "aws_eip" {
  value       = aws_eip.jenkins-eip.public_ip
  description = "Endereço IP público da instancia do Jenkins. Acessar com o protocolo HTTP. Exemplo: http://44.206.118.193"
}