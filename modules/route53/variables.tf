variable "domain_name" {
    type = string
    description = "the root domain name"
}
variable "record_name" {
    type = string
    description = "full subdomain name "
}
variable "target_ip" {
    type = string 
    description = "Elastic ip address"
}
