--[[
  hspace.lua -- horizontal space within a line:
    {{< hspace >}}         1em
    {{< hspace 4em >}}     any CSS length: 4em, 40px, 10% ...
]]

return {
  ["hspace"] = function(args, kwargs, meta, raw_args, context)
    local width = (#args > 0) and pandoc.utils.stringify(args[1]) or "1em"
    if width:match("^[%d.]+$") then width = width .. "em" end  -- bare number -> em
    return pandoc.RawInline("html",
      '<span class="hspace" style="display: inline-block; width: ' .. width .. ';"></span>')
  end
}
