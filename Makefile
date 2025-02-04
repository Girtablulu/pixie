PKGNAME    = pixie
DESTDIR   ?=
PREFIX    ?= /usr
BINDIR     = $(PREFIX)/bin
DATADIR    = $(PREFIX)/share/$(PKGNAME)

GOPROJROOT  = $(GOSRC)/$(PROJREPO)

GOLDFLAGS   = -ldflags "-s -w -X github.com/DataDrake/pixie/assets.DataDir=$(DATADIR)"
GOCC        = go
GOFMT       = $(GOCC) fmt -x
GOGET       = $(GOCC) get $(GOLDFLAGS)
GOBUILD     = $(GOCC) build -v $(GOLDFLAGS) $(GOTAGS)
GOTEST      = $(GOCC) test
GOVET       = $(GOCC) vet
GOINSTALL   = $(GOCC) install $(GOLDFLAGS)

include Makefile.waterlog

GOLINT = golint -set_exit_status

all: build

build:
	@$(call stage,BUILD)
	@$(GOBUILD)
	@$(call pass,BUILD)

test: build
	@$(call stage,TEST)
	@$(GOTEST) ./...
	@$(call pass,TEST)

validate:
	@$(call stage,FORMAT)
	@$(GOFMT) ./...
	@$(call pass,FORMAT)
	@$(call stage,VET)
	@$(call task,Running 'go vet'...)
	@$(GOVET) ./...
	@$(call pass,VET)
	@$(call stage,LINT)
	@$(call task,Running 'golint'...)
	@$(GOLINT) ./...
	@$(call pass,LINT)

install:
	@$(call stage,INSTALL)
	install -Dm 00755 $(PKGNAME) $(DESTDIR)$(BINDIR)/$(PKGNAME)
	install -Dm 00644 data/defaults/palette.json $(DESTDIR)$(DATADIR)/defaults/palette.json
	install -Dm 00644 data/defaults/sprites.json $(DESTDIR)$(DATADIR)/defaults/sprites.json
	install -Dm 00644 data/ui/palette.json $(DESTDIR)$(DATADIR)/ui/palette.json
	install -Dm 00644 data/ui/sprite/editor_toolbar.json $(DESTDIR)$(DATADIR)/ui/sprite/editor_toolbar.json
	install -Dm 00644 data/ui/sprite/sprite_toolbar.json $(DESTDIR)$(DATADIR)/ui/sprite/sprite_toolbar.json
	install -Dm 00644 data/$(PKGNAME).desktop $(DESTDIR)$(PREFIX)/share/applications/$(PKGNAME).desktop
	@$(call pass,INSTALL)

uninstall:
	@$(call stage,UNINSTALL)
	rm -f $(DESTDIR)$(BINDIR)/$(PKGNAME)
	rm -rf $(DESTDIR)$(DATADIR)
	rm -f $(DESTDIR)$(PREFIX)/share/applications/$(PKGNAME).desktop
	@$(call pass,UNINSTALL)

clean:
	@$(call stage,CLEAN)
	@$(call task,Removing executable...)
	@rm $(PKGNAME)
	@$(call pass,CLEAN)
