local scaleform = nil

function k_lib.OpenLetter(text, background)
    scaleform = k_lib.LoadScaleform("LETTER_SCRAPS")
    k_lib.BoolScreen(scaleform, 'SET_BG_VISIBILITY', background or false)
    k_lib.AddString(scaleform, 'SET_LETTER_TEXT', text)
    while scaleform do
        Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 255)
    end
end

function k_lib.AddText(text)
    k_lib.AddString(scaleform, 'ADD_TO_LETTER_TEXT', text)
end

function k_lib.CloseLetter()
    k_lib.UnloadScaleform(scaleform)
    scaleform = nil
end