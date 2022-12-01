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

local elves = {}

local elfNumber = 1
for line in split_lines(content) do
    if line == "" then
        elfNumber = elfNumber + 1
    else
        local item_calories = tonumber(line)

        if elves[elfNumber] == nil then
            elves[elfNumber] = item_calories
        else
            elves[elfNumber] = elves[elfNumber] + item_calories
        end
    end
end

local sorted_elves = {}
for k, v in pairs(elves) do
    sorted_elves[k] = v
end

table.sort(sorted_elves, function(a, b) return a > b end)

local the_most_calories = sorted_elves[1]
local top_3_elves_calories = sorted_elves[1] + sorted_elves[2] + sorted_elves[3]

print(the_most_calories)
print(top_3_elves_calories)
