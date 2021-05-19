# GitLab Development Kit (GDK)

[![build status](https://gitlab.com/gitlab-org/gitlab-development-kit/badges/main/pipeline.svg)](https://gitlab.com/gitlab-org/gitlab-development-kit/pipelines)

## Overview

The GitLab Development Kit (GDK) helps you install a GitLab instance on your
workstation. It includes a collection of GitLab requirements, such as Ruby,
Node.js, Go, PostgreSQL, Redis, and more.

The GDK is recommended for anyone contributing to the GitLab codebase, whether a
GitLab team member or a member of the wider community. It allows you to test
your changes locally on your workstation in an isolated manner. This can speed
up the time it takes to make successful contributions.

## Goals

- Provide developer tooling to install, update, and develop against a local GitLab instance.
- Offer GDK users an automated method for installing [required software](https://docs.gitlab.com/ee/install/requirements.html#software-requirements).
- Out of the box, only enable the services GitLab requires to operate.
- Support native operating systems as listed below.

## Getting started

The following methods for installing GDK are available:

- [One-line installation](doc/index.md#one-line-installation):

  ```shell
  curl "https://gitlab.com/gitlab-org/gitlab-development-kit/-/raw/main/support/install" | bash -
  ```

- [Simple installation](doc/index.md) on your local system. Requires at least
  8GB RAM and 12GB disk space. Available for:

  | Operating system | Versions            |
  |:-----------------|:--------------------|
  | macOS            | 11, 10.15, 10.14    |
  | Ubuntu           | 20.10, 20.04, 18.04 |
  | Debian           | 10, 9               |
  | Arch             | latest              |
  | Manjaro          | latest              |

- [Advanced installation](doc/advanced.md) on your local system. Requires at least
  8GB RAM and 12GB disk space.
- [Gitpod](doc/howto/gitpod.md).
- [Vagrant](doc/howto/vagrant.md).
- [Minikube](doc/howto/kubernetes/minikube.md).

After installation, learn how to:

- [Use GDK](doc/howto/index.md).
- [Update an existing installation](doc/index.md#update-gdk).

## Getting help

- We encourage you to [create a new issue](https://gitlab.com/gitlab-org/gitlab-development-kit/-/issues/new).
- GitLab team members can use the `#gdk` channel on the GitLab Slack workspace.
- Wider community members can use the [Gitter contributors room](https://gitter.im/gitlab/contributors)
  or [GitLab Forum](https://forum.gitlab.com/c/community/community-contributions/15).

## Contributing to GitLab Development Kit

Contributions are welcome; see [`CONTRIBUTING.md`](CONTRIBUTING.md)
for more details.

## License

The GitLab Development Kit is distributed under the MIT license; see the
[LICENSE](LICENSE) file.
