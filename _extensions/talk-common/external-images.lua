--[[
  external-images.lua -- images living outside the deck folder.

  quarto preview only serves the deck folder, so an image such as
      ![](../../../_attachments/Pasted%20image%2020261020171016.png)
  (e.g. pasted in Obsidian) would not show.  Such images are embedded in the
  html as data URIs.  When the path does not exist, the file name is also
  looked up in the `_attachments/` folders of all parent directories
  (Obsidian's attachment folder), so the exact number of `../` doesn't matter.
  Images inside the deck folder are left untouched.
]]

local mime = {
  png = "image/png", jpg = "image/jpeg", jpeg = "image/jpeg", gif = "image/gif",
  svg = "image/svg+xml", webp = "image/webp", bmp = "image/bmp", avif = "image/avif",
}

local function url_decode(s)
  return (s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

local function exists(path)
  local f = io.open(path, "rb")
  if f then f:close() end
  return f ~= nil
end

local function deck_dir()
  local input = quarto.doc.input_file or PANDOC_STATE.input_files[1]
  if not input then return pandoc.system.get_working_directory() end
  if not pandoc.path.is_absolute(input) then
    input = pandoc.path.join({ pandoc.system.get_working_directory(), input })
  end
  return pandoc.path.directory(input)
end

-- `name` in the _attachments/ folder of `dir` or of one of its parents
local function find_attachment(dir, name)
  while true do
    local candidate = pandoc.path.join({ dir, "_attachments", name })
    if exists(candidate) then return candidate end
    local parent = pandoc.path.directory(dir)
    if parent == dir then return nil end
    dir = parent
  end
end

function Image(img)
  local src = img.src
  if src:match("^%a[%w+.-]*:") and not src:match("^%a:[/\\]") then return nil end -- http:, data:, ...

  local path = url_decode(src)
  local mt = mime[(path:match("%.(%w+)$") or ""):lower()]
  if not mt then return nil end

  local dir = deck_dir()
  local full = pandoc.path.is_absolute(path) and path or pandoc.path.join({ dir, path })
  if exists(full) then
    local inside = not pandoc.path.is_absolute(path)
      and not pandoc.path.normalize(path):match("^%.%.")
    if inside then return nil end
  else
    full = find_attachment(dir, pandoc.path.filename(path))
    if not full then
      quarto.log.warning("image not found: " .. src)
      return nil
    end
  end

  local f = io.open(full, "rb")
  local data = f:read("a")
  f:close()
  img.src = "data:" .. mt .. ";base64," .. quarto.base64.encode(data)
  return img
end
