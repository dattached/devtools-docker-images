variable "name" { default = "lazydocker" }
variable "version" { default = "0.23.3.2" }  # see Dockerfile LAZYDOCKER_VERSION

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

# release

target "release" {
  inherits = ["default"]
  output = ["type=registry"]
}
