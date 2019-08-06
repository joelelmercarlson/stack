# git
GIT     := git
GITDIFF := $(GIT) diff
GITLOG  := $(GIT) log

# go
GO        := go
GOBUILD   := $(GO) build
GOCLEAN   := $(GO) clean
GOGET     := $(GO) get
GOINSTALL := $(GO) install
GOLIST    := $(GO) list
GOTEST    := $(GO) test

# package: confidence
PACKAGE := confidence
BIN     := $(GOPATH)/bin
DATA    := $(GOPATH)/data
SRC     := $(GOPATH)/src
BASE    := $(SRC)/$(PACKAGE)
PKGS    := $(shell $(GOLIST) ./... | grep -v /vendor)

# data: confidence
BINARY  := $(BIN)/$(PACKAGE)
DATA1   := $(DATA)/confidence.json
DATA3   := $(DATA)/2019_osfi_compute.json

# cycle
PACKAGE1 := cycle
BINARY1 := $(BIN)/$(PACKAGE1)
DATA2 := $(DATA)/rally.json

# tools
COMMIT := $(BIN)/commit
OOO    := $(BIN)/ooo

.PHONY: all test build clean run
all: build test

build: 
	cd $(BIN) && $(GOBUILD) $(PACKAGE)

clean:
	$(GOCLEAN) && rm -f $(BINARY) $(COMMIT) $(OOO)

commit:
	$(COMMIT)

confidence:
	@cd $(BIN) && $(GOBUILD) $(PACKAGE)
	@$(GORUN) $(BINARY) < $(DATA1)

2019:
	@cd $(BIN) && $(GOBUILD) $(PACKAGE)
	@$(GORUN) $(BINARY) < $(DATA3)

adjust:
	cd $(BIN) && $(GOBUILD) $(PACKAGE1)
	$(GORUN) $(BINARY1) adjust < $(DATA2)

cycle:
	@cd $(BIN) && $(GOBUILD) $(PACKAGE1)
	@$(GORUN) $(BINARY1) < $(DATA2)

debug:
	cd $(BIN) && $(GOBUILD) $(PACKAGE1)
	$(GORUN) $(BINARY1) debug < $(DATA2)

diff:
	$(GITDIFF)

log:
	$(GITLOG)

ooo:
	@cd $(BIN) && $(GOBUILD) ooo
	@$(GORUN) $(OOO)

run:
	@echo "confidence, cycle both require json on stdin"
	@echo "example: confidence < confidence.json"
	@echo
	@echo "confidence: " $(BINARY)
	@echo "cycle     : " $(BINARY1)

status:
	$(GIT) status

test:
	$(GOTEST) -v $(PKGS)

tools:
	cd $(BIN) && $(GOBUILD) commit
	cd $(BIN) && $(GOBUILD) ooo
