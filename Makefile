.NOTPARALLEL:

START_TIME := $(shell date "+%s")

DIVIDER = "--------------------------------------------------------------------------------"

SHELL = /bin/bash
ASDF := $(shell command -v asdf 2> /dev/null)
RAKE := $(shell command -v rake 2> /dev/null)
BUNDLE := $(shell command -v bundle 2> /dev/null)
YARN := $(shell command -v yarn 2> /dev/null)

# Speed up Go module downloads
export GOPROXY ?= https://proxy.golang.org

# Silence Rollup when building GitLab Docs with nanoc
export ROLLUP_OPTIONS = --silent

NO_RUBY_REQUIRED := bootstrap

# Generate a Makefile from Ruby and include it
ifdef RAKE
ifeq (,$(filter $(NO_RUBY_REQUIRED), $(MAKECMDGOALS)))
include $(shell rake gdk-config.mk)
endif
endif

include Makefile.timing.mk
include Makefile.bootstrap.mk
include Makefile.asdf.mk

include Makefile.influxdb.mk
include Makefile.minio.mk
include Makefile.redis.mk
include Makefile.elasticsearch.mk
include Makefile.postgresql.mk
include Makefile.postgresql-replication.mk
include Makefile.postgresql-geo.mk
include Makefile.prometheus.mk
include Makefile.grafana.mk
include Makefile.nginx.mk
include Makefile.openssh.mk
include Makefile.registry.mk
include Makefile.jaeger.mk

.PHONY: test
include Makefile.preflight-checks.mk
include Makefile.test.mk

include Makefile.gitlab.mk
include Makefile.gitlab-shell.mk
include Makefile.gitaly.mk
include Makefile.gitlab-docs.mk
include Makefile.gitlab-geo.mk
include Makefile.gitlab-workhorse.mk
include Makefile.gitlab-elasticsearch.mk
include Makefile.gitlab-pages.mk
include Makefile.gitlab-k8s.mk
include Makefile.gitlab-ui.mk
include Makefile.gitlab-runner.mk
include Makefile.gitlab-spamcheck.mk

ifeq ($(platform),darwin)
OPENSSL_PREFIX := $(shell brew --prefix openssl)
OPENSSL := ${OPENSSL_PREFIX}/bin/openssl
else
OPENSSL := $(shell command -v openssl 2> /dev/null)
endif

quiet_bundle_flag = $(shell ${gdk_quiet} && echo "--quiet")
bundle_install_cmd = ${BUNDLE} install --jobs 4 ${quiet_bundle_flag} ${BUNDLE_ARGS}

# Borrowed from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Makefile#n87
#
ifeq ($(gdk_debug),true)
	Q =
	QQ =
else
	Q = @
	QQ = > /dev/null
endif

QQerr = 2> /dev/null

ifeq ($(shallow_clone),true)
git_depth_param = --depth=1
endif

# This is used by `gdk install` and `gdk reconfigure`
#
.PHONY: all
all: preflight-checks \
gitlab-setup \
gitlab-shell-setup \
gitlab-workhorse-setup \
gitlab-pages-setup \
gitlab-k8s-agent-setup \
support-setup \
gitaly-setup \
geo-config \
prom-setup \
object-storage-setup \
gitlab-elasticsearch-indexer-setup \
grafana-setup \
gitlab-ui-setup \
gitlab-docs-setup \
gitlab-spamcheck-setup \

# This is used by `gdk install`
#
.PHONY: install
install: all show-installed-at start

# This is used by `gdk update`
#
# Pull gitlab directory first since dependencies are linked from there.
.PHONY: update
update: update-start \
asdf-update \
preflight-checks \
preflight-update-checks \
gitlab-git-pull \
ensure-databases-running \
unlock-dependency-installers \
gitlab-translations-unlock \
gitlab-shell-update \
gitlab-workhorse-update \
gitlab-pages-update \
gitlab-k8s-agent-update \
gitaly-update \
gitlab-update \
gitlab-elasticsearch-indexer-update \
object-storage-update \
jaeger-update \
grafana-update \
gitlab-ui-update \
gitlab-docs-update \
gitlab-spamcheck-update \
update-summarize

.PHONY: update-start
update-start:
	@support/dev/makefile-timeit start

.PHONY: update-summarize
update-summarize:
	@echo
	@echo "${DIVIDER}"
	@echo "Timings"
	@echo "${DIVIDER}"
	@echo
	@support/dev/makefile-timeit summarize
	@echo
	@echo "${DIVIDER}"
	@echo "Updated successfully as of $$(date +"%Y-%m-%d %T")"
	@echo "${DIVIDER}"

# This is used by `gdk reconfigure`
#
.PHONY: reconfigure
reconfigure: ensure-required-ruby-bundlers-installed \
touch-examples \
unlock-dependency-installers \
postgresql-sensible-defaults \
all \
show-reconfigured-at

.PHONY: clean
clean:
	@true

self-update: unlock-dependency-installers
	@echo
	@echo "${DIVIDER}"
	@echo "Running self-update on GDK"
	@echo "${DIVIDER}"
	$(Q)git stash ${QQ}
	$(Q)support/self-update-git-worktree ${QQ}

clean-config:
	$(Q)rm -rf \
	Procfile \
	gitaly/gitaly-*.praefect.toml \
	gitaly/gitaly.config.toml \
	gitaly/praefect.config.toml \
	gitlab-pages/gitlab-pages.conf \
	gitlab-runner-config.toml \
	gitlab-shell/.gitlab_shell_secret \
	gitlab-shell/config.yml \
	gitlab-spamcheck/config/config.toml \
	gitlab/workhorse/config.toml \
	gitlab/config/cable.yml \
	gitlab/config/database.yml \
	gitlab/config/database_geo.yml \
	gitlab/config/gitlab.yml \
	gitlab/config/puma.rb \
	gitlab/config/resque.yml \
	gitlab/config/redis.cache.yml \
	gitlab/config/redis.queues.yml \
	gitlab/config/redis.shared_state.yml \
	gitlab/config/redis.trace_chunks.yml \
	jaeger \
	localhost.crt \
	localhost.key \
	nginx/conf/nginx.conf \
	prometheus/prometheus.yml \
	redis/redis.conf \
	registry/config.yml \
	registry_host.crt \
	registry_host.key

touch-examples:
	$(Q)touch \
	gitlab-shell/config.yml.example \
	gitlab/workhorse/config.toml.example \
	$$(find support/templates -name "*.erb")

unlock-dependency-installers:
	$(Q)rm -f \
	.gitlab-bundle \
	.gitlab-shell-bundle \
	.gitlab-yarn \
	.gitlab-ui-yarn

gdk.yml:
	$(Q)touch $@

.PHONY: Procfile
Procfile:
	$(Q)rake $@

.PHONY: rake
rake:
	$(Q)command -v $@ ${QQ} || gem install $@

.PHONY: ensure-databases-running
ensure-databases-running: Procfile postgresql/data gitaly-setup
	@echo
	@echo "${DIVIDER}"
	@echo "Ensuring necessary data services are running"
	@echo "${DIVIDER}"
	$(Q)gdk start rails-migration-dependencies

.PHONY: ensure-required-ruby-bundlers-installed
ensure-required-ruby-bundlers-installed:
	@echo
	@echo "${DIVIDER}"
	@echo "Ensuring all required versions of bundler are installed"
	@echo "${DIVIDER}"
	${Q}. ./support/bootstrap-common.sh ; ruby_install_required_bundlers

.PHONY: diff-config
diff-config: touch-examples
	$(Q)gdk $@

support-setup: Procfile redis gitaly-setup jaeger-setup postgresql openssh-setup nginx-setup registry-setup elasticsearch-setup runner-setup

.PHONY: start
start:
	@echo
	$(Q)gdk start

.PHONY: ask-to-restart
ask-to-restart:
	@echo
	$(Q)support/ask-to-restart
	@echo

.PHONY: show-installed-at
show-installed-at:
	@echo
	@echo "> Installed as of $$(date +"%Y-%m-%d %T"). Took $$(($$(date +%s)-${START_TIME})) second(s)."

.PHONY: show-reconfigured-at
show-reconfigured-at:
	@echo
	@echo "> Reconfigured as of $$(date +"%Y-%m-%d %T"). Took $$(($$(date +%s)-${START_TIME})) second(s)."
