--[[
  vspace.lua -- vertical space in a slide:
    {{< vspace >}}         1em (about one line of text)
    {{< vspace 3em >}}     any CSS length: 3em, 40px, 5% ...
]]

return {
  ["vspace"] = function(args, kwargs, meta, raw_args, context)
    local height = (#args > 0) and pandoc.utils.stringify(args[1]) or "1em"
    if height:match("^[%d.]+$") then height = height .. "em" end  -- bare number -> em
    if context == "block" then
      return pandoc.RawBlock("html",
        '<div class="vspace" style="height: ' .. height .. ';"></div>')
    end
    return pandoc.RawInline("html",
      '<span class="vspace" style="display: block; height: ' .. height .. ';"></span>')
  end
}
