#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local split_parts = function(s)
    if s:sub(-1)~="\n\n" then s=s.."\n\n" end
    local lines={}
    for line in s:gmatch("(.-)\n\n") do table.insert(lines, line) end
    return lines
end

local get_indexes = function(num_columns)
    local indexes = {}
    local column = 1
    for i = 2, num_columns * 4, 4 do
        indexes[column] = i
        column = column + 1
    end
    return indexes
end

local get_cargo = function(str, indexes)
    local cargo = {}
    local lines = util.split_lines(str)
    for k, v in pairs(lines) do
        if k ~= #lines then
            for column, index in pairs(indexes) do
                local crate = string.sub(v, index, index)
                if crate ~= ' ' then
                    if cargo[column] == nil then
                        cargo[column] = {[1] = crate}
                    else
                        table.insert(cargo[column], crate)
                    end
                end
            end
        end
    end
    return cargo
end

local move_cargo = function(cargo, instruction_str)
    for _, v in pairs(util.split_lines(instruction_str)) do
        local get_number = string.gmatch(v, "%d+")
        local crates = tonumber(get_number())
        local from = tonumber(get_number())
        local to = tonumber(get_number())
        for i = crates, 1, -1 do
            local crate = cargo[from][i]
            cargo[from][i] = nil
            cargo[from] = util.rebuild_table_index(cargo[from])
            table.insert(cargo[to], 1, crate)
        end
    end
    return cargo
end

local content = util.read_file("input.txt")
local parts = split_parts(content)

local total_columns = tonumber(string.sub(parts[1], string.len(parts[1]) - 1))
local cargo = get_cargo(parts[1], get_indexes(total_columns))
cargo = move_cargo(cargo, parts[2])

local sequence = ""
for k, _ in pairs(cargo) do
    sequence = sequence .. cargo[k][1]
end

print(sequence)
