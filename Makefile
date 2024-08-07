IMPORT_MAP ?= --import-map=import_map.json
PERMISSIONS ?= --allow-env --allow-read --allow-write --allow-run

.PHONY: logo
logo:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts logo

.PHONY: healthcheck
healthcheck: OPTS ?=
healthcheck:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts healthcheck $(OPTS)

.PHONY: setup
setup:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts setup

.PHONY: update-brew
update-brew:
	cd brew && brew bundle

.PHONY: brew-cleanup
brew-cleanup:
	cd brew && brew bundle cleanup --force
