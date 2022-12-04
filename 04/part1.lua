local function read_file(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function split_lines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    local lines={}
    for line in s:gmatch("(.-)\n") do table.insert(lines, line) end
    return lines
end


local function get_sequence(x, y)
    local sequence = ""
    for i = x, y, 1 do
        if i < 10 then
            i = 0 .. i
        end
        sequence = sequence .. ' ' .. i
    end
    return sequence
end

local num_overlaps = 0
for _, line in pairs(split_lines(read_file("input.txt"))) do
    local ranges = {}

    for section in line:gmatch('([^,]+)') do
        local nums = {}
        for num in section:gmatch('%d+') do
            table.insert(nums, num)
        end
        table.insert(ranges, get_sequence(nums[1],nums[2]))
    end

    if string.find(ranges[1], ranges[2]) or string.find(ranges[2], ranges[1]) then
        num_overlaps = num_overlaps + 1
    end
end

print(num_overlaps)
