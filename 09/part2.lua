#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")

local function head_touching_tail(current_knot, knot_ahead)
    if knot_ahead['x'] == current_knot['x'] and knot_ahead['y'] == current_knot['y'] then
        return true
    end

    local x_delta = knot_ahead['x'] - current_knot['x']
    if x_delta < 0 then
        x_delta = x_delta * -1
    end

    if x_delta > 1 then
        return false
    end

    local y_delta = knot_ahead['y'] - current_knot['y']
    if y_delta < 0 then
        y_delta = y_delta * -1
    end

    if y_delta > 1 then
        return false
    end


    return true
end

local function move_head(direction, head)
    if direction == 'U' then
        head['y'] = head['y'] + 1
    elseif direction == 'D' then
        head['y'] = head['y'] - 1
    elseif direction == 'L' then
        head['x'] = head['x'] - 1
    elseif direction == 'R' then
        head['x'] = head['x'] + 1
    end

    return head
end

local function move_tail(current_knot, knot_ahead)
    if head_touching_tail(current_knot, knot_ahead) == true then
        return current_knot
    end

    local x_direction = 1
    local y_direction = 1

    if knot_ahead['y'] < current_knot['y'] then
        y_direction = -1
    end

    if knot_ahead['x'] < current_knot['x'] then
        x_direction = -1
    end

    if knot_ahead['x'] == current_knot['x'] then
        current_knot['y'] = current_knot['y'] + 1 * y_direction
        return current_knot
    end

    if knot_ahead['y'] == current_knot['y'] then
        current_knot['x'] = current_knot['x'] + 1 * x_direction
        return current_knot
    end

    current_knot['x'] = current_knot['x'] + 1 * x_direction
    current_knot['y'] = current_knot['y'] + 1 * y_direction

    return current_knot
end

local visited_tail_locations = {['0,0'] = 1}

local function move_rope(direction, moves, rope, num_knots)
    for _ = 1, moves, 1 do
        for knot = num_knots, 1, -1 do
            local current_knot = rope[knot]

            if knot == num_knots then
                local new_head = move_head(direction, current_knot)
                rope[knot] = new_head
            else
                current_knot = move_tail(current_knot, rope[knot+1])
                rope[knot] = current_knot
            end

            if knot == 1 then
                local index = ''..current_knot['x']..','..current_knot['y']
                visited_tail_locations[index] = 1
            end
        end
    end

    return rope
end

local function perform_instructions(instructions, rope, num_knots)
    for _, instruction in pairs(instructions) do
        local direction = string.sub(instruction, 1, 1)
        local moves = tonumber(string.gmatch(instruction, '%d+')())
        rope = move_rope(direction, moves, rope, num_knots)
    end
end

local knots = 10

local rope = {}
for i = 1, knots, 1 do
    rope[i] = {['x'] = 0, ['y'] = 0}
end

local instructions = util.split_lines(util.read_file('input.txt'))
perform_instructions(instructions, rope, knots)

local num_locations = #util.rebuild_table_index(visited_tail_locations)
print(num_locations)
