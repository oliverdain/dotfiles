local function url_encode(str)
    if str then
        str = string.gsub(str, "([^%w%-%.%_%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
    end
    return str
end

function connections_from_creds()
    -- Create a connection for each SQL connection in ~/.companion/creds
    local creds_dir = vim.fn.expand('~/.companion/creds')
    local dbs = {}
    
    if vim.fn.isdirectory(creds_dir) == 1 then
      local files = vim.fn.glob(creds_dir .. '/*sql*', false, true)
      
      for _, file in ipairs(files) do
        local filename = vim.fn.fnamemodify(file, ':t:r')
        local content = vim.fn.readfile(file)
        local yaml_content = table.concat(content, '\n')
        
        local connection_string = yaml_content:match('connect_string:%s*(.-)%s*\n')
        local password = yaml_content:match('password:%s*(.-)%s*\n') or yaml_content:match('password:%s*(.-)%s*$')
        
        if connection_string and password then
          local encoded_password = url_encode(password)
          local url = connection_string:gsub('://([^:@]*)', function(username)
            return '://' .. username .. ':' .. encoded_password
          end)
          if not connection_string:match('@') then
            url = connection_string:gsub('://', '://' .. encoded_password .. '@')
          end

          table.insert(dbs, {name = filename, url = url})
        end
      end
    end

    vim.g.dbs = dbs
end

return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
     connections_from_creds()
  end,
  config = function()
  end,
}
