#!/usr/bin/luajit
package.path = package.path .. ';../?.lua;'
local util = require("util")


local function process_cpu_instructions(instructions)
    local x = 1
    local cpu_cycle = 1
    local instruction_id = 1

    local queued_work = nil
    local work_done_at_cycle = nil

    local signal_strength = {}
    while true do

        print('(' .. cpu_cycle .. ') Starting cycle, x = ' .. x)

        if cpu_cycle == 20 or cpu_cycle == 60 or cpu_cycle == 100 or
            cpu_cycle == 140 or cpu_cycle == 180 or cpu_cycle == 220 then
            signal_strength[cpu_cycle] = cpu_cycle * x
        end

        if cpu_cycle == 220 then
            print('220 cpu cycles, hard limit breaking')
            return signal_strength
        end

        if queued_work == nil then
            local instruction = instructions[instruction_id]
            if instruction ~= nil then
                if instruction ~= "noop" then
                    local value = tonumber(string.gmatch(instruction, '-*%d+')())
                    local cycle = cpu_cycle + 1

                    queued_work = value
                    work_done_at_cycle = cycle

                    print('(' .. cpu_cycle .. ') Queued "' .. instruction .. '" for cycle ' .. cycle)
                else
                    print('(' .. cpu_cycle .. ') -> noop')
                    instruction_id = instruction_id + 1
                end
            else
                print('(' .. cpu_cycle .. ') No new CPU instruction')
            end
        end

        if queued_work ~= nil then
            if work_done_at_cycle == cpu_cycle then
                x = x + queued_work
                print('(' .. cpu_cycle .. ') -> "addx ' .. queued_work .. '"')

                queued_work = nil
                work_done_at_cycle = nil
                instruction_id = instruction_id + 1
            else
                print('(' .. cpu_cycle .. ') No completed work')
            end
        end

        cpu_cycle = cpu_cycle + 1
    end
end

local instructions = util.split_lines(util.read_file('input.txt'))
local signal_strength = process_cpu_instructions(instructions)

print(util.dump(signal_strength))

local sum = signal_strength[20] + signal_strength[60] + signal_strength[100] + signal_strength[140] + signal_strength[180] + signal_strength[220]
print(sum)
