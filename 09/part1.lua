#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local head = {['x'] = 0, ['y'] = 0}
local tail = {['x'] = 0, ['y'] = 0}

local function head_touching_tail()
    if head['x'] == tail['x'] and head['y'] == tail['y'] then
        return true
    end

    local x_delta = head['x'] - tail['x']
    if x_delta < 0 then
        x_delta = x_delta * -1
    end

    if x_delta > 1 then
        return false
    end

    local y_delta = head['y'] - tail['y']
    if y_delta < 0 then
        y_delta = y_delta * -1
    end

    if y_delta > 1 then
        return false
    end


    return true
end

local function move_head(direction)
    if direction == 'U' then
        head['y'] = head['y'] + 1
    elseif direction == 'D' then
        head['y'] = head['y'] - 1
    elseif direction == 'L' then
        head['x'] = head['x'] - 1
    elseif direction == 'R' then
        head['x'] = head['x'] + 1
    end
end

local function move_tail(direction)
    if head_touching_tail() == true then
        return
    end

    if direction == 'U' then
        tail['x'] = head['x']
        tail['y'] = tail['y'] + 1
    elseif direction == 'D' then
        tail['x'] = head['x']
        tail['y'] = tail['y'] - 1
    elseif direction == 'L' then
        tail['y'] = head['y']
        tail['x'] = tail['x'] - 1
    elseif direction == 'R' then
        tail['y'] = head['y']
        tail['x'] = tail['x'] + 1
    end
end

local visited_tail_locations = {['0,0'] = 1}

local function move_rope(direction, moves)
    for i = 1, moves, 1 do
        -- print(i)
        move_head(direction)
        move_tail(direction)

        visited_tail_locations[''..tail['x']..','..tail['y']] = 1
        -- print('h: (x,y) = (' .. head['x'] .. ',' .. head['y'] .. ')')
        -- print('t: (x,y) = (' .. tail['x'] .. ',' .. tail['y'] .. ')')
        -- io.read()
    end
end

local function perform_instructions(instructions)
    for _, instruction in pairs(instructions) do
        local direction = string.sub(instruction, 1, 1)
        local moves = tonumber(string.gmatch(instruction, '%d+')())

        move_rope(direction, moves)

    end
end

perform_instructions(util.split_lines(util.read_file('input.txt')))
local num_locations = #util.rebuild_table_index(visited_tail_locations)
print(num_locations)
