#!/usr/bin/env luajit

function get_cursor_position()
    local handle =  io.popen("hyprctl cursorpos", "r")
    local output
    if handle ~= nil then
        output = handle:read()
        handle:close()
    else
        os.exit(69)
    end

    local idx = 1
    local ret = {}
    for substr in string.gmatch(output, "[%d]+") do
        ret[idx] = substr
        idx = idx + 1
    end
    return tonumber(ret[1]), tonumber(ret[2])
end

pos_x, pos_y = get_cursor_position()
window_width = 250

actions = {}
stdin = ""

for action_str in string.gmatch(io.read("*a"), "[^\n]+") do
    local pretty_action_str = string.sub(action_str:match("%b#("), 2, -3)
    actions[pretty_action_str] = action_str
    stdin = stdin .. pretty_action_str .. "\n"
end

handle = io.popen(
    string.format(
        " echo -e \"%s\" | rofi -i -dmenu -location 1 -theme-str 'window { width: %d; x-offset: %d; y-offset: %d; }'",
        stdin:sub(1, -2), window_width, pos_x - window_width, pos_y
    ),
    "r"
)
if handle ~= nil then
    print(actions[handle:read()])
else
    os.exit(42)
end
