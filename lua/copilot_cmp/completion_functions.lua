local format = require("copilot_cmp.format")
local util = require("copilot.util")
local api = require("copilot.api")

local methods = {
  opts = {
    fix_pairs = true,
  },
}

methods.getCompletions = function(self, params, callback)
  local start_with = function(str, start)
    return string.sub(str, 1, string.len(start)) == start
  end

  local remove_incomplete = function(completions)
    local results = completions
    for i, comp1 in ipairs(completions) do
      for j, comp2 in ipairs(completions) do
        if i ~= j and start_with(comp2.text, comp1.text) then
          results[i] = nil
          break
        end
      end
    end
    return results
  end

  local respond_callback = function(err, response)
    if err or not response or not response.completions then
      return callback({ isIncomplete = false, items = {} })
    end

    local completions = vim.tbl_values(response.completions)
    completions = remove_incomplete(completions)

    local items = vim.tbl_map(function(item)
      return format.format_item(item, params.context, methods.opts)
    end, vim.tbl_values(completions))

    return callback({
      isIncomplete = false,
      items = items,
    })
  end

  api.get_completions(self.client, util.get_doc_params(), respond_callback)
  return callback({ isIncomplete = true, items = {} })
end

methods.init = function(completion_method, opts)
  methods.opts.fix_pairs = opts.fix_pairs
  return methods[completion_method]
end

return methods
