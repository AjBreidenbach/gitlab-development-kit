# GDK commands

## Running

To start up the GDK with all default enabled services, run:

```shell
gdk start
```

To see logs, run:

```shell
gdk tail
```

When you are not using GDK you may want to shut it down to free up
memory on your computer.

```shell
gdk stop
```

If you'd like to run a specific group of services, you can do so by providing
the service names as arguments. Multiple arguments are supported.

### Run just PostgreSQL and Redis

```shell
gdk start postgresql redis
```

### Performance measurements

You can easily create a sitespeed report for local `gdk` urls or
also online urls with our standardised Sitespeed settings.
We support local relative and absolute url's as arguments. As
soon as the report is done it will be automatically opened in your
browser. Needs docker installed and running.

```shell
gdk measure /explore http://127.0.0.1/explore https://gitlab.com/explore
```

## Update GitLab

To update `gitlab` and all of its dependencies, run the following command.

```shell
gdk update
```

It will also perform any possible migrations.

You can update GitLab separately by running `make gitlab-update`, or
update for example `gitlab-shell` with `make gitlab-shell-update`.

If there are changes in the local repositories or/and a different
branch than `master` is checked out, the `make update` commands will
stash any uncommitted changes and change to `master` branch prior to
updating the remote repositories.

## Update configuration files created by `gitlab-development-kit`

Sometimes there are changes in `gitlab-development-kit` that require
you to regenerate configuration files with `make`. You can always
remove an individual file (e.g. `rm Procfile`) and rebuild it by
running `make`. If you want to rebuild _all_ configuration files
created by GDK, run:

```shell
gdk reconfigure
```

## Configuration

With `gdk config` you can interact with the configuration of your
GDK. So far only `gdk config get` exists and it will print the
configuration for the `<setting>` you provide.

```shell
gdk config get <setting>
```

More information can be found in the [configuration documentation](configuration.md).

## Shell completion

To enable tab completion for the `gdk` command in Bash, add the following to your `~/.bash_profile`:

```shell
source ~/path/to/your/gdk/support/completions/gdk.bash
```

For Zsh, you can enable Bash completion support in your `~/.zshrc`:

```shell
autoload bashcompinit
bashcompinit

source ~/path/to/your/gdk/support/completions/gdk.bash
```
