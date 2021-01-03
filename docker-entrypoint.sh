#!/bin/sh

set -e

if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
  ORIGINAL_IFS=$IFS
  IFS='='

  find "/docker-entrypoint.d/" -name \*.conf -exec cp -L {} /etc/nginx/conf.d/ \;
  find "/etc/nginx/conf.d/" -follow -type f -print | while read -r f; do
      case "$f" in
          *.conf)
            env | while read -r k v; do
                sed -i "s@{{$k}}@$v@" $f
            done
            ;;
      esac
  done

  IFS=${ORIGINAL_IFS}
fi

exec "$@"
