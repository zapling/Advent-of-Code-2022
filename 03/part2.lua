local function read_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function split_lines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    local lines={}
    for line in s:gmatch("(.-)\n") do table.insert(lines, line) end
    return lines
end

local function get_prio(char)
    if char == string.lower(char) then
        return string.byte(char) - string.byte("a") + 1
    else
        return string.byte(char) - string.byte("A") + 27
    end
end

local lines = split_lines(read_file("input.txt"))

local sum = 0
for i = 1, #lines, 3 do
    for char in string.gmatch(lines[i], '.') do
        if string.find(lines[i+1], char) and string.find(lines[i+2], char) then
            sum = sum + get_prio(char)
            break
        end
    end
end

print(sum)
