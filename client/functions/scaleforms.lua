function k_lib.LoadScaleform(name)
    local movie = RequestScaleformMovie(name)
    while not HasScaleformMovieLoaded(movie) do Wait(0) end
    return movie
end

function k_lib.UnloadScaleform(movie)
    SetScaleformMovieAsNoLongerNeeded(movie)
end

function k_lib.AddString(scaleform, name, stringList)
    PushScaleformMovieFunction(scaleform, name)
    if type(stringList) == 'table' then
        for _, label in ipairs(stringList) do PushScaleformMovieFunctionParameterString(label) end
    else
        PushScaleformMovieFunctionParameterString(stringList)
    end
    PopScaleformMovieFunctionVoid()
end

function k_lib.DualFloatToString(scaleform, name, float_1, float_2, string)
    PushScaleformMovieFunction(scaleform, name)
    PushScaleformMovieFunctionParameterFloat(float_1)
    PushScaleformMovieFunctionParameterFloat(float_2)
    PushScaleformMovieFunctionParameterString(string)
    PopScaleformMovieFunctionVoid()
end

function k_lib.BoolToString(scaleform, name, bool, string)
    PushScaleformMovieFunction(scaleform, name)
    PushScaleformMovieFunctionParameterBool(bool)
    PushScaleformMovieFunctionParameterString(string)
    PopScaleformMovieFunctionVoid()
end

function k_lib.StringToFloat(scaleform, name, string, float)
    PushScaleformMovieFunction(scaleform, name)
    PushScaleformMovieFunctionParameterString(string)
    PushScaleformMovieFunctionParameterFloat(float)
    PopScaleformMovieFunctionVoid()
end

function k_lib.AddDataSlot(scaleform, int, str)
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(int)
    PushScaleformMovieFunctionParameterString(str)
    PopScaleformMovieFunctionVoid()
end

function k_lib.FloatScreen(scaleform, name, float)
    PushScaleformMovieFunction(scaleform, name)
    if type(float) == 'table' then
        for _, label in ipairs(float) do PushScaleformMovieFunctionParameterFloat(label) end
    else
        PushScaleformMovieFunctionParameterFloat(float)
    end
    PopScaleformMovieFunctionVoid()
end

function k_lib.IntScreen(scaleform, name, int)
    PushScaleformMovieFunction(scaleform, name)
    if type(int) == 'table' then
        for _, label in ipairs(int) do PushScaleformMovieFunctionParameterInt(label) end
    else
        PushScaleformMovieFunctionParameterInt(int)
    end
    PopScaleformMovieFunctionVoid()
end

function k_lib.BoolScreen(scaleform, name, bool)
    PushScaleformMovieFunction(scaleform, name)
    if type(bool) == 'table' then
        for _, label in ipairs(bool) do PushScaleformMovieFunctionParameterBool(label) end
    else
        PushScaleformMovieFunctionParameterBool(bool)
    end
    PopScaleformMovieFunctionVoid()
end

function k_lib.StartScaleformMovie(scaleform, name)
    PushScaleformMovieFunction(scaleform, name)
    return PopScaleformMovieFunctionVoid()
end

function k_lib.GetReturnScaleformValueInt(scaleform, name)
    BeginScaleformMovieMethod(scaleform, name)
    local returnValue = EndScaleformMovieMethodReturnValue()
    while not IsScaleformMovieMethodReturnValueReady(returnValue) do
        Wait(0)
    end
    return GetScaleformMovieMethodReturnValueInt(returnValue)
end

function k_lib.SetupScaleform(scaleform, Buttons)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do Wait(0) end
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)
    for i = 1,#Buttons do
        PushScaleformMovieFunction(scaleform, Buttons[i].type)
        if Buttons[i].int then PushScaleformMovieFunctionParameterInt(Buttons[i].int) end
        if Buttons[i].keyIndex then
            if type(Buttons[i].keyIndex) == "table" then
                for k, v in pairs(Buttons[i].keyIndex) do N_0xe83a3e3557a56640(GetControlInstructionalButton(2, k, true)) end
            else
                N_0xe83a3e3557a56640(GetControlInstructionalButton(2, Buttons[i].keyIndex[1], true))
            end
        end
        if Buttons[i].name then
            BeginTextCommandScaleformString("STRING")
            AddTextComponentScaleform(Buttons[i].name)
            EndTextCommandScaleformString()
        end
        if Buttons[i].type == 'SET_BACKGROUND_COLOUR' then
            for u = 1,4 do PushScaleformMovieFunctionParameterInt(80) end
        end
        PopScaleformMovieFunctionVoid()
    end
    return scaleform
end
exports('DisplayInstructionalButtons', k_lib.SetupScaleform)

function k_lib.DisplayInstructionalButtons(buttons)
    local form = k_lib.SetupScaleform("instructional_buttons", buttons)
    local drawButtons = true
    while drawButtons do
        Wait(0)
        for i = 1, #buttons do
            if buttons[i].keyIndex then
                for key, data in pairs(buttons[i].keyIndex) do
                    if data and next(data) and buttons[i].listener(0, key) then
                        data.action(data.args)
                        if data.shouldClose then drawButtons = false end
                    end
                end
            end
        end
    end
end
exports('DisplayInstructionalButtons', k_lib.DisplayInstructionalButtons)