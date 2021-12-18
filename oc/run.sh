#!/usr/bin/env bash

if [[ "$(basename $(pwd))" !=  "gitlab-development-kit" ]]
then
  echo "Please run this script from the gitlab-development-kit base directory"
  exit 1
fi

if [[ $# -eq 0 || ! -d "$1" ]]
then
  echo "Please supply gitlab-oc base directory as first argument"
  exit 1
fi


local_volume="$(cd $(dirname $1); pwd)/$(basename $1)"
args="${@:2}"

sudo docker run -it $args -v $local_volume:/home/gdk/gitlab-development-kit/gitlab gdk-oc:latest
