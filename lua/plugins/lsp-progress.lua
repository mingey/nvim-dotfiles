return {
  "linrongbin16/lsp-progress.nvim",
   opts = {
		decay = 1200,
    series_format = function(title, message, percentage, done)
      local builder = {}
      local has_title = false
      local has_message = false
      if type(title) == "string" and string.len(title) > 0 then
        table.insert(builder, title)
        has_title = true
      end
      if type(message) == "string" and string.len(message) > 0 then
        table.insert(builder, message)
        has_message = true
      end
      if percentage and (has_title or has_message) then
        table.insert(builder, string.format("(%.0f%%)", percentage))
      end
      return { msg = table.concat(builder, " "), done = done }
    end,
    client_format = function(client_name, spinner, series_messages)
      if #series_messages == 0 then
        return nil
      end
      local builder = {}
      local done = true
      for _, series in ipairs(series_messages) do
        if not series.done then
          done = false
        end
        table.insert(builder, series.msg)
      end
      if done then
        spinner = "✓" -- replace your check mark
      end
      return "["
        .. client_name
        .. "] "
        .. spinner
        .. " "
        .. table.concat(builder, ", ")
    end,
  },
}

-- require("lsp-progress").setup({
--   client_format = function(client_name, spinner, series_messages)
--     if #series_messages == 0 then
--       return nil
--     end
--     return {
--       name = client_name,
--       body = spinner .. " " .. table.concat(series_messages, ", "),
--     }
--   end,
--   format = function(client_messages)
--     --- @param name string
--     --- @param msg string?
--     --- @return string
--     local function stringify(name, msg)
--       return msg and string.format("%s %s", name, msg) or name
--     end
--
--     local sign = "" -- nf-fa-gear \uf013
--     local lsp_clients = vim.lsp.get_active_clients()
--     local messages_map = {}
--     for _, climsg in ipairs(client_messages) do
--       messages_map[climsg.name] = climsg.body
--     end
--
--     if #lsp_clients > 0 then
--       table.sort(lsp_clients, function(a, b)
--         return a.name < b.name
--       end)
--       local builder = {}
--       for _, cli in ipairs(lsp_clients) do
--         if
--           type(cli) == "table"
--           and type(cli.name) == "string"
--           and string.len(cli.name) > 0
--         then
--           if messages_map[cli.name] then
--             table.insert(builder, stringify(cli.name, messages_map[cli.name]))
--           else
--             table.insert(builder, stringify(cli.name))
--           end
--         end
--       end
--       if #builder > 0 then
--         return sign .. " " .. table.concat(builder, ", ")
--       end
--     end
--     return ""
--   end,
-- })
