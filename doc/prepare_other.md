# Prepare your system for GDK

## Install OS dependencies

### Linux

#### Arch Linux

NOTE: **Note:**
These instructions don't account for using `asdf` for managing some dependencies.

To install dependencies for Arch Linux:

```shell
pacman -S postgresql redis postgresql-libs icu npm ed cmake openssh git git-lfs go re2 \
  unzip graphicsmagick perl-image-exiftool rsync yarn minio sqlite python2
```

NOTE: **Note:**
The Arch Linux core repository does not contain anymore the `runit` package. It is required to install `runit-systemd` from the Arch User Repository (AUR) with an AUR package manager like `pacaur` ([https://github.com/E5ten/pacaur](https://github.com/E5ten/pacaur)) or `pikaur` ([https://github.com/actionless/pikaur](https://github.com/actionless/pikaur)). See [Arch Linux Wiki page AUR_helpers](https://wiki.archlinux.org/index.php/AUR_helpers) for more information.

```shell
pikaur -S runit-systemd
```

#### Debian

NOTE: **Note:**
These instructions don't account for using `asdf` for managing some dependencies.

To install dependencies for Debian:

```shell
sudo apt-get install postgresql postgresql-contrib libpq-dev redis-server \
  libicu-dev cmake g++ libkrb5-dev libre2-dev ed pkg-config graphicsmagick \
  runit libimage-exiftool-perl rsync libsqlite3-dev
sudo curl https://dl.min.io/server/minio/release/linux-amd64/minio --output /usr/local/bin/minio
sudo chmod +x /usr/local/bin/minio
```

If you're running Debian [Experimental](https://wiki.debian.org/DebianExperimental), or
[newer](https://packages.debian.org/search?keywords=golang-go) you can install a Go
compiler using your package manager: `sudo apt-get install golang`.
Otherwise, install it manually. See the [Go](https://golang.org/doc/install#install) official installation
instructions.

You may need to install Redis 5.0 or newer manually.

#### Fedora

NOTE: **Note:**
These instructions don't account for using `asdf` for managing some dependencies.

We assume you are using Fedora >= 22.

If you are running Fedora < 27, you'll need to install `go` manually by using the official [go] installation instructions.

NOTE: **Note:**
Fedora 30+ ships PostgreSQL 11.x in default repositories, you can use `postgresql:10` module to install PostgreSQL 10.
But keep in mind that will replace the PostgreSQL 11.x package, so you cannot use both versions at once.

```shell
sudo dnf install fedora-repos-modular
sudo dnf module enable postgresql:10
```

To install dependencies for Fedora:

```shell
sudo dnf install postgresql libpqxx-devel postgresql-libs redis libicu-devel \
  git git-lfs ed cmake rpm-build gcc-c++ krb5-devel go postgresql-server \
  postgresql-contrib re2 GraphicsMagick re2-devel sqlite-devel perl-Digest-SHA \
  perl-Image-ExifTool rsync
sudo curl https://dl.min.io/server/minio/release/linux-amd64/minio --output /usr/local/bin/minio
sudo chmod +x /usr/local/bin/minio
```

You may need to install Redis 5.0 or newer manually.

##### runit

You'll also need to install [runit](http://smarden.org/runit) manually.

The following instructions worked for runit version 2.1.2 - but please make sure you read the up to date installation instructions on [the website](http://smarden.org/runit) before continuing.

1. Download and extract the runit source code to a local folder to compile it:

   ```shell
   wget http://smarden.org/runit/runit-2.1.2.tar.gz
   tar xzf runit-2.1.2.tar.gz
   cd admin/runit-2.1.2
   sed -i -E 's/ -static$//g' src/Makefile
   ./package/compile
   ./package/check
   ```

1. Make sure all binaries in `command/` are accessible from your `PATH` (e.g. symlink / copy them to `/usr/local/bin`)

#### CentOS

NOTE: **Note:**
These instructions don't account for using `asdf` for managing some dependencies.

To install dependencies for Fedora (tested on CentOS 6.5):

```shell
sudo yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-6-x86_64/pgdg-centos10-10-2.noarch.rpm
sudo yum install https://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo yum install postgresql10-server postgresql10-devel libicu-devel git git-lfs cmake \
  gcc-c++ redis ed fontconfig freetype libfreetype.so.6 libfontconfig.so.1 \
  libstdc++.so.6 npm re2 re2-devel GraphicsMagick runit perl-Image-ExifTool \
  rsync sqlite-devel
sudo curl https://dl.min.io/server/minio/release/linux-amd64/minio --output /usr/local/bin/minio
sudo chmod +x /usr/local/bin/minio

bundle config build.pg --with-pg-config=/usr/pgsql-10/bin/pg_config
# This example uses Ruby 2.6.6. Substitute with the current version if different.
sudo rvm install 2.6.6
sudo rvm use 2.6.6
#Ensure your user is in rvm group
sudo usermod -a -G rvm <username>
#add iptables exceptions, or sudo service stop iptables
```

Install `go` manually using the official [go] installation instructions.

Git 1.7.1-3 is the latest Git binary for CentOS 6.5 and GitLab. Spinach tests
will fail due to a higher version requirement by GitLab. You can follow the
instructions found [in the GitLab recipes repository](https://gitlab.com/gitlab-org/gitlab-recipes/tree/master/install/centos#add-puias-computational-repository) to install a newer
binary version of Git.

You may need to install Redis 5.0 or newer manually.

#### OpenSUSE

NOTE: **Note:**
These instructions don't account for using `asdf` for managing some dependencies.

This was tested on `openSUSE Tumbleweed (20200628)`.

> NOTE: OpenSUSE LEAP is currently not supported, because since a8e2f74d PostgreSQL 11+
> is required, but `LEAP 15.1` includes PostgreSQL 10 only.

To install dependencies for OpenSUSE:

```shell
sudo zypper dup
# now reboot with "sudo init 6" if zypper reports:
# There are running programs which still use files and libraries deleted or updated by recent upgrades.
sudo zypper install libxslt-devel postgresql postgresql-devel libpqxx-devel redis libicu-devel git git-lfs ed cmake \
        rpm-build gcc-c++ krb5-devel postgresql-server postgresql-contrib \
        libxml2-devel libxml2-devel-32bit findutils-locate GraphicsMagick \
        exiftool rsync sqlite3-devel postgresql-server-devel \
        libgpg-error-devel libqgpgme-devel yarn curl wget re2-devel
sudo curl https://dl.min.io/server/minio/release/linux-amd64/minio --output /usr/local/bin/minio
sudo chmod +x /usr/local/bin/minio
```

Install `go` manually using [Go](https://golang.org/doc/install) official installation instructions, for example:

```shell
curl -O https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
sudo tar xpzf go1.14.4.linux-amd64.tar.gz -C /usr/local
```

Ensure that `node` has write permissions to install packages using:

```shell
mkdir -p ~/mynode/bin ~/mynode/lib
npm config set prefix ~/mynode
```

Install `runit` (it is no longer included in OpenSUSE):

```shell
wget http://smarden.org/runit/runit-2.1.2.tar.gz
tar xzf runit-2.1.2.tar.gz
cd admin/runit-2.1.2
sed -i -E 's/ -static$//g' src/Makefile
./package/compile
./package/check
sudo ./package/install
```

Setup local Ruby 2.6 environment (see [Ruby](#ruby) for details), for example using [RVM](https://rvm.io/):

```shell
curl -sSL -o setup_rvm.sh https://get.rvm.io
chmod a+rx setup_rvm.sh
./setup_rvm.sh
source  /home/ansible/.rvm/scripts/rvm
rvm install 2.6
```

Append these lines to your `~/.bashrc`:

```shell
# to find binaries installed by yarn command
export PATH="$HOME/.yarn/bin:$PATH"
# to find sshd and redis-server in default path
export PATH="$PATH:/usr/sbin"
# to find go
export PATH="$HOME/go/bin:/usr/local/go/bin:$PATH"
# local node packages
export PATH="$HOME/mynode/bin:$PATH"
# GDK is confused with OSTYPE=linux (suse default)
export OSTYPE=linux-gnu
```

And reload it using:

```shell
source ~/.bashrc
```

Now determine that the current Ruby version is 2.6.x:

```shell
ruby --version
ruby 2.6.6p146 (2020-03-31 revision 67876) [x86_64-linux]
```

If it's different (for example Ruby 2.7 - system default in Tumbleweed), you must sign in again.

The following `bundle config` options are recommended before you run `gdk install` to avoid problems with the embedded libraries inside `nokogiri` and `gpgme`:

```shell
bundle config build.nokogiri "--use-system-libraries" --global
bundle config build.gpgme --use-system-libraries
```

Now you can proceed to [set up GDK](index.md).

### Install FreeBSD dependencies

To install dependencies for FreeBSD:

```shell
sudo pkg install postgresql10-server postgresql10-contrib postgresql-libpqxx \
redis go node icu krb5 gmake re2 GraphicsMagick p5-Image-ExifTool git-lfs minio sqlite3
```
