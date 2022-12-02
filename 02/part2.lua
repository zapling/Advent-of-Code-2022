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

local elf_moves_to_my_move = {["A"] = "X", ["B"] = "Y", ["C"] = "Z"}
local my_moves_to_elf = {["X"] = "A", ["Y"] = "B", ["Z"] = "C"}

local winnable_elf_moves = {
    ["AZ"] = 1, -- Rock vs Scissors
    ["CY"] = 1, -- Scissors vs Paper
    ["BX"] = 1, -- Paper vs Rock
}

local winnable_me_moves = {
    ["XC"] = 1,-- Rock vs Scissors
    ["ZB"] = 1,-- Scissors vs Paper
    ["YA"] = 1,-- Paper vs Rock
}

local function get_move_based_by_outcome(elf_move, play_outcome)
    -- I should tie
    if play_outcome == "Y" then
        return elf_moves_to_my_move[elf_move]
    end

    -- I should lose :(
    if play_outcome == "X" then
        for k, _ in pairs(winnable_elf_moves) do
            if string.sub(k, 1, 1) == elf_move then
                return string.sub(k, 2, 2)
            end
        end

        print("We should not be here!")
        os.exit(1)
    end

    -- I should win :)
    for k, _ in pairs(winnable_me_moves) do
        if string.sub(k, 2, 2) == elf_move then
            return string.sub(k, 1, 1)
        end
    end

    print("We should not be here")
    os.exit(1)
end

local function shape_to_score(shape)
    local shapes = {
        ["X"] = 1,
        ["Y"] = 2,
        ["Z"] = 3,
    }

    return shapes[shape]
end

local function play(elf_move, play_outcome)
    local my_move = get_move_based_by_outcome(elf_move, play_outcome)

    if elf_move == my_moves_to_elf[my_move] then
        return shape_to_score(my_move) + 3
    end

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
    local play_outcome = string.sub(line, 3, 3)

    local outcome = play(elf_play, play_outcome)
    our_score = our_score + outcome
end

print(our_score)
