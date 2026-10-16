-- helpers shared by the talk-common filters/shortcodes:
-- locate the svgs of the current variant (../talk-<variant>/ next to this file)

local M = {}

-- directory of this file (robust: PANDOC_SCRIPT_FILE depends on who loads us)
local here = pandoc.path.directory(debug.getinfo(1, "S").source:gsub("^@", ""))

function M.variant(meta)
  local v = meta and meta["talk-variant"]
  return v and pandoc.utils.stringify(v) or "dark"
end

function M.file(meta, name)
  return pandoc.path.join({ here, "..", "talk-" .. M.variant(meta), name })
end

function M.data_uri(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local svg = f:read("a")
  f:close()
  return "data:image/svg+xml;base64," .. quarto.base64.encode(svg)
end

return M
