local M = {}

M.errorformat = "%Afish: %m,%-G%*\\ ^,%-Z%f (line %l):%s"

---comment
---@param findstart 0 | 1
---@param base string
function M.complete(findstart, base)
  if findstart == 1 then
    return vim.api.nvim_get_current_line():match("^%s*$") and -1 or 0
  end

  if #base == 0 then return {} end

  local completions = vim
    .system(
      {
        "fish",
        "-c",
        string.format("complete -C %s", vim.fn.shellescape(base)),
      },
      { text = true }
    )
    :wait()
  local cmd = string.gsub(base, "%S+$", "")

  return vim
    .iter(vim.gsplit(completions.stdout, "\n"))
    :map(function(line)
      if line == "" then return nil end

      local sep_idx = string.find(line, "\t") or string.len(line)
      local completion = string.sub(line, 1, sep_idx - 1)
      local help = string.sub(line, sep_idx + 1)

      return {
        word = cmd .. completion,
        abbr = completion,
        menu = help or "",
      }
    end)
    :totable()
end

return M
