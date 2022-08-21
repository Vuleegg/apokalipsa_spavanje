ESX = nil
local tiredanim = false
local display = false
local isInMarker = false
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}
Citizen.CreateThread(function()
	while ESX == nil do

		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
	TriggerEvent('ata_afk:wakeup')
	TriggerServerEvent("ata:sleep",false)
	TriggerEvent('nui:off')
	TriggerEvent('nui:off2')
	TriggerEvent('nui:off3')
end)

secondsUntilKick = 600 ----- time for kick player 600sec = 10min

-- Warn players if 3/4 of the Time Limit ran up
kickWarning = true

-- CODE --


RegisterNetEvent('nui:off2')
AddEventHandler('nui:off2', function()
  SendNUIMessage({
	type = "ui2",
	display = false
  })
end)
RegisterNetEvent('nui:on2')
AddEventHandler('nui:on2', function()
  SendNUIMessage({
	type = "ui2",
	display = true
  })
end)
RegisterNetEvent('nui:on')
AddEventHandler('nui:on', function()
  SendNUIMessage({
	type = "ui",
	display = true
  })
end)

RegisterNetEvent('nui:off')
AddEventHandler('nui:off', function()
  SendNUIMessage({
	type = "ui",
	display = false
  })
end)

RegisterNetEvent('nui:on3')
AddEventHandler('nui:on3', function(output)
	if output > 0 then
  SendNUIMessage({
	type = "ui3",
	display = true,
	data = output*Config.timeforremovetired
  })
	else
	SendNUIMessage({
		type = "ui3",
		display = false
	  })
	end
end)

RegisterNetEvent('nui:off3')
AddEventHandler('nui:off3', function(output)
  SendNUIMessage({
	type = "ui3",
	display = false
  })
end)





function setTiredAnim()
    tiredanim = true
	if Config.tiredeffect then
	SetTimecycleModifier("fp_vig_black") 
	RequestAnimSet("move_m@drunk@verydrunk")
	SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", true)
	end

end

function stopTiredAnim()
    tiredanim = false
	ResetPedMovementClipset(PlayerPedId())
	SetTimecycleModifier("default") 
    ResetPedWeaponMovementClipset(PlayerPedId())
    ResetPedStrafeClipset(PlayerPedId())
end


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5000)
		enter()
        if ESX.GetPlayerData().IsSleep then
			
            TriggerServerEvent('ata:addbasicneeds')
			if isInMarker == false then
				TriggerEvent('ata_afk:wakeup')
			end
        end
        ESX.TriggerServerCallback("ata:gettired", function(output)
			if not ESX.GetPlayerData().IsSleep then
				
			if output >= 0 and output < 4 then
				if tiredanim then
				stopTiredAnim()
				end
				TriggerEvent('nui:off')
				TriggerEvent('nui:off2')
				TriggerEvent('nui:off3')
			elseif output >= 4 and output < 8 then
				TriggerEvent('nui:on')
				stopTiredAnim()
     		 	TriggerEvent('nui:off2')
				TriggerEvent('nui:off3')
			else
				setTiredAnim()
				TriggerEvent('nui:off')
    		    TriggerEvent('nui:on2')
				TriggerEvent('nui:off3')
			end
		else
		TriggerEvent('nui:off')
		TriggerEvent('nui:off2')
		TriggerEvent('nui:on3',output)
		end
		end)
    end
end)

function sleep()
	if isInMarker then
        if not ESX.GetPlayerData().IsSleep then
        local playerPed = PlayerPedId()
        local ped = PlayerPedId()
       
          local coords = GetEntityCoords(ped)
          local heading = GetEntityHeading(ped)
          local formattedCoords = {
            x = ESX.Math.Round(coords.x, 1),
            y = ESX.Math.Round(coords.y, 1),
            z = ESX.Math.Round(coords.z, 1) 
          }
        StartSleepAnim(playerPed, formattedCoords, heading)
		elseif ESX.GetPlayerData().IsSleep then
  		  TriggerEvent('ata_afk:wakeup')
		end
  	else
        --ESX.ShowNotification('ridi')
        TriggerEvent('ata_afk:wakeup')
 	end
end


RegisterNetEvent('ata_afk:wakeup')
AddEventHandler('ata_afk:wakeup', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	ESX.SetPlayerData('IsSleep', false)
	TriggerServerEvent("ata:sleep",false)
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1) 
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)

	ESX.UI.Menu.CloseAll()
	Citizen.CreateThread(function()
	Citizen.Wait(1000)
	end)
end



function StartSleepAnim(ped, coords, heading)
	local animDict = 'timetable@tracy@sleep@'
	local animName = 'base'
    local maxhealth = GetEntityMaxHealth(ped)

	ESX.SetPlayerData('IsSleep', true)
	TriggerServerEvent("ata:sleep",true)
	
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerHealthRechargeMultiplier(PlayerId(-1), 0.0)
    SetEntityHealth(ped, maxhealth)
	ESX.Streaming.RequestAnimDict(animDict, function()
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 1.0, 0, 0, 0)
	end)
	ESX.UI.Menu.CloseAll()

	Citizen.CreateThread(function()
	Citizen.Wait(1000)

	end)
end


function enter()

		local coords = GetEntityCoords(PlayerPedId())
		isInMarker = false

		for i=1, #Config.Zones, 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.Zones[i], true)
			if distance <=   (Config.ZoneSize.x / 2) then
				isInMarker = true
			end
		end
end



RegisterCommand('sleep', function()
		enter()
		if isInMarker then
			sleep()
		else
			ESX.ShowNotification('Morate biti u kuci da bi spavali')
		end
	
end)