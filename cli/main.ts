import { Command } from "cliffy/command";
import { healthcheck } from "lib/healthcheck.ts";
import { setup } from "lib/setup.ts";
import { logo } from "lib/logo.ts";
import { linkMap } from "lib/linkMap.ts";

const cliName = "df-cli";
const cliDescription = "Command line tool for ucpr's dotfiles management";
const version = "0.1.0";

await new Command()
  .name(cliName)
  .version(version)
  .description(cliDescription)
  .command("logo", "Print the logo")
  .action(() => {
    logo();
  })
  .command("setup", "Setup the dotfiles")
  .action(() => {
    setup(linkMap);
  })
  .command("healthcheck", "Check the health of the dotfiles")
  .action(() => {
    healthcheck(linkMap);
  })
  .parse(Deno.args);
