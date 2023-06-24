import { GzipStream } from "compress";
import { exists } from "lib/file.ts";

const skkJisyoUrl = "https://skk-dev.github.io/dict/SKK-JISYO.L";

class Skk {
  skkDir: string;
  jisyoFileName: string;

  constructor() {
    this.skkDir = "~/.skk";
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

  async createJisyoFile() {
    if (await exists(this.skkDir)) {
      throw new Error("SKK directory is not found.");
    }
    if (!await exists(this.jisyoFilePath())) {
      const file = await Deno.open(this.jisyoFilePath(), {
        createNew: true,
        write: true,
      });
      file.close();
    }
  }

  // uncompress SKK-JISYO.L.gz to SKK-JISYO.L
  async uncompress(gzData: Uint8Array) {
    await this.createJisyoFile();
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
