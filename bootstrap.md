# Bootstrap scripts

## debian-add-apt-postgresql.sh
```
Add https://apt.postgresql.org repository with latest PostgreSQL packages.
USAGE: debian-add-apt-postgresql.sh [-h] [--noaptupdate] [--noaptclean]
flags:
  --[no]aptupdate:  update APT cache (default: true)
  --[no]aptclean:  clean APT cache and temporary files (default: true)
  -h,--help:  show this help (default: false)
```

## debian-apt-install-devtools.sh
```
Install standard devtools.
USAGE: debian-apt-install-devtools.sh [-h] [--noaptupdate] [--noaptclean]
flags:
  --[no]aptupdate:  update APT cache (default: true)
  --[no]aptclean:  clean APT cache and temporary files (default: true)
  -h,--help:  show this help (default: false)
```

## debian-apt-install.sh
```
Install arbitrary packages.
USAGE: debian-apt-install.sh [-h] [--noaptupdate] [--noaptclean] package [package...]
flags:
  --[no]aptupdate:  update APT cache (default: true)
  --[no]aptclean:  clean APT cache and temporary files (default: true)
  -h,--help:  show this help (default: false)
```
