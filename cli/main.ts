import { Command } from "cliffy/command";
import {
  healthcheck,
  HealthCheckError,
  HealthCheckOptions,
} from "lib/healthcheck.ts";
import { setup, SetupOptions } from "lib/setup.ts";
import { logo } from "lib/logo.ts";
import { linkMap } from "lib/linkMap.ts";

const cliName = "df-cli";
const cliDescription = "Command line tool for ucpr's dotfiles management";
const version = "0.1.0";

const cmd = new Command()
  .name(cliName)
  .version(version)
  .description(cliDescription)
  .command("logo", "Print the logo")
  .action(() => {
    logo();
  })
  .command("setup", "Setup the dotfiles")
  .throwErrors()
  .option("--with-deps", "setup with dependencies")
  .action(async (options: SetupOptions) => {
    await setup(linkMap, options);
  })
  .command("healthcheck", "Check the health of the dotfiles")
  .throwErrors()
  .option("--ci", "Run in CI mode")
  .action(async (options: HealthCheckOptions) => {
    await healthcheck(linkMap, options);
  });

try {
  await cmd.parse(Deno.args);
} catch (error) {
  if (error instanceof HealthCheckError) {
    console.error("[HEALTH_CHECK_ERROR]:", error.message);
    Deno.exit(1);
  }
  console.error("UNEXPECT_ERROR", error);
}
