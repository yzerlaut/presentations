--[[
  talk-logo.lua -- {{< talk-logo ICM >}}, {{< talk-logo SU >}}, ...
  inserts <name>.svg of the current variant (talk-dark / talk-light), inlined
  as a data URI so that it works from any folder.
]]

local here = pandoc.path.directory(debug.getinfo(1, "S").source:gsub("^@", ""))
local paths = dofile(pandoc.path.join({ here, "talk-paths.lua" }))

return {
  ["talk-logo"] = function(args, kwargs, meta)
    local name = pandoc.utils.stringify(args[1])
    local uri = paths.data_uri(paths.file(meta, name .. ".svg"))
    if not uri then
      quarto.log.warning("talk-logo: no logo named " .. name)
      return pandoc.Null()
    end
    return pandoc.Image({}, uri, "", { alt = name })
  end
}
