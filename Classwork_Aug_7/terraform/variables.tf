variable "awsProfilename" {
    type = string
    default = "awsclitest"
    description = "Profile name for aws configuration"
}

variable "project_name" {
    type = string
    default = "Aug7"
    description = "PROJECT tag value for resources"
}

variable "route53HostedZoneID" {
    type = string
    default = "Z00409031DFLMV673VS25"
    description = "Route53 Hosted zone ID for cloudfront website"
}

variable "route53HostedZoneDN" {
    type = string
    default = "aug7.vladimir-avagyan.acadevopscourse.xyz"
    description = "Route53 Hosted zone Domain name for cloudfront website"
}
