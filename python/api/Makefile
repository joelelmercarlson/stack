CWD     := $(shell pwd)
ORGPATH := $(CWD)
STACK   := stack
BUILD   := $(STACK) build
COMMIT  := $(ORGPATH)/commit.hs
NEXT    := $(STACK) exec Main next
ORG     := $(STACK) exec Main
STUDY   := $(STACK) exec Main study

GIT       := git
GITDIFF   := $(GIT) diff
GITLOG    := $(GIT) log
GITSTATUS := $(GIT) status
GITPULL   := $(GIT) pull
GITPUSH   := $(GIT) push

build:
	$(BUILD)
	$(ORG)

commit:
	$(COMMIT)

next:
	$(BUILD)
	$(NEXT)

study:
	$(BUILD)
	$(STUDY)

diff:
	$(GITDIFF)

log:
	$(GITLOG)

pull:
	$(GITPULL)

push:
	$(GITPUSH)

help:
	@echo "workflow is one of {build, next, study} then commit."
	@echo "  make build  -> build org"
	@echo "  make next   -> build +1d org"
	@echo "  make study  -> build study"
	@echo "make commit   -> git commit"

run:
	@echo "stack and haskell is used with org"

status:
	$(GITSTATUS)

upgrade:
	$(STACK) upgrade

version:
	$(STACK) --version
