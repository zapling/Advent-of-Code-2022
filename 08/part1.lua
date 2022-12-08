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

local function is_tree_visible(x, y, tree_matrix)
    local matrix_width = #tree_matrix[1]
    local current_tree_height = tree_matrix[y][x]

    -- print('current: ' .. current_tree_height)

    -- Is tree on the border?
    if y == 1 or y == #tree_matrix or x == 1 or x == matrix_width then
        return true
    end

    -- Top
    local visable_from_top = false
    for i = y - 1, 1, - 1 do
        local tree_height = tree_matrix[i][x]

        -- print('top: y: ' .. i .. ' x: ' .. x .. ' height: ' .. tree_height)

        if tree_height < current_tree_height then
            visable_from_top = true
        else
            visable_from_top = false
            break
        end
    end

    -- print(visable_from_top)

    -- Bottom
    local visable_from_bottom = false
    for i = y + 1, #tree_matrix, 1 do
        local tree_height = tree_matrix[i][x]

        -- print('bot: y: ' .. i .. ' x: ' .. x .. ' height: ' .. tree_height)

        if tree_height < current_tree_height then
            visable_from_bottom = true
        else
            visable_from_bottom = false
            break
        end
    end

    -- print(visable_from_bottom)

    -- Left
    local visable_from_left = false
    for i = x - 1, 1, -1 do
        local tree_height = tree_matrix[y][i]

        -- print('left: y: ' .. y .. ' x: ' .. i .. ' height: ' .. tree_height)

        if tree_height < current_tree_height then
            visable_from_left = true
        else
            visable_from_left = false
            break
        end
    end

    -- print(visable_from_left)

    -- Right
    local visable_from_right = false
    for i = x + 1, matrix_width, 1 do
        local tree_height = tree_matrix[y][i]

        -- print('right: y: ' .. y .. ' x: ' .. i .. ' height: ' .. tree_height)

        if tree_height < current_tree_height then
            visable_from_right = true
        else
            visable_from_right = false
            break
        end
    end

    -- print(visable_from_right)

    return visable_from_top or visable_from_bottom or visable_from_left or visable_from_right
end

local function get_visiable_trees(tree_matrix)
    local visable_trees = 0

    for y, row in pairs(tree_matrix) do
        for x, _ in pairs(row) do
            local visiable = is_tree_visible(x, y, tree_matrix)
            if visiable == true then
                visable_trees = visable_trees + 1
            end
        end
    end

    return visable_trees
end

local tree_matrix = get_tree_matrix(util.split_lines(util.read_file('input.txt')))
local visable_trees = get_visiable_trees(tree_matrix)
print(visable_trees)


-- print(is_tree_visible(2,3, tree_matrix))
