IMPORT_MAP ?= --import-map=import_map.json
PERMISSIONS ?= --allow-env --allow-read --allow-write --allow-run

.PHONY: healthcheck
healthcheck:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts healthcheck

.PHONY: setup
setup:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts setup
