import {
  BaseConfig,
  ContextBuilder,
  Dpp,
  Plugin,
} from "https://deno.land/x/dpp_vim@v0.2.0/types.ts";
import { Denops, fn } from "https://deno.land/x/dpp_vim@v0.2.0/deps.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
    dpp: Dpp;
  }): Promise<{
    plugins: Plugin[];
    stateLines: string[];
  }> {
    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    type Toml = {
      hooks_file?: string;
      ftplugins?: Record<string, string>;
      plugins?: Plugin[];
    };

    type LazyMakeStateResult = {
      plugins: Plugin[];
      stateLines: string[];
    };

    const [context, options] = await args.contextBuilder.get(args.denops);
    const dotfilesDir = "~/.config/nvim/";
    const lazyTomlPaths: string[] = [
      "lua/plugins/core/dein_lazy.toml",
      "lua/plugins/ddu/dein_lazy.toml",
      "lua/plugins/treesitter/dein_lazy.toml",
      "lua/plugins/languages/dein_lazy.toml",
      "lua/plugins/colorscheme/dein_lazy.toml",
      "lua/plugins/ui/dein_lazy.toml",
      "lua/plugins/completion/dein_lazy.toml",
      "lua/plugins/lsp/dein_lazy.toml",
      "lua/plugins/git/dein_lazy.toml"
    ];
    const tomlPaths: string[] = [
      "lua/plugins/core/dein.toml",
    ]

    const tomls: Toml[] = [];
    for (const tomlPath of tomlPaths) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: await fn.expand(args.denops, dotfilesDir + tomlPath),
            options: {
              lazy: false,
            },
          },
        ) as Toml,
      );
    }
    for (const tomlPath of lazyTomlPaths) {
      tomls.push(
        await args.dpp.extAction(
          args.denops,
          context,
          options,
          "toml",
          "load",
          {
            path: await fn.expand(args.denops, dotfilesDir + tomlPath),
            options: {
              lazy: true,
            },
          },
        ) as Toml,
      );
    }

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    tomls.forEach((toml) => {
      for (const plugin of toml.plugins) {
        recordPlugins[plugin.name] = plugin;
      }

      if (toml.ftplugins) {
        for (const filetype of Object.keys(toml.ftplugins)) {
          if (ftplugins[filetype]) {
            ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
          } else {
            ftplugins[filetype] = toml.ftplugins[filetype];
          }
        }
      }

      if (toml.hooks_file) {
        hooksFiles.push(toml.hooks_file);
      }
    });

    const lazyResult = await args.dpp.extAction(
      args.denops,
      context,
      options,
      "lazy",
      "makeState",
      {
        plugins: Object.values(recordPlugins),
      },
    ) as LazyMakeStateResult;

    return {
      hooksFiles,
      plugins: lazyResult.plugins,
      stateLines: lazyResult.stateLines,
    };
  }
}
