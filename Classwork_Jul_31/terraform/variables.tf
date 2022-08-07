variable "awsProfilename" {
    type = string
    default = "awsclitest"
    description = "Profile name for aws configuration"
}

variable "project_name" {
    type = string
    default = "Jul31"
    description = "PROJECT tag value for resources"
}

variable "nginxSrvImageId" {
    type = string
    default = "ami-08d4ac5b634553e16"
    description = "AMI ID for nginx server"
}

variable "nginxSrvType" {
    type = string
    default = "t2.micro"
    description = "EC2 instance type nginx server"
}

variable "publicKeyMaterial" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDwwvnaQhumfeSvp90kYb34iA9ECcJ8iG6onbRjiKA3G5thzjVTTcQYourAvii+9ma/tvbpfLuhXkq8DOqURAGtCaoyJYHpwLm3iiEoZQ+kzUc+psep4ImUnShZfV74yD1rSBawvCZfiQLbifvfTDX5J4X3WJJLCj19K9MAXEaJrTuu5C7b1eyaJmfeArqlNzZ+OCdtyv84ddK7gf4FRJQjxXNO0ZEqnpq+/80n0HGWt4ue/Hl6kna0JEs73gMAhkl+Rb9XU1DQoEjtPNtbMjdXV/wWMVTTwQC67P46HT8jslFUTFtzs+Y6S9UNSra5nfVBLr6jys34iL0ekz26ynttSd5+XHNFhd2AkWUx+QB4jlgl6GJEcBRxk2f89A/GRC22nqKJpxPcHIZ1+TgQZTFFY89peS8tNxmfZrI467CNofulp59Q8+QTpGVw51R8DPxSzWWSoKWU/w7G0N+eruxFUSXLxXSHHLd/PCDeMYjLx0G00bpR1PtPIl3fQDAEKhhfDyUxIymAACH8a8kH+bNsMgACWpoR91HVBd7ck6r23JJh6urryAZ617bfW/KH0UPOkKi75hX4shEs9nX9H3il5asrDHnf8JQkY1Y8T6FMWUOrgyibG4dyrvZfxzid43RvsclgBW4QlZZNioRU3iAN2LXMqVna9d6OuVDBrt4Mzw== kvazar@orionu"
    description = "EC2 access public key material"
}

variable "route53HostedZoneID" {
    type = string
    default = "Z00409031DFLMV673VS25"
    description = "Route53 Hosted zone ID for cloudfront website"
}

variable "route53HostedZoneDN" {
    type = string
    default = "jul31.vladimir-avagyan.acadevopscourse.xyz"
    description = "Route53 Hosted zone Domain name for cloudfront website"
}
