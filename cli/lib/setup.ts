import { join } from "std/path/mod.ts";
import { home, LinkMap } from "lib/linkMap.ts";
import { exists } from "lib/file.ts";
import { Deps } from "lib/deps.ts";

export interface SetupOptions {
  withDeps: boolean;
}

async function initializeDirs() {
  if (!await exists(join(home, ".config"))) {
    await Deno.mkdir(join(home, ".config"));
  }
  if (!await exists(join(home, ".skk"))) {
    await Deno.mkdir(join(home, ".skk"));
  }
}
async function setup(linkMap: LinkMap, options: SetupOptions) {
  await initializeDirs();

  if (options.withDeps) {
    const dp = new Deps();
    await dp.all();
  }

  for (const [key, value] of linkMap) {
    console.log(`Linking ${key}...`);
    if (await exists(value.symlink)) {
      console.log(`${key} symlink already exists, skipping...`);
      continue;
    }
    await Deno.symlink(value.target, value.symlink);
    console.log(`Linked ${key}!`);
  }
}

export { setup };
