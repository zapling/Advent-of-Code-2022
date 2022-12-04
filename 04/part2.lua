#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local function range(start, stop)
    local range_str = ""
    for i = start, stop, 1 do
        if i < 10 then
            i = 0 .. i
        end
        range_str = range_str .. ' ' .. i
    end
    return range_str
end

local function has_overlap(source_range, target_range)
    for num in source_range:gmatch('%d+') do
        if string.find(target_range, num) then
            return true
        end
    end
    return false
end

local overlaps = 0
for _, line in pairs(util.split_lines(util.read_file("input.txt"))) do
    local get_next_number = line:gmatch('%d+')
    local ranges = {
        [1] = range(get_next_number(), get_next_number()),
        [2] = range(get_next_number(), get_next_number())
    }
    if has_overlap(ranges[1], ranges[2]) or has_overlap(ranges[2], ranges[1]) then
        overlaps = overlaps + 1
    end
end

print(overlaps)
