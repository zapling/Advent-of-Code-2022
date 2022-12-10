#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")


local function process_cpu_instructions(instructions, debug)
    local x = 1
    local cpu_cycle = 1
    local crt_draw_pos = 1
    local instruction_id = 1

    local queued_work = nil
    local work_done_at_cycle = nil

    local crt = {}
    local row = ""

    local should_draw_pixel = function()
        local sprite_middle = x + 1
        if crt_draw_pos == sprite_middle or crt_draw_pos == sprite_middle -1 or crt_draw_pos == sprite_middle + 1 then
            return true
        end

        return false
    end

    while true do
        if cpu_cycle == 41 or cpu_cycle == 81 or cpu_cycle == 121 or cpu_cycle == 161 or cpu_cycle == 201 or cpu_cycle == 241 then
            table.insert(crt, row)
            row = ""
            crt_draw_pos = 1
        end

        if cpu_cycle == 241 then
            return crt
        end

        if queued_work == nil then
            local instruction = instructions[instruction_id]
            if instruction ~= nil then
                if instruction ~= "noop" then
                    local value = tonumber(string.gmatch(instruction, '-*%d+')())
                    local cycle = cpu_cycle + 1

                    queued_work = value
                    work_done_at_cycle = cycle

                else
                    instruction_id = instruction_id + 1
                end
            end
        end

        if should_draw_pixel() == true then
            row = row .. '#'
        else
            row = row .. '.'
        end

        if queued_work ~= nil then
            if work_done_at_cycle == cpu_cycle then
                x = x + queued_work
                queued_work = nil
                work_done_at_cycle = nil
                instruction_id = instruction_id + 1
            end
        end

        cpu_cycle = cpu_cycle + 1
        crt_draw_pos = crt_draw_pos + 1
    end
end

local instructions = util.split_lines(util.read_file('input.txt'))
local crt = process_cpu_instructions(instructions, false)

print(crt[1])
print(crt[2])
print(crt[3])
print(crt[4])
print(crt[5])
print(crt[6])
