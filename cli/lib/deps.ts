import { GzipStream } from "compress";

const skkJisyoUrl = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";

class Skk {
  skkDir: string;
  jisyoFileName: string;

  constructor() {
    const home = Deno.env.get("HOME") || "~/";
    this.skkDir = `${home}/.skk`;
    this.jisyoFileName = "SKK-JISYO.L";
  }

  private jisyoFilePath() {
    return `${this.skkDir}/${this.jisyoFileName}`;
  }

  // download SKK JISYO file
  async download(): Promise<Uint8Array> {
    const response = await fetch(skkJisyoUrl);
    const blob = await response.blob();

    const buf = await blob.arrayBuffer();
    const data = new Uint8Array(buf);

    return data;
  }

  // uncompress SKK-JISYO.L.gz to SKK-JISYO.L
  async uncompress(gzData: Uint8Array) {
    const tmpFilePath = await Deno.makeTempFile({
      prefix: "dotfiles_skk_",
      suffix: ".gz",
    });
    await Deno.writeFile(tmpFilePath, gzData);

    const gzip = new GzipStream();
    await gzip.uncompress(tmpFilePath, this.jisyoFilePath());
  }

  // setup SKK
  async setup() {
    const gzData = await this.download();
    await this.uncompress(gzData);
  }
}

export class Deps {
  async nvim() {
    // setup SKK
    const skk = new Skk();
    await skk.setup();
  }

  async all() {
    await this.nvim();
  }
}
