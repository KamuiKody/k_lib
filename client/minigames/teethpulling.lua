local scaleform = nil
local angle = 0.0
local depth = 0

local function teethInit()
    scaleform = k_lib.LoadScaleform("TEETH_PULLING")
    -- k_lib.IntScreen("SET_TEETH_BRITTLE", 0)
    k_lib.IntScreen("SET_TEETH_ANGLE", angle)
    k_lib.IntScreen("SET_TEETH_DEPTH", depth)
    while true do
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 255)
        Wait(0)
    end
end
RegisterCommand('pullteeth', teethInit)