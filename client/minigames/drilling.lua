local p = nil
local active, drillScaleform
local speed, position, temp, depth = 0.0, 0.0, 0.0, 0.1
local disabledKeys = {30, 31, 32, 33, 34, 35}
local dataSets = {
    ['DRILLING'] = {
        {action = 'float', args = {"SET_SPEED", 0.0}},
        {action = 'float', args = {"SET_DRILL_POSITION", 0.0}},
        {action = 'float', args = {"SET_TEMPERATURE", 0.0}},
        {action = 'float', args = {"SET_HOLE_DEPTH", 0.0}}
    },
    ['VAULT_DRILL'] = {
        {action = 'movie', args = {"REVEAL"}},
        {action = 'float', args = {"SET_SPEED", 0.0}},
        {action = 'float', args = {"SET_DRILL_POSITION", 0.0}},
        {action = 'float', args = {"SET_TEMPERATURE", 0.0}},
        {action = 'float', args = {"SET_HOLE_DEPTH", 0.0}},
        {action = 'int', args = {"SET_NUM_DISCS", 3}}
    },
    ["VAULT_LASER"] = {
        {action = 'movie', args = {"REVEAL"}},
        {action = 'float', args = {"SET_LASER_WIDTH", 0.0}},
        {action = 'float', args = {"SET_DRILL_POSITION", 0.0}},
        {action = 'float', args = {"SET_TEMPERATURE", 0.0}},
        {action = 'float', args = {"SET_HOLE_DEPTH", 0.0}},
        {action = 'int', args = {"SET_NUM_DISCS", 3}}
    }
}
local controls = {
    {key = 172, action = function() position = math.min(1.0,position + 0.01) end},
    {key = 172, action = function() position = math.min(1.0,position + (0.1 * GetFrameTime() / (math.max(0.1, temp) * 10))) end},
    {key = 173, action = function() position = math.min(1.0,position - 0.01) end},
    {key = 173, action = function() position = math.min(1.0,position - (0.1 * GetFrameTime())) end},
    {key = 175, action = function() speed = math.min(1.0,speed + 0.05) end},
    {key = 175, action = function() speed = math.min(1.0,speed + (0.5 * GetFrameTime())) end},
    {key = 174, action = function() speed = math.min(1.0,speed - 0.05) end},
    {key = 174, action = function() speed = math.min(1.0,speed - (0.5 * GetFrameTime())) end}
}
local buttons = {
    {type = "CLEAR_ALL"},
    {type = "SET_CLEAR_SPACE", int = 600},
    {type = "SET_DATA_SLOT", name = Lang:t('info.reduce_pressure'), keyIndex = {[173] = {}}, int = 0},
    {type = "SET_DATA_SLOT", name = Lang:t('info.add_pressure'), keyIndex = {[172] = {}}, int = 1},
    {type = "SET_DATA_SLOT", name = Lang:t('info.add_speed'), keyIndex = {[175] = {}}, int = 2},
    {type = "SET_DATA_SLOT", name = Lang:t('info.reduce_speed'), keyIndex = {[174] = {}}, int = 3},
    {type = "DRAW_INSTRUCTIONAL_BUTTONS"},
    {type = "SET_BACKGROUND_COLOUR"}
}

local function resetData()
    drillScaleform = nil
    speed, position, temp, depth = 0.0, 0.0, 0.0, 0.1
end

local function init(_type, discs)
    if drillScaleform then k_lib.UnloadScaleform(drillScaleform) end
    resetData()
    drillScaleform = k_lib.LoadScaleform(_type)
    for index, value in ipairs(dataSets[_type]) do
        if value.args[1] == "SET_NUM_DISCS" then value.args[2] = discs end
        if value.action == 'float' then k_lib.IntScreen(drillScaleform, table.unpack(value.args)) end
        if value.action == 'int' then k_lib.IntScreen(drillScaleform, table.unpack(value.args)) end
        if value.action == 'movie' then k_lib.StartScaleformMovie(drillScaleform, table.unpack(value.args)) end
    end
end

local function keypressHandler()
    if not p then return end
    local form = k_lib.SetupScaleform("instructional_buttons", buttons)
    while active do
        DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
        DrawScaleformMovieFullscreen(drillScaleform, 255, 255, 255, 255, 255)
        for _,control in ipairs(disabledKeys) do DisableControlAction(0, control, true) end
        local last_pos = position
        local last_speed = speed
        local last_temp = temp

        for i, value in ipairs(controls) do
            if i % 2 == 0 then
                if IsControlPressed(0, value.key) then value.action() end
            else
                if IsControlJustPressed(0, value.key) then value.action() end
            end
        end

        if last_speed ~= speed then k_lib.FloatScreen(drillScaleform, "SET_SPEED", speed) end

        if position > depth then
            if speed > 0.1 then
                temp = math.min(1.0, temp + ((1.0 * GetFrameTime()) * speed))
                depth = position
            else
                position = depth
            end
        else
            temp = math.max(0.0, temp - (1.0 * GetFrameTime()))
        end

        if position ~= last_pos then k_lib.FloatScreen(drillScaleform, "SET_DRILL_POSITION",position) end
        if last_temp ~= temp then k_lib.FloatScreen(drillScaleform, "SET_TEMPERATURE",temp) end

        if temp >= 1.0 then
            p:resolve(false)
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            PlaySoundFromCoord(-1, "Drill_Pin_Break", x, y, z, "DLC_HEIST_FLEECA_SOUNDSET", true, 5, false)
        elseif position >= 1.0 then
            p:resolve(true)
        end
        Wait(0)
    end
end

---@param drillType string "DRILLING", "VAULT_DRILL", or "VAULT_LASER"
---@param discs integer number of discs to drill through (does nothing for "DRILLING")
function k_lib.Drilling(drillType, discs)
    if active then return false end
    p = promise.new()
    active = true
    init(drillType, discs)
    CreateThread(keypressHandler)
    local result = Citizen.Await(p)
    active = false
    resetData()
    return result
end
exports('Drilling', k_lib.Drilling)

RegisterCommand('testdrilling', function()
    local retval = k_lib.Drilling('DRILLING', 5)
    print(retval)
end)