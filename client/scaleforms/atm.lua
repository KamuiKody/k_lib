-- for future use

local scaleform = nil
local active = false
local p = nil
local withdrawAmount, bankBalance = 0, 0

local function init(accountName, balance, amountTable)
    bankBalance = balance or 0
    scaleform = k_lib.LoadScaleform("ATM")
    k_lib.StartScaleformMovie(scaleform, "DISPLAY_MENU")
    PushScaleformMovieFunction(scaleform, "DISPLAY_BALANCE")
    PushScaleformMovieFunctionParameterString(accountName)
    PushScaleformMovieFunctionParameterString('Withdraw                                 Balace:')
    PushScaleformMovieFunctionParameterInt(balance)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT_EMPTY")
    for i = 0, #amountTable + 2 do
        local label = ''
        local index = i
        if i > 4 then index -= 1 end
        if i == 4 then label = 'Back' end
        if i == 8 then label = 'Confirm' end
        if i ~= 0 and i ~= 4 and i ~= 8 then label = amountTable[index].label end
        k_lib.AddDataSlot(scaleform, i, label)
    end
    k_lib.StartScaleformMovie(scaleform, "DISPLAY_CASH_OPTIONS")
    k_lib.StartScaleformMovie(scaleform, "SET_INPUT_SELECT")
    while active do
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 255)
        SetMouseCursorActiveThisFrame()
        k_lib.FloatScreen(scaleform, "SET_MOUSE_INPUT", {GetControlNormal(0, 239), GetControlNormal(0, 240)})
        Wait(0)
    end
end
-- SetPlayerControl(PlayerId(), true, 0)

function k_lib.OpenATM(accountName, balance, amountTable)
    if not amountTable or not next(amountTable) then amountTable = Config.WithdrawAmounts end
    active = true
    p = promise.new()    
    init(accountName, balance, amountTable)
    -- CreateThread(keypressHandler)
    local result = Citizen.Await(p)
    active = false
    -- resetData()
    return result
end

RegisterCommand('atm', function()
    local result = k_lib.OpenATM('Jett Young', 100000, nil)
    print(result)
end)

