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
    target: join(dotfilesDir, ".zshrc"),
    symlink: join(home, ".zshrc"),
    platform: "common",
  }],
  ["zsh", {
    target: join(dotfilesDir, "zsh"),
    symlink: join(home, ".config", "zsh"),
    platform: "common",
  }],
  ["k9s", {
    target: join(dotfilesDir, "k9s"),
    symlink: join(home, ".k9s"),
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
]);

export { 
  home,
  dotfilesDir,
  linkMap,
};
