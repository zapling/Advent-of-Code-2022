#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

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

local split_parts = function(s)
    if s:sub(-1)~="\n\n" then s=s.."\n\n" end
    local lines={}
    for line in s:gmatch("(.-)\n\n") do table.insert(lines, line) end
    return lines
end

local content = util.read_file("input.txt")
local parts = split_parts(content)

local cargo_lines = util.split_lines(parts[1])
local cargo_columns = tonumber(string.sub(cargo_lines[#cargo_lines], string.len(cargo_lines[#cargo_lines]) - 1))

local cargo_indexes = {}

local i = 2
local cargo_column = 1
while true do
    if i > cargo_columns * cargo_columns + 1 then
        break
    end

    cargo_indexes[i] = cargo_column
    i = i + 4
    cargo_column = cargo_column + 1
end

cargo_lines[#cargo_lines] = nil

local cargo = {}
for _, v in pairs(cargo_lines) do
    i = 1
    for char in string.gmatch(v, '.') do
        if string.byte(char) ~= 32 then
            cargo_column = cargo_indexes[i]
            if cargo_column ~= nil then
                if cargo[cargo_column] == nil then
                    cargo[cargo_column] = {[1] = char}
                else
                    table.insert(cargo[cargo_column], char)
                end
            end
        end
        i = i + 1
    end
end

for _, v in pairs(util.split_lines(parts[2])) do
    local get_number = string.gmatch(v, "%d+")
    local crates = tonumber(get_number())
    local from = tonumber(get_number())
    local to = tonumber(get_number())

    for _ = 1, crates, 1 do
        local char = cargo[from][1]
        cargo[from][1] = nil
        cargo[from] = util.rebuild_table_index(cargo[from])
        table.insert(cargo[to], 1, char)
    end
end

local sequence = ""
for k, _ in pairs(cargo) do
    sequence = sequence .. cargo[k][1]
end

print(sequence)
