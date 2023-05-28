import { join } from "https://deno.land/std/path/mod.ts";

type platform = "linux" | "darwin" | "common";

interface config {
  target: string;
  symlink: string;
  platform: platform;
}

const home = Deno.env.get("HOME") || "~/";
const linkMap: Map<string, config> = new Map([
  ["neovim", {
    target: join(Deno.cwd(), "nvim"),
    symlink: join(home, ".config", "nvim"),
    platform: "common",
  }],
  ["wezterm", {
    target: join(Deno.cwd(), "wezterm"),
    symlink: join(home, ".config", "wezterm"),
    platform: "common",
  }],
  [".zshrc", {
    target: join(Deno.cwd(), ".zshrc"),
    symlink: join(home, ".zshrc"),
    platform: "common",
  }],
  ["zsh", {
    target: join(Deno.cwd(), "zsh"),
    symlink: join(home, ".config", "zsh"),
    platform: "common",
  }],
  ["k9s", {
    target: join(Deno.cwd(), "k9s"),
    symlink: join(home, ".k9s"),
    platform: "common",
  }],
  ["gitconfig", {
    target: join(Deno.cwd(), "git/.gitconfig"),
    symlink: join(home, ".gitconfig"),
    platform: "common",
  }],
  ["gitmessage", {
    target: join(Deno.cwd(), "git/.gitmessage"),
    symlink: join(home, ".gitmessage"),
    platform: "common",
  }],
]);

function logo() {
  console.log(`

     _       _    __ _ _
  __| | ___ | |_ / _(_) | ___  ___ 
 / _  |/ _ \\| __| |_| | |/ _ \\/ __| 
| (_| | (_) | |_|  _| | |  __/\\__ \\ 
 \\__,_|\\___/ \\__|_| |_|_|\\___||___/ 

  https://github.com/ucpr/dotfiles

`);
}

async function initialize() {
  if (!await exists(join(home, ".config"))) {
    await Deno.mkdir(join(home, ".config"));
  }
}

async function exists(path: string): Promise<boolean> {
  try {
    const file = await Deno.stat(path);
    return file.isFile || file.isDirectory;
  } catch (_err) {
    return false;
  }
}

if (import.meta.main) {
  logo();

  console.log("initializing...");
  await initialize();

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
