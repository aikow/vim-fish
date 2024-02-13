vim.opt_local.comments = { ":#" }
vim.opt_local.commentstring = "#%s"
vim.opt_local.define = [[\v^\s*function>]]
vim.opt_local.include = [[\v^\s*\.>]]
vim.opt_local.suffixesadd:prepend(".fish")

if vim.fn.executable("fish_indent") == 1 then
  vim.opt_local.formatexpr = "fish#Format()"
end

if vim.fn.executable("fish") == 1 then
  vim.opt_local.omnifunc = "v:lua.require'fish'.complete"

  -- Update with fish function path.
  local fish_paths = vim
    .system({ "fish", "-c", "echo $fish_function_path" }, { text = true })
    :wait()
  for path in vim.gsplit(fish_paths.stdout, "\n") do
    vim.opt_local.path:append(path)
  end
else
  vim.opt_local.omnifunc = "syntaxcomplete#Complete"
end

-- Use the 'man' wrapper function in fish to include fish's man pages.
-- Have to use a script for this; 'fish -c man' would make the the man page an
-- argument to fish instead of man.
local fish_man_path = vim.fn.expand("<sfile>:p:h:h") .. "/bin/man.fish"
vim.opt_local.keywordprg = vim.fn.fnameescape(fish_man_path)
