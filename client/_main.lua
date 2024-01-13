function k_lib.RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end
exports('RequestAnimDict', k_lib.RequestAnimDict)

function k_lib.LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end
exports('LoadModel', k_lib.LoadModel)

function k_lib.CalculateOffsets(singleVector, vectorList)
    local offsets = {}
    for _, vector in ipairs(vectorList) do
        local offset
        if vector.w then
            local heading = vector.w or 0.0 - singleVector.w or 0.0
            if heading < 0 then heading = 360 + heading end
            offset = vector4(vector.x - singleVector.x, vector.y - singleVector.y, vector.z - singleVector.z, heading)
        else
            offset = vector3(vector.x - singleVector.x, vector.y - singleVector.y, vector.z - singleVector.z)
        end
        table.insert(offsets, offset)
    end
    return offsets
end
exports('CalculateOffsets', k_lib.CalculateOffsets)
