variable "name" { default = "lazydocker" }
variable "version" { default = "0.23.3.1" }  # see Dockerfile LAZYDOCKER_VERSION

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
