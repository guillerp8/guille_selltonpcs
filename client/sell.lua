ESX = nil

local hasdrug = false

local police = false

Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(300) 
    end 
end)

-- Threads

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local player = GetPlayerPed(-1)
        local playerloc = GetEntityCoords(player, 0)     
        if not IsPedSittingInAnyVehicle(player) and not IsPedSittingInAnyVehicle(ped) and ped ~= oldped and hasdrug and police then
            if DoesEntityExist(ped) then
                if not IsPedDeadOrDying(ped) then
                    local tyepofped = GetPedType(ped)
                    if tyepofped ~= 28 and not IsPedAPlayer(ped) then
                        if ped ~= player then
                            local pos = GetEntityCoords(ped)
                            ESX.ShowFloatingHelpNotification(_U('press'), vector3(pos.x, pos.y, pos.z + 1), true, true)
                            if IsControlJustPressed(1, 246) then
                                rob = math.random(1,50) -- Change the prob of getting rob
                                print(rob)
                                if rob > 1 then
                                    sell(ped)
                                else
                                    steal(ped)
                                end
                                oldped = ped
                                print(oldped)

                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4000)
        ped = GetPedInFront()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerServerEvent("guille_drugsystem:drugcheck")
        TriggerServerEvent("guille_drugsystem:police")
    end
end)


-- Functions


function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function sell(ped)
    TaskStandStill(ped, 20.0)
    RequestAnimDict('misscarsteal4@actor')
    FreezeEntityPosition(ped, true)
    while (not HasAnimDictLoaded('misscarsteal4@actor')) do 
        Citizen.Wait(0) 
    end
    TaskPlayAnim(GetPlayerPed(-1), 'misscarsteal4@actor', "actor_berating_loop", 8.0, 8.0, -1, 50, 0, false, false, false)
    TaskPlayAnim(ped, 'misscarsteal4@actor', "actor_berating_loop", 8.0, 8.0, -1, 50, 0, false, false, false)
    exports['progressBars']:startUI(8000, _U('attempt'))
    Citizen.Wait(8000)
    ClearPedTasks(GetPlayerPed(-1))
    local attemp = math.random(1,1) -- Change the prob of calling police
    print(attemp)
    if attemp > 2 then
        local player = GetPlayerPed(-1)
        local playerloc = GetEntityCoords(player, 0)
        RequestAnimDict('mp_prison_break')
        FreezeEntityPosition(ped, true)
        while (not HasAnimDictLoaded('mp_prison_break')) do 
            Citizen.Wait(0) 
        end
        TaskPlayAnim(ped, 'mp_prison_break', "hack_loop", 8.0, 8.0, -1, 50, 0, false, false, false)
        TaskPlayAnim(GetPlayerPed(-1), 'mp_prison_break', "hack_loop", 8.0, 8.0, -1, 50, 0, false, false, false)
        print("Selling")
        TriggerServerEvent("guille_drugsystem:sell")
        Citizen.Wait(5000)
        ClearPedTasks(ped)
        FreezeEntityPosition(ped, false)
        ClearPedTasks(GetPlayerPed(-1))

    else

        if Config.policecall then 
            ESX.ShowNotification(_U('police'))
            TriggerServerEvent("guille_drugsystem:policecall")
        else
            ESX.ShowNotification(_U('not_interested'))
        end
        
        FreezeEntityPosition(ped, false)

    end

    olped = GetPedInFront()
    SetPedAsNoLongerNeeded(ped)
    
end

function steal(ped)
    TaskStandStill(ped, 20.0)
    RequestAnimDict('misscarsteal4@actor')
    FreezeEntityPosition(ped, true)
    while (not HasAnimDictLoaded('misscarsteal4@actor')) do 
        Citizen.Wait(0) 
    end
    TaskPlayAnim(GetPlayerPed(-1), 'misscarsteal4@actor', "actor_berating_loop", 8.0, 8.0, -1, 50, 0, false, false, false)
    TaskPlayAnim(ped, 'misscarsteal4@actor', "actor_berating_loop", 8.0, 8.0, -1, 50, 0, false, false, false)
    exports['progressBars']:startUI(8000, _U('attempt'))
    Citizen.Wait(8000)
    ClearPedTasks(GetPlayerPed(-1))
    Citizen.Wait(200)
    RequestAnimDict('melee@unarmed@streamed_variations')
    while (not HasAnimDictLoaded('melee@unarmed@streamed_variations')) do 
        Citizen.Wait(0) 
    end
    Citizen.Wait(20)
    TaskPlayAnim(ped, 'melee@unarmed@streamed_variations', "plyr_takedown_front_headbutt", 8.0, 8.0, -1, 50, 0, false, false, false)
    SetPedToRagdoll(GetPlayerPed(-1), 20000, 20000, 0, 0, 0, 0)
    Citizen.Wait(1000)
    RequestAnimDict('amb@prop_human_bum_bin@idle_b')
    while (not HasAnimDictLoaded('amb@prop_human_bum_bin@idle_b')) do 
        Citizen.Wait(0) 
    end
    TaskPlayAnim(ped,"amb@prop_human_bum_bin@idle_b","idle_d",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
    TriggerServerEvent("guille_drugsystem:steal")
    vibrate()
    Citizen.Wait(3000)
    FreezeEntityPosition(ped, false)
    ClearPedTasksImmediately(ped)
    Citizen.Wait(12000)
end

function vibrate()
    for i=1,3 do
        Citizen.Wait(2000)
        ShakeGameplayCam("VIBRATE_SHAKE", 0.75)
    end
end


-- Events

RegisterNetEvent("guille_drugsystem:polblip")
AddEventHandler("guille_drugsystem:polblip", function(ubi)

    drugblip = AddBlipForCoord(ubi.x, ubi.y, ubi.z)

	SetBlipSprite(drugblip, 140)
	SetBlipScale(drugblip, 1.2)
    SetBlipColour(drugblip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('blip'))
    EndTextCommandSetBlipName(drugblip)
    
    Citizen.Wait(25000)

    RemoveBlip(drugblip)

end)


RegisterNetEvent('guille_drugsystem:yesdrug')
AddEventHandler('guille_drugsystem:yesdrug', function()
    hasdrug = true
end)

RegisterNetEvent('guille_drugsystem:nodrug')
AddEventHandler('guille_drugsystem:nodrug', function()
    hasdrug = false
end)

RegisterNetEvent('guille_drugsystem:yespol')
AddEventHandler('guille_drugsystem:yespol', function()
    police = true
end)

RegisterNetEvent('guille_drugsystem:nopol')
AddEventHandler('guille_drugsystem:nopol', function()
    police = false
end)
