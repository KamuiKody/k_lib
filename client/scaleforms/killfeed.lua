-- for future use

local scaleform = nil

local function Initialize(scaleform, killer, weapon, killed, color)
    PushScaleformMovieFunction(scaleform, "ADD_MESSAGE")
    PushScaleformMovieFunctionParameterString(killer)
    PushScaleformMovieFunctionParameterString(killed)
    PushScaleformMovieFunctionParameterString(weapon)
    PushScaleformMovieFunctionParameterBool(false)
    PushScaleformMovieFunctionParameterInt(color or 9)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "ABORT_TEXT")
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function k_lib.KillFeed(killer, weapon, killed, color, duration)
    scaleform = k_lib.LoadScaleform("MULTIPLAYER_CHAT")
    Initialize(scaleform, killer, weapon, killed, color)
    if not duration then duration = 5000 end
    while duration > 0 do
        Wait(1)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        duration -= 1
    end
    k_lib.UnloadScaleform(scaleform)
end

RegisterCommand('killfeed', function()
    k_lib.KillFeed('Jett Young', 'Assualt Rifle', 'Tony Klappah', 6, 10000)
end)