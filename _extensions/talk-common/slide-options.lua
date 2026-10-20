--[[
  slide-options.lua -- per-slide & per-deck layout options of the talk template

  slide:   ## Title {indent=5em spacing=0.8em}
  deck:    slide-indent: 5em      (YAML header; default 4em)
           slide-spacing: 0.8em   (default 1.5em)

  indent:  left indent of the slide content (the title stays in place)
  spacing: vertical gap between items (paragraphs, lists, list items, ...)
  values:  any CSS length; a bare number means em
  -> CSS variables --talk-indent / --talk-spacing, used in common.scss
]]

local OPTIONS = { indent = "--talk-indent", spacing = "--talk-spacing" }

local function length(value)
  value = pandoc.utils.stringify(value)
  if value:match("^[%d.]+$") then value = value .. "em" end  -- bare number -> em
  return value
end

local function css(options)
  local decl = {}
  for name, var in pairs(OPTIONS) do
    if options[name] then
      table.insert(decl, var .. ": " .. length(options[name]) .. ";")
    end
  end
  return table.concat(decl, " ")
end

function Header(el)
  local options, found = {}, false
  for name, _ in pairs(OPTIONS) do
    if el.attributes[name] then
      options[name] = el.attributes[name]
      el.attributes[name] = nil
      found = true
    end
  end
  if not found then return nil end
  local style = el.attributes["style"]
  el.attributes["style"] = ((style and style:gsub(";?%s*$", "; ")) or "") .. css(options)
  return el
end

function Meta(meta)
  local decl = css({ indent = meta["slide-indent"], spacing = meta["slide-spacing"] })
  if decl ~= "" then
    quarto.doc.include_text("in-header",
      "<style>\n.reveal .slides { " .. decl .. " }\n</style>")
  end
  return nil
end

return { { Meta = Meta }, { Header = Header } }
