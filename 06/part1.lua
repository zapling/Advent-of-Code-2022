#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local content = util.read_file('input.txt')

local marker_length = 4

local unique = {}
local current_str = ""

local get_item_count = function(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end

    return count
end

local get_str_count = function(from, s)
    local count = 0
    for char in string.gmatch(from, '.') do
        if char == s then
            count = count + 1
        end
    end

    return count
end

local index = 0
for char in string.gmatch(content, '.') do
    index = index + 1

    if string.len(current_str) == marker_length then
        local first_char = string.sub(current_str, 1, 1)
        current_str = string.sub(current_str, 2) .. char

        if get_str_count(current_str, first_char) == 0 then
            unique[first_char] = nil
        end

        unique[char] = true
    else
        unique[char] = true
        current_str = current_str .. char
    end

    if get_item_count(unique) == marker_length then
        print(index)
        break
    end
end
