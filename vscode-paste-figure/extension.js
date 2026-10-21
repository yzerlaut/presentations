// Paste an image from the clipboard into a .qmd (like Obsidian):
// the image is saved as <folder>/pasted-YYYYMMDD-HHMMSS.png next to the deck
// (folder: setting pasteFigure.folder, default "figures") and ![](...) is inserted.

const vscode = require("vscode");

const EXT = { "image/png": "png", "image/jpeg": "jpg", "image/gif": "gif", "image/webp": "webp", "image/svg+xml": "svg" };
const KIND = vscode.DocumentDropOrPasteEditKind.Empty.append("quarto", "figure");

function timestamp() {
  const d = new Date(), p = (n) => String(n).padStart(2, "0");
  return `${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}-${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

async function exists(uri) {
  try { await vscode.workspace.fs.stat(uri); return true; } catch { return false; }
}

class PasteFigure {
  async provideDocumentPasteEdits(document, _ranges, dataTransfer) {
    const mime = Object.keys(EXT).find((m) => dataTransfer.get(m)?.asFile());
    if (!mime) return undefined;
    const data = await dataTransfer.get(mime).asFile().data();

    const folder = vscode.workspace.getConfiguration("pasteFigure", document).get("folder") || "figures";
    const dir = vscode.Uri.joinPath(document.uri, "..", folder);
    let name = `pasted-${timestamp()}.${EXT[mime]}`;
    for (let i = 2; await exists(vscode.Uri.joinPath(dir, name)); i++) {
      name = `pasted-${timestamp()}-${i}.${EXT[mime]}`;
    }

    const edit = new vscode.DocumentPasteEdit(`![](${folder}/${name})`, `Save to ${folder}/ and insert link`, KIND);
    edit.additionalEdit = new vscode.WorkspaceEdit();
    edit.additionalEdit.createFile(vscode.Uri.joinPath(dir, name), { contents: data });
    return [edit];
  }
}

function activate(context) {
  context.subscriptions.push(
    vscode.languages.registerDocumentPasteEditProvider({ language: "quarto" }, new PasteFigure(), {
      providedPasteEditKinds: [KIND],
      pasteMimeTypes: Object.keys(EXT),
    })
  );
}

module.exports = { activate };
