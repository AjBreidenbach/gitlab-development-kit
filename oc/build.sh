#!/usr/bin/env bash

if [[ "$(basename $(pwd))" !=  "gitlab-development-kit" ]]
then
  echo "Please run this script from the gitlab-development-kit base directory"
  exit 1
fi

sudo docker build . -t gdk:latest
sudo docker build -f oc/Dockerfile  . -t gdk-oc:latest
