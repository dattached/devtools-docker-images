variable "name" { default = "usql" }
variable "version" { default = "0.19.3.1" }  # use Dockerfile USQL_VERSION
variable "version_major" { default = join(".", slice(split(".", version), 0, 1)) }
variable "version_minor" { default = join(".", slice(split(".", version), 0, 2)) }
variable "version_patch" { default = join(".", slice(split(".", version), 0, 3)) }

# building

group "default" {
  targets = ["default"]
}

target "default" {
  tags = [
    "dattached/${name}:${version}",
    "dattached/${name}:${join(".", slice(split(".", version), 0, 3))}",  # patch
    "dattached/${name}:${join(".", slice(split(".", version), 0, 2))}",  # minor
    #"dattached/${name}:${join(".", slice(split(".", version), 0, 1))}",  # major: skip until 1.x
    "dattached/${name}:latest",
  ]
}

# publishing

target "publish" {
  inherits = ["default"]
  output = ["type=registry"]
}
