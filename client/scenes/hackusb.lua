
local hackDict = "anim_heist@hs3f@ig1_hack_keypad@male@"
local phoneModel = `ch_prop_ch_phone_ing_01a`
local usbModel = `ch_prop_ch_usb_drive01x`
local hacking = false
local hackAnims = {
    {"action_var_01", "action_var_01_ch_prop_ch_usb_drive01x", "action_var_01_prop_phone_ing"},
    {"hack_loop_var_01", "hack_loop_var_01_ch_prop_ch_usb_drive01x", "hack_loop_var_01_prop_phone_ing"},
    {"success_react_exit_var_01", "success_react_exit_var_01_ch_prop_ch_usb_drive01x", "success_react_exit_var_01_prop_phone_ing"}
}

function k_lib.StartHackScene(plugin_device_model, usb_offSet)
    k_lib.LoadModel(phoneModel)
    k_lib.LoadModel(usbModel)
    k_lib.RequestAnimDict(hackDict)
    local ped = PlayerPedId()
    local currentBag = {
        drawable = GetPedDrawableVariation(ped, 5),
        texture = GetPedTextureVariation(ped, 5)
    }
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    local coords = GetEntityCoords(ped)
    local phone = CreateObject(phoneModel, coords.x, coords.y, coords.z, true, false, false)
    local usb = CreateObject(usbModel, coords.x, coords.y, coords.z, true, false, false)
    local scanner = GetClosestObjectOfType(coords.x, coords.y, coords.z, 2.0,type(plugin_device_model) == 'number' and plugin_device_model or joaat(plugin_device_model), false, false, false)
    local spawnPos = GetOffsetFromEntityInWorldCoords(scanner, table.unpack(usb_offSet))
    local rot = GetEntityRotation(scanner)
    local scene
    for i = 1,3 do
        scene = NetworkCreateSynchronisedScene(spawnPos.x, spawnPos.y, spawnPos.z, rot.x, rot.y, rot.z, 2, false, false, 1.0, 0.0, 1.0)
        Wait(0)
        NetworkAddPedToSynchronisedScene(ped, scene, hackDict, hackAnims[i][1], 8.0, 8.0, 0, 0, 1000.0, 0)
        NetworkAddEntityToSynchronisedScene(usb, scene, hackDict, hackAnims[i][2], 8.0, 8.0, 0)
        NetworkAddEntityToSynchronisedScene(phone, scene, hackDict, hackAnims[i][3], 8.0, 8.0, 0)
        NetworkStartSynchronisedScene(scene)
        if i == 1 then
            Wait(0)
            local localScene = NetworkGetLocalSceneFromNetworkId(scene)
            while GetSynchronizedScenePhase(localScene) < 0.99 do Wait(0) end
        elseif i == 2 then
            Wait(18000)
        end
        Wait(0)
    end
    local localScene = NetworkGetLocalSceneFromNetworkId(scene)
    while IsSynchronizedSceneRunning(localScene) do Wait(0) end
    DeleteObject(phone)
    DeleteObject(usb)
    SetPedComponentVariation(ped, 5, currentBag.drawable, currentBag.texture, 0)
end
exports('StartHackScene', k_lib.StartHackScene)

RegisterCommand('hackscene', function()
    if hacking then hacking = false return end
    k_lib.StartHackScene('hei_prop_hei_securitypanel', {-0.1, 0.05, 0.0})
end)