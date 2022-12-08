#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local function get_tree_matrix(lines)
    local matrix = {}

    for row, line in pairs(lines) do
        if matrix[row] == nil then
            matrix[row] = {}
        end

        for tree in string.gmatch(line, '%d') do
            table.insert(matrix[row], tree)
        end
    end

    return matrix
end


local function get_tree_view_distances(x, y, tree_matrix)
    local matrix_width = #tree_matrix[1]
    local current_tree_height = tree_matrix[y][x]

    local distances = {['top'] = 0, ['bot'] = 0, ['lef'] = 0, ['rig'] = 0}

    -- top
    if y ~= 1 then
        for i = y - 1, 1, -1 do
            local tree_height = tree_matrix[i][x]

            if tree_height >= current_tree_height then
                distances['top'] = distances['top'] + 1
                break
            else
                distances['top'] = distances['top'] + 1
            end
        end
    end

    -- bot
    if y ~= #tree_matrix then
        for i = y + 1, #tree_matrix, 1 do
            local tree_height = tree_matrix[i][x]

            if tree_height >= current_tree_height then
                distances['bot'] = distances['bot'] + 1
                break
            else
                distances['bot'] = distances['bot'] + 1
            end
        end
    end

    -- left
    if x ~= 1 then
        for i = x - 1, 1, -1 do
            local tree_height = tree_matrix[y][i]

            if tree_height >= current_tree_height then
                distances['lef'] = distances['lef'] + 1
                break
            else
                distances['lef'] = distances['lef'] + 1
            end
        end
    end

    -- right
    if x ~= matrix_width then
        for i = x + 1, matrix_width, 1 do
            local tree_height = tree_matrix[y][i]

            if tree_height >= current_tree_height then
                distances['rig'] = distances['rig'] + 1
                break
            else
                distances['rig'] = distances['rig'] + 1
            end
        end
    end

    return distances
end

local function get_scenic_score(distances)
    return distances['top'] * distances['bot'] * distances['lef'] * distances['rig']
end

local function get_top_scenic_score(tree_matrix)
    local top_scenic_score = nil

    for y, row in pairs(tree_matrix) do
        for x, _ in pairs(row) do
            local distances = get_tree_view_distances(x, y, tree_matrix)
            local score = get_scenic_score(distances)

            if top_scenic_score == nil or score > top_scenic_score then
                top_scenic_score = score
            end
        end
    end

    return top_scenic_score
end

local tree_matrix = get_tree_matrix(util.split_lines(util.read_file('input.txt')))
local top_scenic_score = get_top_scenic_score(tree_matrix)
print(top_scenic_score)
