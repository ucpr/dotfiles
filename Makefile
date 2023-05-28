.PHONY: link
link: PERMISSIONS ?= --allow-env --allow-read --allow-write
link:
	deno run $(PERMISSIONS) main.ts
