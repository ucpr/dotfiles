import { join } from "https://deno.land/std/path/mod.ts";

type platform = "linux" | "darwin" | "common";

interface config {
  target: string;
  symlink: string;
  platform: platform;
}

export type LinkMap = Map<string, config>;

const home = Deno.env.get("HOME") || "~/";
const currentDir = Deno.cwd();
const linkMap: LinkMap = new Map([
  ["neovim", {
    target: join(currentDir, "nvim"),
    symlink: join(home, ".config", "nvim"),
    platform: "common",
  }],
  ["wezterm", {
    target: join(currentDir, "wezterm"),
    symlink: join(home, ".config", "wezterm"),
    platform: "common",
  }],
  [".zshrc", {
    target: join(currentDir, ".zshrc"),
    symlink: join(home, ".zshrc"),
    platform: "common",
  }],
  ["zsh", {
    target: join(currentDir, "zsh"),
    symlink: join(home, ".config", "zsh"),
    platform: "common",
  }],
  ["k9s", {
    target: join(currentDir, "k9s"),
    symlink: join(home, ".k9s"),
    platform: "common",
  }],
  ["gitconfig", {
    target: join(currentDir, "git/.gitconfig"),
    symlink: join(home, ".gitconfig"),
    platform: "common",
  }],
  ["gitmessage", {
    target: join(currentDir, "git/.gitmessage"),
    symlink: join(home, ".gitmessage"),
    platform: "common",
  }],
]);

export { linkMap };
