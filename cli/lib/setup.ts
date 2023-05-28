import { join } from "std/path/mod.ts";
import { home, LinkMap } from "lib/linkMap.ts";
import { exists } from "lib/file.ts";

async function initializeDirs() {
  if (!await exists(join(home, ".config"))) {
    await Deno.mkdir(join(home, ".config"));
  }
}
async function setup(linkMap: LinkMap) {
  await initializeDirs();

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
