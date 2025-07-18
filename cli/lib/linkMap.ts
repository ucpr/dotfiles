import { join } from "std/path/mod.ts";

type platform = "linux" | "darwin" | "common";

interface config {
  target: string;
  symlink: string;
  platform: platform;
}

export type LinkMap = Map<string, config>;

const home = Deno.env.get("HOME") || "~/";
const dotfilesDir = await (async (): Promise<string> => {
  const command = new Deno.Command(
    "git",
    {
      args: ["rev-parse", "--show-toplevel"],
    },
  );
  const { code, stdout, stderr } = await command.output();
  if (code === 0) {
    return new TextDecoder().decode(stdout).trim();
  } else {
    console.error(new TextDecoder().decode(stderr));
    return "";
  }
})();

const linkMap: LinkMap = new Map([
  ["neovim", {
    target: join(dotfilesDir, "nvim"),
    symlink: join(home, ".config", "nvim"),
    platform: "common",
  }],
  ["wezterm", {
    target: join(dotfilesDir, "wezterm"),
    symlink: join(home, ".config", "wezterm"),
    platform: "common",
  }],
  [".zshrc", {
    target: join(dotfilesDir, "zsh/.zshrc"),
    symlink: join(home, ".zshrc"),
    platform: "common",
  }],
  ["zsh", {
    target: join(dotfilesDir, "zsh"),
    symlink: join(home, ".config", "zsh"),
    platform: "common",
  }],
  ["mise", {
    target: join(dotfilesDir, "mise"),
    symlink: join(home, ".config", "mise"),
    platform: "common",
  }],
  ["k9s", {
    target: join(dotfilesDir, "k9s"),
    symlink: join(home, ".config", "k9s"),
    platform: "common",
  }],
  ["gitconfig", {
    target: join(dotfilesDir, "git/.gitconfig"),
    symlink: join(home, ".gitconfig"),
    platform: "common",
  }],
  ["gitmessage", {
    target: join(dotfilesDir, "git/.gitmessage"),
    symlink: join(home, ".gitmessage"),
    platform: "common",
  }],
  [
    "gitignore",
    {
      target: join(dotfilesDir, "git/ignore"),
      symlink: join(home, ".config", "git", "ignore"),
      platform: "common",
    },
  ],
  ["sheldon", {
    target: join(dotfilesDir, "sheldon"),
    symlink: join(home, ".config", "sheldon"),
    platform: "common",
  }],
  ["karabiner", {
    target: join(dotfilesDir, "karabiner"),
    symlink: join(home, ".config", "karabiner"),
    platform: "darwin",
  }],
  ["claude", {
    target: join(dotfilesDir, "claude"),
    symlink: join(home, ".config", "claude"),
    platform: "common",
  }],
]);

export { dotfilesDir, home, linkMap };
