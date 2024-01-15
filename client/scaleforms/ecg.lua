local health = 100
local rate = 60
local open = false
local custom = true

function k_lib.DisplayECG(startingHealth, heartRate, customColor)
    if open then return end
    open = true
    if not customColor or not next(customColor) then custom = false end
    local scaleform = k_lib.LoadScaleform("ECG_MONITOR")
    rate = heartRate
    health = startingHealth
    local sleep = math.floor(1000 / (rate / 60))
    CreateThread(function()
        while open do
            if not custom then
                for _, v in ipairs(Config.ColorLayout) do
                    if health < v.health then customColor = v.color break end
                end
            end
            sleep = math.floor(1000 / (rate / 60))
            k_lib.IntScreen(scaleform, 'SET_COLOUR', customColor)
            k_lib.IntScreen(scaleform, 'SET_HEART_RATE', {rate})
            k_lib.IntScreen(scaleform, 'SET_HEALTH', {health})
            Wait(sleep)
        end
    end)
    while open do
        DrawScaleformMovie(scaleform, 0.8, 0.6, 0.2, 0.2, 255, 255, 255, 255, 255)
        Wait(0)
    end
end

function k_lib.AdjustValues(newHealth, heartRate)
    if newHealth then health = newHealth end
    if heartRate then heartRate = heartRate end
end

function k_lib.CloseECG()
    open = false
    custom = true
end