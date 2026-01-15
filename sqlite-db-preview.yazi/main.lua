local M = {}

local function pad(str, len)
    return str .. string.rep(" ", len - #str)
end

function M:peek(job)
    local bd = ""

    local tables, err = Command('sqlite3'):arg({
        tostring(job.file.url),
        ".tables",
    }):output()

    if not tables or not tables.stdout then return end

    for table_name in string.gmatch(tables.stdout, "%S+") do
        -- PRAGMA table_info
        local pragma, err = Command('sqlite3'):arg({
            tostring(job.file.url),
            "PRAGMA table_info(" .. table_name .. ");"
        }):output()

        if not pragma or not pragma.stdout then goto continue end

        -- PRAGMA foreign_key_list
        local fk, err = Command('sqlite3'):arg({
            tostring(job.file.url),
            "PRAGMA foreign_key_list(" .. table_name .. ");"
        }):output()

        local foreign_keys = {}
        if fk and fk.stdout then
            for line in fk.stdout:gmatch("[^\r\n]+") do
                local id, seq, ref_table, from_col, to_col =
                    line:match("([^|]+)|([^|]+)|([^|]+)|([^|]+)|([^|]+)")
                if from_col then
                    foreign_keys[from_col] = {
                        references_table = ref_table,
                        references_column = to_col
                    }
                end
            end
        end

        -- Montar parâmetros e FKs
        local parameters = {}
        local fk_list = {}
        for line in pragma.stdout:gmatch("[^\r\n]+") do
            local cid, name = line:match("([^|]+)|([^|]+)")
            if name then
                if foreign_keys[name] then
                    local fk_info = foreign_keys[name]
                    local fk_line = string.format("%s references: [%s, %s]", 
                                                  name, fk_info.references_table, fk_info.references_column)
                    table.insert(fk_list, fk_line)
                end
                table.insert(parameters, name)
            end
        end

        -- SELECT * FROM tabela
        local output, err = Command('sqlite3'):arg({
            tostring(job.file.url),
            "SELECT * FROM " .. table_name .. ";",
        }):output()

        if not output or not output.stdout then goto continue end

        local table_data = {}
        table.insert(table_data, parameters)

        for line in output.stdout:gmatch("[^\r\n]+") do
            local row = {}
            for cell in line:gmatch("([^|]+)") do
                cell = cell:gsub("^%s*(.-)%s*$", "%1")
                table.insert(row, cell)
            end
            table.insert(table_data, row)
        end

        -- Colunas e largura inicial
        local col_widths = {}
        for _, row in ipairs(table_data) do
            for col_idx, cell in ipairs(row) do
                col_widths[col_idx] = math.max(col_widths[col_idx] or 0, #cell)
            end
        end

        -- Comprimento máximo de FKs
        local fk_max_length = 0
        for _, fk_line in ipairs(fk_list) do
            fk_max_length = math.max(fk_max_length, #fk_line)
        end

        -- Comprimento inicial da tabela
        local n = #col_widths
        local sum = 0
        for _, w in ipairs(col_widths) do sum = sum + w end
        local table_width = sum + 3*(n-1) + 2

        -- Garantir que a tabela cubra título e FKs
        table_width = math.max(table_width, #table_name, fk_max_length)

        -- Distribuir espaço extra proporcionalmente
        local extra_space = table_width - (sum + 3*(n-1) + 2)
        local extra_per_col = math.floor(extra_space / n)
        local col_widths_adjusted = {}
        for i, w in ipairs(col_widths) do
            col_widths_adjusted[i] = w + extra_per_col
        end

        -- Formatar dados
        local formatted = {}
        for _, row in ipairs(table_data) do
            local line = {}
            for col_idx, cell in ipairs(row) do
                table.insert(line, pad(cell, col_widths_adjusted[col_idx]))
            end
            table.insert(formatted, "│ " .. table.concat(line, " │ ") .. " │")
        end
        local final_table = table.concat(formatted, "\n")

        -- Ajustar linhas de FK centralizadas
        local final_fk_table_lines = {}
        for _, fk_line in ipairs(fk_list) do
            local extra = table_width - #fk_line
            local left_pad = math.floor(extra / 2)
            local right_pad = extra - left_pad
            table.insert(final_fk_table_lines, "│" .. string.rep(" ", left_pad) .. fk_line .. string.rep(" ", right_pad) .. "│")
        end
        local final_fk_table = table.concat(final_fk_table_lines, "\n")

        -- Separadores
        local sepsup = "├"
        for i, w in ipairs(col_widths_adjusted) do
            if i == #col_widths_adjusted then
                sepsup = sepsup .. string.rep("─", w + 2) .. "┤"
            else
                sepsup = sepsup .. string.rep("─", w + 2) .. "┬"
            end
        end

        local sepinf = final_fk_table ~= "" and "├" or "└"
        local sepinf_last_char = final_fk_table ~= "" and "┤" or "┘"
        for i, w in ipairs(col_widths_adjusted) do
            if i == #col_widths_adjusted then
                sepinf = sepinf .. string.rep("─", w + 2) .. sepinf_last_char
            else
                sepinf = sepinf .. string.rep("─", w + 2) .. "┴"
            end
        end

        -- Título centralizado
        local padding = math.floor((table_width - #table_name) / 2)
        local title_line = "│" .. string.rep(" ", padding) .. table_name .. string.rep(" ", table_width - #table_name - padding) .. "│"

        -- Linha final da tabela
        local table_end = final_fk_table ~= "" and final_fk_table .. "\n" .. "└" .. string.rep("─", table_width) .. "┘" .. "\n\n" or "\n"

        bd = bd
            .. "┌" .. string.rep("─", table_width) .. "┐" .. "\n"
            .. title_line .. "\n"
            .. sepsup .. "\n"
            .. final_table .. "\n"
            .. sepinf .. "\n"
            .. table_end

        ::continue::
    end

    if bd ~= "" then
        ya.preview_widget(job, { ui.Text(bd):area(job.area) })
    end
end

function M:seek(job) end

return M
