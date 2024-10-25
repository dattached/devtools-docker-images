variable "name" { default = "bootstrap" }
variable "version" { default = "2.0.0" }

# building

group "default" {
  targets = ["default"]
}

target "default" {
  tags = [
    "dattached/${name}:${version}",
    "dattached/${name}:${join(".", slice(split(".", version), 0, 3))}",  # patch
    "dattached/${name}:${join(".", slice(split(".", version), 0, 2))}",  # minor
    "dattached/${name}:${join(".", slice(split(".", version), 0, 1))}",  # major
    "dattached/${name}:latest",
  ]
}

# release

target "release" {
  inherits = ["default"]
  output = ["type=registry"]
}

# testing

group "test" {
  targets = [
    "debian-add-apt-postgresql",
    "debian-apt-install-devtools",
    "debian-pip-install-uv",
  ]
}

target "test-base" {
  context = "tests"
  args = {
    BOOTSTRAP_VERSION = "${version}"
  }
  no-cache = true
  output = ["type=cacheonly"]
}

target "debian-add-apt-postgresql" {
  inherits = ["test-base"]
  target = "debian-add-apt-postgresql"
}

target "debian-apt-install-devtools" {
  inherits = ["test-base"]
  target = "debian-apt-install-devtools"
}

target "debian-pip-install-uv" {
  inherits = ["test-base"]
  target = "debian-pip-install-uv"
}
