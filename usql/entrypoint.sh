#!/usr/bin/env bash

USQL_CONF=/root/.config/usql/config.yaml

if [ -n "$USQL_FILEENV_NAMES" ]; then
  while IFS='=' read -r -d '' name path; do
    for pattern in $USQL_FILEENV_NAMES; do
      case $name in ($pattern)
        value="$(cat $path | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')";
        export ${name%_FILE}="$value";
        break;
        ;;
      esac
    done
  done < <(env -0)
fi

if [ -n "$USQL_CONF_TEMPLATE" ]; then
  cat $USQL_CONF_TEMPLATE | envsubst > $USQL_CONF
fi

/bin/usql ${USQL_CONNECTION}
