function dump(o)
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

local function read_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function split_lines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

local content = read_file("input.txt")

local chars = {
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
}

local inverse_char = {}
for k, v in pairs(chars) do
    inverse_char[v] = k
end

local duplicates = {}
for line in split_lines(content) do
    local length = string.len(line)

    local part1 = string.sub(line, 1, length /2)
    local part2 = string.sub(line, length / 2 + 1)

    local line_duplicates = {}
    for char in string.gmatch(part1, '.') do
        local exists_in_part2 = string.find(part2, char)
        if exists_in_part2 ~= nil then
            line_duplicates[exists_in_part2] = char
        end
    end

    for _, v in pairs(line_duplicates) do
        table.insert(duplicates, v)
    end
end

local sum = 0
for _,v in pairs(duplicates) do
    sum = sum + inverse_char[v]
end

print(sum)
