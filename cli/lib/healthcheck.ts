import { Table } from "cliffy/table";
import { exists } from "lib/file.ts";
import { LinkMap, linkMap } from "lib/linkMap.ts";

type TableBody = Array<Array<string>>;

const healthyText = "✅";
const unhealthyText = "❌";

async function healthcheck(linkMap: LinkMap) {
  const header = ["Name", "Target", "Symlink", "Status", "Reason"];
  const body = await checkSymlinks(linkMap);
  new Table()
    .header(header)
    .body(body)
    .padding(1)
    .indent(2)
    .border(true)
    .render();
}

async function checkSymlinks(
  linkMap: LinkMap,
): Promise<TableBody> {
  const result: TableBody = [];
  for (const [name, config] of linkMap) {
    const x: Array<string> = [];
    let reason = "";
    let healthy = "";

    // check symlink and target exist
    if (await exists(config.target) && await exists(config.symlink)) {
      healthy = healthyText;
    } else {
      healthy = unhealthyText;
    }
    // check why it's unhealthy
    if (!await exists(config.target) && !await exists(config.symlink)) {
      reason = "Target and symlink do not exist";
    } else if (!await exists(config.target)) {
      reason = "Target does not exist";
    } else if (!await exists(config.symlink)) {
      reason = "Symlink does not exist";
    } else {
      reason = "";
    }
    x.push(name, config.target, config.symlink, healthy, reason);
    result.push(x);
  }
  return result;
}

export { healthcheck };

if (import.meta.main) {
  console.log(await healthcheck(linkMap));
}
