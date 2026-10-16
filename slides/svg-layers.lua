--[[
  svg-layers.lua -- animate the Inkscape layers of an SVG figure.

  For an image  ![](figure.svg){.frame}  (or {.layers}) whose SVG has more
  than one top-level Inkscape layer, the SVG is inlined in the slide and
  every layer after the first becomes a reveal.js fragment: the layers
  then appear one by one, in their Inkscape order (bottom layer first).
  Single-layer SVGs are left as normal images.  Add {.no-layers} to opt out.
]]

local function read_file(path)
  local f = io.open(path, "r")
  if not f and PANDOC_STATE and PANDOC_STATE.input_files[1] then
    local dir = pandoc.path.directory(PANDOC_STATE.input_files[1])
    f = io.open(pandoc.path.join({ dir, path }), "r")
  end
  if not f then return nil end
  local content = f:read("a")
  f:close()
  return content
end

-- positions of the opening tags of top-level layers ("<g ... groupmode=layer")
local function top_level_layers(svg)
  local layers, depth, pos = {}, 0, 1
  while true do
    local s, e, close = svg:find("<(/?)g[%s>/]", pos)
    if not s then break end
    if close == "/" then
      depth = depth - 1
      pos = e + 1
    else
      local tag_end = svg:find(">", s, true)
      local tag = svg:sub(s, tag_end)
      local self_closing = tag:sub(-2) == "/>"
      if depth == 0 and tag:find('inkscape:groupmode="layer"', 1, true) then
        table.insert(layers, { s = s, e = tag_end, self_closing = self_closing })
      end
      if not self_closing then depth = depth + 1 end
      pos = tag_end + 1
    end
  end
  return layers
end

local function add_class(tag, class)
  if tag:find('%sclass="') then
    return (tag:gsub('(%sclass=")', '%1' .. class .. ' ', 1))
  end
  return (tag:gsub("^<(%w+)", "<%1 class=\"" .. class .. "\"", 1))
end

local counter = 0

function Image(img)
  local cls = img.classes
  if not (cls:includes("frame") or cls:includes("layers")) then return nil end
  if cls:includes("no-layers") then return nil end
  if not img.src:match("%.svg$") then return nil end

  local svg = read_file(img.src)
  if not svg then return nil end
  local layers = top_level_layers(svg)
  if #layers < 2 then return nil end

  -- layers 2..n become fragments (edit from the end to keep positions valid)
  for i = #layers, 2, -1 do
    local l = layers[i]
    local tag = svg:sub(l.s, l.e)
    svg = svg:sub(1, l.s - 1) .. add_class(tag, "fragment") .. svg:sub(l.e + 1)
  end

  -- keep only the <svg> element (drop xml prolog / comments before it)
  svg = svg:sub((svg:find("<svg[%s>]")))

  -- unique ids, so that several inlined svgs can't clash
  counter = counter + 1
  local p = "svgl" .. counter .. "-"
  svg = svg:gsub('(%sid=")', '%1' .. p)
           :gsub('url%(#', 'url(#' .. p)
           :gsub('(href=")#', '%1#' .. p)

  -- root <svg>: the image classes (e.g. "frame" for sizing)
  local s, e = svg:find("<svg[^>]*>")
  local root = svg:sub(s, e)
  for _, c in ipairs(cls) do root = add_class(root, c) end
  svg = root .. svg:sub(e + 1)

  return pandoc.RawInline("html", svg)
end
