local function read_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function split_lines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

local function shape_to_score(shape)
    local shapes = {
        ["X"] = 1,
        ["Y"] = 2,
        ["Z"] = 3,
    }

    return shapes[shape]
end

local function play(elf_move, my_move)
    local my_moves_to_elf_moves = {["X"] = "A", ["Y"] = "B", ["Z"] = "C"}
    if elf_move == my_moves_to_elf_moves[my_move] then
        return shape_to_score(my_move) + 3
    end

    local winnable_elf_moves = {
        ["AZ"] = 1, -- Rock vs Scissors
        ["CY"] = 1, -- Scissors vs Paper
        ["BX"] = 1, -- Paper vs Rock
    }

    local elf_won = winnable_elf_moves[elf_move .. my_move]
    if not elf_won then
        return shape_to_score(my_move) + 6
    end

    return shape_to_score(my_move)
end

local content = read_file("input.txt")
local lines = split_lines(content)

local our_score = 0

for line in lines do
    local elf_play = string.sub(line, 1, 1)
    local our_play = string.sub(line, 3, 3)
    local outcome = play(elf_play, our_play)
    our_score = our_score + outcome
end

print(our_score)
