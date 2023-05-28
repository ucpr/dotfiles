.PHONY: cli
cli: IMPORT_MAP ?= --import-map=import_map.json
cli: PERMISSIONS ?= --allow-env --allow-read --allow-write
cli:
	cd cli && deno run $(IMPORT_MAP) $(PERMISSIONS) main.ts logo
