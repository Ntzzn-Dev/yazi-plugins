local M = {}

local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

function M:entry()
	local selected = selected_or_hovered() 

	local pos = { "center", w = 50 }
  local archive = os.date("archive_%Y%m%d_%H%M%S.tar.gz")

	local input_value, input_event = ya.input({
		title = "Compact as (targz):",
		value = archive,
		pos = pos,
	})

	if input_event == 1 and input_value and #input_value > 0 then

		if not input_value:match("%.tar%.gz$") then
			input_value = input_value .. ".tar.gz"
		end

		local args = { "czf", input_value }
		for _, path in ipairs(selected) do
			local dir = path:match("^(.*)/[^/]+$") or "."
			local name = path:match(".*/([^/]+)$") or path 
			table.insert(args, "-C")
			table.insert(args, dir)
			table.insert(args, name)
		end	

		local cmd = Command("tar"):arg( args )
		local status, err = cmd:status()
		if not status then
			return true, Err("Failed to start `tar`, error: %s", err)
		elseif not status.success then
			return false, Err("`tar` exited with error code: %s", status.code)
		else
			ya.notify({
				title = "targz-maker",
				content = "Criado " .. input_value,
				timeout = 3,
			})
			return true
		end
	end  
end

return M
