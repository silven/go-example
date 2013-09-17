# Go super project Makefile
# Authored by Mikael Silvén

# You want to edit these
ROOT_PKG	:= github.com/silven/go-example
PACKAGES 	:= common common/sub

# Maybe even these
CMD_DIR		:= cmd
GOFMT		:= @gofmt -s -tabs -tabwidth=4 -w -l
HTML_FILE	:= coverage.html
COV_REPORT	:= @gocov test $(addprefix $(ROOT_PKG)/, $(PACKAGES)) | gocov report
COV_HTML	:= @gocov test $(addprefix $(ROOT_PKG)/, $(PACKAGES)) | gocov-html > $(HTML_FILE)
GOTEST		:= @go test
GORUN		:= go run
GOVET		:= go vet
OPEN_CMD	:= xdg-open
ZIP_FILE	:= godoc.zip
BIN_DIR		:= bin

# But dont edit these
GOOS		:= $(shell go env GOOS)
GOARCH		:= $(shell go env GOARCH)
GOBUILD		:= GOOS=$(GOOS) GOARCH=$(GOARCH) go build
GOINSTALL	:= GOOS=$(GOOS) GOARCH=$(GOARCH) go install -v
RUNNABLES	:= $(wildcard $(CMD_DIR)/*.go)
PKG_ROOT	:= $(GOPATH)/pkg/$(GOOS)_$(GOARCH)/$(ROOT_PKG)
A_FILES		:= $(foreach pkg, $(PACKAGES), $(PKG_ROOT)/$(pkg).a)
TESTABLE	:= $(foreach pkg, $(PACKAGES), $(wildcard $(pkg)/*.go)) 
GOFILES		:= $(TESTABLE) $(RUNNABLE)

default:	fmt vet test install build

$(notdir $(basename $(RUNNABLES))): .fmt .vet .test install
		@GOOS=$(GOOS) GOARCH=$(GOARCH) $(GORUN) $(CMD_DIR)/$@.go

bench:	$(TESTABLE)
		$(GOTEST) -bench . $(foreach lib, $(sort $(^D)), $(ROOT_PKG)/$(lib))

build:	$(foreach bin, $(notdir $(basename $(RUNNABLES))), $(BIN_DIR)/$(bin))
		
$(BIN_DIR)/%: $(CMD_DIR)/%.go $(TESTABLE)
		@test -d $(BIN_DIR) || mkdir -p $(BIN_DIR) 
		@$(GOBUILD) -o $(BIN_DIR)/$* $<				

test:	$(TESTABLE)
		$(GOTEST) $(foreach lib, $(sort $(^D)), $(ROOT_PKG)/$(lib))

.test:	$(TESTABLE)
		$(GOTEST) $(foreach lib, $(sort $(?D)), $(ROOT_PKG)/$(lib))
		@touch .test

fmt:	$(GOFILES)
		$(GOFMT) $^

.fmt:	$(GOFILES)
		$(GOFMT) $?
		@touch .fmt

vet:	$(TESTABLE)
		$(GOVET) $(addprefix $(ROOT_PKG)/, $(sort $(^D)))

.vet:	$(TESTABLE)
		$(GOVET) $(addprefix $(ROOT_PKG)/, $(sort $(^D)))
		@touch .vet
cov:	
		$(COV_REPORT)

cov-html: $(HTML_FILE)
		$(OPEN_CMD) $(HTML_FILE)

$(HTML_FILE):	
		$(COV_HTML)

godoc:	$(ZIP_FILE)
		$(OPEN_CMD) http://localhost:6060/pkg/$(ROOT_PKG)
		godoc -http=:6060 -zip=$(ZIPFILE)
		
$(ZIP_FILE): 
		@test -e $@ && zip -u -r $@ $? || zip -r $@ $(TESTABLE) $(GOROOT)lib/godoc/

clean:
		$(RM) $(HTML_FILE)
		$(RM) $(ZIPFILE)
		$(RM) -r $(BIN_DIR)
		$(RM) .fmt
		$(RM) .test

install: $(A_FILES)
$(PKG_ROOT)/%.a:	%/*.go
		@cd $* && $(GOINSTALL)

.PHONY: default test fmt install godoc clean cov cov-html build bench
