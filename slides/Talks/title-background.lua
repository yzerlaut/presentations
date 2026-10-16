--[[
  title-background.lua -- title-slide background of the talk template.

  Reads the `talk-bg` metadata (set in Talks/<variant>/talk.yml): a
  comma-separated list of svgs (lines-top, lines-bottom, ICM, SU), and
  inlines them as data URIs in a <style> applied to slides with
  data-state="is-title-slide".  Sizes/positions are in Talks/common.scss.
  (Inlining keeps it working with `embed-resources: true`, which cannot
  handle reveal's comma-separated `data-background-image`.)
]]

local function read_file(path)
  local f = io.open(path, "rb")
  if not f and PANDOC_STATE and PANDOC_STATE.input_files[1] then
    local dir = pandoc.path.directory(PANDOC_STATE.input_files[1])
    f = io.open(pandoc.path.join({ dir, path }), "rb")
  end
  if not f then return nil end
  local content = f:read("a")
  f:close()
  return content
end

function Meta(meta)
  if not meta["talk-bg"] then return nil end
  local urls = {}
  for path in pandoc.utils.stringify(meta["talk-bg"]):gmatch("[^,]+") do
    path = path:match("^%s*(.-)%s*$")
    local svg = read_file(path)
    if svg then
      table.insert(urls, 'url("data:image/svg+xml;base64,' .. quarto.base64.encode(svg) .. '")')
    else
      quarto.log.warning("title-background.lua: cannot read " .. path)
    end
  end
  if #urls == 0 then return nil end
  quarto.doc.include_text("in-header", "<style>\n" ..
    ".is-title-slide .slide-background.present .slide-background-content {\n" ..
    "  background-image: " .. table.concat(urls, ",\n    ") .. " !important;\n}\n" ..
    "</style>")
  return nil
end
