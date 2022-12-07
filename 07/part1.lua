#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local function get_filetree(output)
    local tree = {}

    local traverse_tree = function(path, scope)
        scope = tree

        for folder in string.gmatch(path, '%S+') do
            if scope[folder] == nil then
                scope[folder] = {}
            else
                scope = scope[folder]
            end
        end
    end

    local create_tree_resource = function(path, l)
        local scope = tree
        for folder in string.gmatch(path, '%S+') do
            scope = scope[folder]
        end

        if string.sub(l, 1, 3) == 'dir' then
            local folder_name = string.sub(l, 5, string.len(l))
            if scope[folder_name] == nil then
                scope[folder_name] = {}
            end
        else
            local file_name = string.gmatch(l, ' (.*)')()
            local size = string.gmatch(l, '(%d+) ')()
            scope[file_name] = size
        end
    end

    local where_am_i = ''
    for _, line in pairs(output) do
        if string.find(line, '%$ cd') then
            local where_to = string.gmatch(line, 'cd (.*)')()
            if where_to == '/' then
                where_to = 'rootbaby' -- :(
            end

            if where_to == '..' then
                local reverse = string.reverse(where_am_i)
                local first_space = string.find(reverse, ' ')
                reverse = string.sub(reverse, first_space + 1, string.len(reverse))

                where_am_i = string.reverse(reverse)
            else
                if string.len(where_am_i) == 0 then
                    where_am_i = where_to
                else
                    where_am_i = where_am_i .. ' ' .. where_to
                end

                traverse_tree(where_am_i)
            end

        elseif string.find(line, '%$ ls') == nil then
            create_tree_resource(where_am_i, line)
        end
    end

    return tree
end


local size = 0
local function traverse_tree_count_size(tree)
    local sum = 0
    for _, v in pairs(tree) do
        if type(v) == 'table' then
            local folder_size = traverse_tree_count_size(v)
            if folder_size < 100000 then
                size = size + folder_size
            end
            sum = sum + folder_size
        else
            sum = sum + v
        end
    end

    return sum
end

local lines = util.split_lines(util.read_file('input.txt'))
local filetree = get_filetree(lines)

traverse_tree_count_size(filetree)

print(size)
