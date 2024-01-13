-- experimental.. for future use

function k_lib.NetworkedSceneStart(coords, rotation, peds, objects, duration)
    local scene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rotation, 2, false, false, -1, 0, 1.0)

    for k, v in pairs(peds) do
        if v.model and not v.ped then
            k_lib.LoadModel(v.model)
            v.ped = CreatePed(23, v.model, coords.x, coords.y, coords.z, 0.0, true, true)
            v.createdByUs = true
        end
        k_lib.RequestAnimDict(v.anim.dict)
        NetworkAddPedToSynchronisedScene(v.ped, scene, v.anim.dict, v.anim.anim, 1.5, -4.0, 1, 16, 1148846080, 0)
    end

    for k, v in pairs(objects) do
        if v.model and not v.object then
            k_lib.LoadModel(v.model)
            v.object = CreateObject(v.model, coords, true, true, true)
            v.createdByUs = true
        end
        k_lib.RequestAnimDict(v.anim.dict)
        NetworkAddEntityToSynchronisedScene(v.object, scene, v.anim.dict, v.anim.anim, 1.0, 1.0, 1)
    end

    NetworkStartSynchronisedScene(scene)
    if duration then
        Wait(duration)
    else
        local localScene = NetworkGetLocalSceneFromNetworkId(scene)
        while GetSynchronizedScenePhase(localScene) < 0.99 do Wait(0) end
    end
    NetworkStopSynchronisedScene(scene)

    for k, v in pairs(peds) do
        if v.createdByUs then DeletePed(v.ped) end
    end

    for k, v in pairs(objects) do
        if v.createdByUs then DeleteEntity(v.object) end
    end
    return scene
end