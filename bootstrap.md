# Bootstrap scripts

## debian-add-apt-postgresql.sh
```
Add https://apt.postgresql.org repository with latest PostgreSQL packages.
USAGE: debian-add-apt-postgresql.sh [-h] [--noupdate] [--noclean]
flags:
  --[no]update:  update APT cache (default: true)
  --[no]clean:  clean APT cache and temporary files (default: true)
  -h,--help:  show this help (default: false)
```

## debian-apt-install-devtools.sh
```
Install standard devtools.
USAGE: debian-apt-install-devtools.sh [-h] [--noupdate] [--noclean]
flags:
  --[no]update:  update APT cache (default: true)
  --[no]clean:  clean APT cache and temporary files (default: true)
  -h,--help:  show this help (default: false)
```
