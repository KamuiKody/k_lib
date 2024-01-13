local p = nil
local scaleform, ClickReturn, password, form = nil, nil, nil, nil
local ipHack, failed, hackConnect, bruteForce, finished, display = false, false, false, false, false, false
local max_lives = Config.MaxLives
local current_lives, ipSpeed = 0, 0
local current_timer, speeds = {}, {}
local outcomes = {
    ['HACKCONNECT'] = "SET_IP_OUTCOME",
    ['BRUTEFORCE'] = "SET_ROULETTE_OUTCOME"
}
local clickOptions = {
    [24] = function()
        if failed then return end
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
        ClickReturn = PopScaleformMovieFunction()
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    end,
    [25] = function()
        if failed then return end
        k_lib.StartScaleformMovie(scaleform, "SET_INPUT_EVENT_BACK")
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    end
}
local ipButtons = {
    {type = "CLEAR_ALL"},
    {type = "SET_CLEAR_SPACE", int = 600},
    {type = "SET_DATA_SLOT", name = Lang:t('info.up'), keyIndex = {[172] = {}}, int = 1},
    {type = "SET_DATA_SLOT", name = Lang:t('info.down'), keyIndex = {[173] = {}}, int = 0},
    {type = "SET_DATA_SLOT", name = Lang:t('info.left'), keyIndex = {[175] = {}}, int = 2},
    {type = "SET_DATA_SLOT", name = Lang:t('info.right'), keyIndex = {[174] = {}}, int = 3},
    {type = "SET_DATA_SLOT", name = Lang:t('info.select'), keyIndex = {[24] = {}}, int = 4},
    {type = "DRAW_INSTRUCTIONAL_BUTTONS"},
    {type = "SET_BACKGROUND_COLOUR"}
}
local buttons = {
    {type = "CLEAR_ALL"},
    {type = "SET_CLEAR_SPACE", int = 600},
    {type = "SET_DATA_SLOT", name = Lang:t('info.left'), keyIndex = {[175] = {}}, int = 0},
    {type = "SET_DATA_SLOT", name = Lang:t('info.right'), keyIndex = {[174] = {}}, int = 1},
    {type = "SET_DATA_SLOT", name = Lang:t('info.select'), keyIndex = {[24] = {}}, int = 2},
    {type = "DRAW_INSTRUCTIONAL_BUTTONS"},
    {type = "SET_BACKGROUND_COLOUR"}
}

local function disableControls(bool)
    DisableControlAction(0, 24, bool)
    DisableControlAction(0, 25, bool)
    DisableControlAction(0, 1, bool) -- LookLeftRight
    DisableControlAction(0, 2, bool) -- LookUpDown
    DisableControlAction(0, 106, bool) -- VehicleMouseControlOverride
    DisableControlAction(0, 30, bool) -- disable left/right
    DisableControlAction(0, 31, bool) -- disable forward/back
    DisableControlAction(0, 36, bool) -- INPUT_DUCK
    DisableControlAction(0, 21, bool) -- disable sprint
    DisableControlAction(0, 63, bool) -- veh turn left
    DisableControlAction(0, 64, bool) -- veh turn right
    DisableControlAction(0, 71, bool) -- veh forward
    DisableControlAction(0, 72, bool) -- veh backwards
    DisableControlAction(0, 75, bool) -- disable exit vehicle
    DisablePlayerFiring(PlayerId(), bool) -- Disable weapon firing
    DisableControlAction(0, 24, bool) -- disable attack
    DisableControlAction(0, 25, bool) -- disable aim
    DisableControlAction(1, 37, bool) -- disable weapon select
    DisableControlAction(0, 47, bool) -- disable weapon
    DisableControlAction(0, 58, bool) -- disable weapon
    DisableControlAction(0, 140, bool) -- disable melee
    DisableControlAction(0, 141, bool) -- disable melee
    DisableControlAction(0, 142, bool) -- disable melee
    DisableControlAction(0, 143, bool) -- disable melee
    DisableControlAction(0, 263, bool) -- disable melee
    DisableControlAction(0, 264, bool) -- disable melee
    DisableControlAction(0, 257, bool) -- disable melee
end

local function closeScaleform(bool)
    p:resolve(bool)
    k_lib.UnloadScaleform(scaleform)
    scaleform = nil
    FreezeEntityPosition(PlayerPedId(), false)
    disableControls(false)
    p = nil
    ClickReturn, password, form = nil, nil, nil
    ipHack, failed, hackConnect, bruteForce, display = false, false, false, false, false
    max_lives = Config.MaxLives
    current_lives, ipSpeed = 0, 0
    current_timer, speeds = {}, {}
end

local function updateDisplay(totalTime)
    local remainingTime = math.max(totalTime, 0)
    local remainingMinutes = math.floor(remainingTime / 60000)
    local remainingSeconds = math.floor((remainingTime % 60000) / 1000)
    local remainingMilliseconds = remainingTime % 1000
    k_lib.IntScreen(scaleform, "SET_COUNTDOWN", {remainingMinutes, remainingSeconds, remainingMilliseconds})
end

local function failure(app)
    display = false
    failed = true
    PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
    k_lib.BoolToString(scaleform, outcomes[app], false, app..Lang:t('error.failed'))
    Wait(2000)
    k_lib.StartScaleformMovie(scaleform, "CLOSE_APP")
    k_lib.BoolToString(scaleform, "OPEN_ERROR_POPUP", true, Lang:t('error.breach'))
    Wait(2500)
    closeScaleform(false)
end

local function success(app)
    display = false
    finished = true
    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
    k_lib.BoolToString(scaleform, outcomes[app], true, app..Lang:t('success.success'))
    Wait(2800) 
    k_lib.StartScaleformMovie(scaleform, "CLOSE_APP")
    if app == 'HACKCONNECT' then
        hackConnect = true
    else 
        bruteForce = true
    end
    if hackConnect and bruteForce then k_lib.BoolScreen(scaleform, "OPEN_DOWNLOAD", true) end
end

local function badClick(app)
    current_lives = current_lives - 1
    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
    k_lib.IntScreen(scaleform, "SET_LIVES", {current_lives, max_lives})
    k_lib.BoolScreen(scaleform, "SHOW_LIVES", true)
    if current_lives > 0 then return end
    finished = true
    failure(app)
end

local function checkApp(app)
    local msg = ''
    if hackConnect and bruteForce then
        msg = Lang:t('labels.down_n_out')
    else
        if app == 'HACKCONNECT' and hackConnect then
            msg = Lang:t('labels.bruteforce')
        elseif app == 'BRUTEFORCE' and bruteForce then
            msg = Lang:t('labels.hackconnect')
        else
            return true
        end
    end
    msg = Lang:t('error.other_app', {appLabel = msg})
    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
    k_lib.BoolToString(scaleform, "OPEN_ERROR_POPUP", true, msg)
    Wait(2000)
    k_lib.BoolToString(scaleform, "OPEN_ERROR_POPUP", false, msg)
    return false
end

local function countDown(m, s, ms)
    CreateThread(function()
        local totalTime = (m or 0) * 60000 + (s or 0) * 1000 + (ms or 0)
        while totalTime > 0 do
            if finished then break end
            totalTime = totalTime - 5
            updateDisplay(totalTime)
            Wait(0)
        end
        if totalTime <= 0 and not finished then failure(ipHack and 'HACKCONNECT' or 'BRUTEFORCE') end
    end)
end

local function startProgram(id)
    display = true
    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
    current_lives = max_lives
    k_lib.FloatScreen(scaleform, "RUN_PROGRAM", id)
    if id == 83.0 then
        k_lib.AddString(scaleform, "SET_ROULETTE_WORD", password)
    else
        ipHack = true
        k_lib.IntScreen(scaleform, "SET_SPEED", ipSpeed)
        local time = Config.DefaultTimer
        if current_timer and next(current_timer) then time = current_timer end
        countDown(table.unpack(time))
    end
    k_lib.IntScreen(scaleform, "SET_LIVES", {current_lives, max_lives})
    k_lib.BoolScreen(scaleform, "SHOW_LIVES", true)
end

local programIds = {
    [6] = { action = function()
        closeScaleform(false)
    end},
    [82] = { action = function() -- open hackconnect.exe
        if not checkApp("HACKCONNECT") then return end
        form = k_lib.SetupScaleform("instructional_buttons", ipButtons)
        startProgram(82.0)
    end},
    [83] = { action = function()-- open bruteforce.exe
        if not checkApp("BRUTEFORCE") then return end
        form = k_lib.SetupScaleform("instructional_buttons", buttons)
        startProgram(83.0)
    end},
    [84] = {action = function()
        success("HACKCONNECT")
    end},
    [85] = {action = function()
        badClick("HACKCONNECT")
    end},
    [86] = { action = function()
        success("BRUTEFORCE")
    end},
    [87] = { action = function() -- incorrect letter
        k_lib.AddString(scaleform, "SET_ROULETTE_WORD", password)
        k_lib.StartScaleformMovie(scaleform, "RESET_ROULETTE")
        badClick("BRUTEFORCE")
    end},
    [92] = { action = function() -- correct letter
        PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
    end},
    [93] = { action = function()
        PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
        k_lib.BoolScreen(scaleform, "OPEN_LOADING_PROGRESS", true)
        local index = 0
        while index < 100 do
            local time = 100 - index
            k_lib.IntScreen(scaleform, "SET_LOADING_PROGRESS", index)
            k_lib.IntScreen(scaleform, "SET_LOADING_TIME", time)
            if index == 35 then k_lib.StringToFloat(scaleform, "SET_LOADING_MESSAGE", Lang:t('labels.load_one'),2.0) end
            if index == 75 then k_lib.StringToFloat(scaleform, "SET_LOADING_MESSAGE", Lang:t('labels.load_two'), 2.0) end
            Wait(150)
        end
        k_lib.BoolScreen(scaleform, "OPEN_LOADING_PROGRESS", false)
        k_lib.BoolToString(scaleform, "OPEN_ERROR_POPUP", true, Lang:t('success.secured'))
        Wait(3500)
        closeScaleform(true)
    end},
}
local ipControls = {
    [172] = function()
        if not ipHack then return end
        k_lib.FloatScreen(scaleform, "MOVE_CURSOR", {0.0, -1.0})
    end,
    [173] = function()
        if not ipHack then return end
        k_lib.FloatScreen(scaleform, "MOVE_CURSOR", {0.0, 1.0})
    end,
    [174] = function()
        k_lib.FloatScreen(scaleform, "MOVE_CURSOR", {-1.0, 0.0})
    end,
    [175] = function()
        k_lib.FloatScreen(scaleform, "MOVE_CURSOR", {1.0, 0.0})
    end,
    [200] = function() -- escape
        finished = true
        closeScaleform(false)
    end
}

local function keypressListener()
    form = k_lib.SetupScaleform("instructional_buttons", buttons)
    local control = false
    while scaleform do
        if display then DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0) end
        Wait(0)
        disableControls(true)
        for key, action in pairs(ipControls) do
            if IsControlPressed(0, key) then
                CreateThread(function()
                    if control then return end
                    control = true
                    action()
                    Wait(25)
                    control = false
                end)
            end
        end
        if GetScaleformMovieFunctionReturnBool(ClickReturn) and not failed then
            local ProgramID = GetScaleformMovieFunctionReturnInt(ClickReturn)
            if programIds[ProgramID] and not failed then programIds[ProgramID].action() end
        end
    end
end

local function Initialize(name, background, code, lives)
    local scaleform = k_lib.LoadScaleform(name)
    failed, finished = false, false
    max_lives = lives or Config.MaxLives
    password = code
    if not password or string.len(password) ~= 8 then password = Config.HackCodes[math.random(1,#Config.HackCodes)] end
    k_lib.AddString(scaleform, "SET_LABELS", {Lang:t('labels.local_drive'), Lang:t('labels.network'), Lang:t('labels.usb_device'), Lang:t('labels.hackconnect'), Lang:t('labels.bruteforce'), Lang:t('labels.down_n_out')})
    k_lib.IntScreen(scaleform, "SET_BACKGROUND", background)
    local df2s = {{1.0, 4.0, Lang:t('labels.my_computer')}, {6.0, 6.0, Lang:t('labels.power')}}
    for i = 1, 8 do
        if i < 3 then k_lib.DualFloatToString(scaleform, "ADD_PROGRAM", table.unpack(df2s[i])) end
        local speed = math.random(table.unpack(Config.LetterRoulletteSpeeds[i]))
        if speeds[i] then speed = math.random(table.unpack(speeds[i])) end
        k_lib.IntScreen(scaleform, "SET_COLUMN_SPEED", {i-1, speed})
    end
    return scaleform
end

--- @param background integer The background setting for the hacking interface.
--- @param password string The password for the hacking activity (8 characters).
--- @param speedTable table A table containing 8 sub-tables, each with 'max' and 'min' values. ({min, max})
--- @param duration table A table containing 'minutes', 'seconds', and 'milliseconds'. ({0, 10, 150})
--- @param lives integer The number of lives for the hacking activity.
--- @param speed integer Controls the speed of the IP hack.
--- @param hackConnect_bypass boolean Set to true to only perform a brute force hack (letter roulette).
--- @param bruteForce_bypass boolean Set to true to only perform a hack connect hack (IP hack).
---
--- @return result boolean result of the hacking activity.
--
function k_lib.HackingLaptop(background, password, speedTable, duration, lives, speed, hackConnect_bypass, bruteForce_bypass)
    p = promise.new()
    current_timer = duration
    ipSpeed = speed or Config.DefaultIpSpeed
    speeds = next(speedTable) and speedTable or Config.LetterRoulletteSpeeds
    hackConnect, bruteForce = hackConnect_bypass, bruteForce_bypass
    CreateThread(function()
        scaleform = Initialize("HACKING_PC", background or 6, password, lives)
        CreateThread(keypressListener)
        while p do
            Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            k_lib.FloatScreen(scaleform, "SET_CURSOR", {GetControlNormal(0, 239), GetControlNormal(0, 240)}) --We use this scaleform function to define what input is going to move the cursor
            for key, action in pairs(clickOptions) do
                if IsDisabledControlJustPressed(0,key) then action() end
            end
        end
    end)
    local result = Citizen.Await(p)
    p = nil
    return result
end
exports('HackingLaptop', k_lib.HackingLaptop)

RegisterCommand('testhack', function()
    local result = k_lib.HackingLaptop(4, nil, Config.LetterRoulletteSpeeds, {0,15,0}, 7, 60, false, false)
    print(result)
end)
