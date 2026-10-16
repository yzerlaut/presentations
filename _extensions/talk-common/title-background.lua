--[[
  title-background.lua -- title-slide background of the talk template.

  Inlines the svgs of the current variant (lines-top, lines-bottom, ICM, SU,
  in this order) as data URIs in a <style> applied to slides with
  data-state="is-title-slide".  Sizes/positions are in common.scss.
  (Inlining keeps it working with `embed-resources: true`, and from any folder.)
]]

local here = pandoc.path.directory(debug.getinfo(1, "S").source:gsub("^@", ""))
local paths = dofile(pandoc.path.join({ here, "talk-paths.lua" }))

function Meta(meta)
  local urls = {}
  for _, name in ipairs({ "lines-top.svg", "lines-bottom.svg", "ICM.svg", "SU.svg" }) do
    local uri = paths.data_uri(paths.file(meta, name))
    if uri then
      table.insert(urls, 'url("' .. uri .. '")')
    else
      quarto.log.warning("title-background.lua: cannot read " .. paths.file(meta, name))
    end
  end
  if #urls == 0 then return nil end
  quarto.doc.include_text("in-header", "<style>\n" ..
    ".is-title-slide .slide-background.present .slide-background-content {\n" ..
    "  background-image: " .. table.concat(urls, ",\n    ") .. " !important;\n}\n" ..
    "</style>")
  return nil
end
