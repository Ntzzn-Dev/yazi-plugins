local M = {}

function M:peek(job)
    local start, cache = os.time(), ya.file_cache(job)
    if not cache then
        return
    end

    local ok, err = self:preload(job)
    if not ok or err then
        return ya.preview_widget(job, err)
    end

    local delay = (rt.preview.image_delay / 1000) + 2000
    ya.sleep(math.max(0, start + delay - os.time()))

    local _, err = ya.image_show(cache, job.area)

    ya.preview_widget(job, err)
end

function M:seek() end

local function command_exists(cmd)
    local ok, _, code = os.execute(string.format("command -v %s >/dev/null 2>&1", cmd))
    return ok == true or code == 0
end

function M:preload(job)
    local editors = {
        ["libresprite"] = function(job, png)
            return Command("libresprite"):arg({ "--batch", tostring(job.file.url), "--save-as", tostring(png) })
        end,
        ["aseprite-thumbnailer"] = function(job, png)
            return Command("aseprite-thumbnailer"):arg({ tostring(job.file.url), tostring(png) })
        end,
    }

    local cache = ya.file_cache(job)
    local png = Url(tostring(cache) .. ".png")
    if not cache or fs.cha(cache) then
        return true
    end

    local cmd_builder
    for name, builder in pairs(editors) do
        if command_exists(name) then
            cmd_builder = builder
            break
        end
    end

    if not cmd_builder then
        return false, Err("Nenhum editor de sprites encontrado \nNo sprite editor found \n( libresprite / aseprite-thumbnailer )")
    end

    local cmd = cmd_builder(job, png)
    local output, err = cmd:output()

    if err then
        return true, Err("Failed to start `libresprite`, error: %s", err)
    elseif output and not output.status.success then
        return false, Err("`libresprite` exited with error code: %s", output.status.code)
    elseif output and not fs.cha(png) then
        return false, Err("`libresprite` exited with error: %s", output.stdout)
    end

	local ok = fs.rename(png, cache)
	if not ok then
		return false, Err("Failed to rename cache file (permission denied?)")
	end

    ya.emit("refresh", {})
end

function M:spot(job)
    require("file"):spot(job)
end

return M