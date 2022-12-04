local M = {}

M.dump = function(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

M.read_file = function(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

M.split_lines = function(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    local lines={}
    for line in s:gmatch("(.-)\n") do table.insert(lines, line) end
    return lines
end


return M
