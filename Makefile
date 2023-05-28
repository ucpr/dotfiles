.PHONY: cli
cli: IMPORT_MAP ?= --import-map=import_map.json
cli: PERMISSIONS ?= --allow-env --allow-read --allow-write --allow-run
cli:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts logo

.PHONY: setup
setup: IMPORT_MAP ?= --import-map=import_map.json
setup: PERMISSIONS ?= --allow-env --allow-read --allow-write --allow-run
setup:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts setup
