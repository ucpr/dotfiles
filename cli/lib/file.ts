async function exists(path: string): Promise<boolean> {
  try {
    const file = await Deno.stat(path);
    return file.isFile || file.isDirectory;
  } catch (_err) {
    return false;
  }
}

export { exists };
