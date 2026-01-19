
local get_hovered_info = ya.sync(function()
  local h = cx.active.current.hovered
  if not h then
    return nil
  end

  return {
    url = h.url,
    is_dir = h.cha.is_dir,
  }
end)

local function nameTMPfile(url)
  local name = url:match("^.*/([^/]+)/?$")
  return name
end

return {
  entry = function(self, job)
    local enter_shift = job.args[1] == "notenterdir" 
    local hovered = get_hovered_info()

    local entries = rt.args.entries
    local is_termfilechooser = rt.args.chooser_file or rt.args.cwd_file
    local entry = entries[#entries]
    local entry_is_dir = entry and fs.cha(entry).is_dir

    if hovered and hovered.is_dir and not enter_shift then
	    ya.emit("enter", { hovered = not self.open_multi })
    elseif is_termfilechooser ~= nil then
      -- Download
      if not entry_is_dir then
        local pos = { "center", w = 50 }

        local input_value, input_event = ya.input({
          title = "Save as:",
          value = nameTMPfile(tostring(entry)),
          pos = pos,
        })

        if input_event == 1 and input_value and #input_value > 0 then
          local new_path = "./" .. input_value

          local f, err = io.open(new_path, "w")
          if not f then
            ya.notify {
              title = "Erro",
              content = err,
              timeout = 3,
            }
            return
          end
          f:close()

          ya.emit("reveal", { new_path })
          ya.emit("open", { hovered = true })
        end
      -- Upload
      else
        ya.emit("open", { hovered = false })
      end
    else
      ya.emit("open", {
        hovered = true,
        interactive = enter_shift,
      })
    end
  end,
}