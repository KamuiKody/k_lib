local animDict = "anim_heist@hs3f@ig9_vault_drill@drill@"
local drillingDict = "anim@heists@fleeca_bank@drilling"
local drillModel = `hei_prop_heist_drill`
local bagModel = `hei_p_m_bag_var22_arm_s`

function k_lib.StartDrillingScene(drillType, discs)
    k_lib.RequestAnimDict(animDict)
    k_lib.RequestAnimDict(drillingDict)
    k_lib.LoadModel(drillModel)
    k_lib.LoadModel(bagModel)
    local ped = PlayerPedId()
    local currentBag = {
        drawable = GetPedDrawableVariation(ped, 5),
        texture = GetPedTextureVariation(ped, 5)
    }
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    local pedCoords = GetEntityCoords(ped) -- I suggest you save the coords in the beginning, and use them for all of the following scenes because it seems to cause problems if you use the current coords every time
    local pedRotation = GetEntityRotation(ped)
    local drill = CreateObject(drillModel, pedCoords,true,true,true) -- creating the drill's object 
    local bag = CreateObject(bagModel, pedCoords,true,true,true) -- creating the bag object
    local intro = NetworkCreateSynchronisedScene(pedCoords.x, pedCoords.y, pedCoords.z+.17,pedRotation.z, 2, false, false, -1, 0, 1.0)
    NetworkAddPedToSynchronisedScene(ped, intro, animDict, "intro", 1.5, -4.0, 1, 16, 1148846080, 0) -- adding the ped to the scene
    NetworkAddEntityToSynchronisedScene(drill, intro, animDict, "intro_drill_bit", 1.0, 1.0, 1) -- adding the drill to the scene
    NetworkAddEntityToSynchronisedScene(bag, intro, animDict, "bag_intro", 1.0, 1.0, 1) -- adding the entity to the scene
    NetworkAddSynchronisedSceneCamera(intro,animDict,'intro_cam') -- adding the cam
    NetworkStartSynchronisedScene(intro) -- starting the scene
    Wait(GetAnimDuration(animDict, "intro") * 1000) -- waiting for the scene to finish
    NetworkStopSynchronisedScene(intro)
    TaskPlayAnim(ped, drillingDict, 'drill_straight_idle', 3.0, 3.0, -1, 1, 0, false, false, false)
    AttachEntityToEntity(drill, ped, GetPedBoneIndex(ped, 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
    local result = k_lib.Drilling(drillType, discs)
    StopAnimTask(ped, drillingDict, "drill_straight_idle", 1.0)

    DetachEntity(drill, true, true)
    DeleteObject(drill)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, currentBag.drawable, currentBag.texture, 0)
    return result
end
exports('StartDrilling', k_lib.StartDrillingScene)

RegisterCommand('drill', function()
    local retval = k_lib.StartDrillingScene('DRILLING')
    print(retval)
end)