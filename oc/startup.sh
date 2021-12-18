#!/usr/bin/env bash
if [[ $(whoami) = "gdk" ]]
then
  set -x
  pushd $HOME/gitlab-development-kit
  if [[ ! -d "$HOME/gitlab-development-kit/services" ]]
  then
    gdk install &
  else
    gdk start &
  fi
  popd
fi

