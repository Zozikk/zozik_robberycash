 --  ________ ________ _  __
 -- |__  / _ \__  /_ _| |/ /
 --   / / | | |/ / | || ' / 
 --  / /| |_| / /_ | || . \ 
 -- /____\___/____|___|_|\_\
                         

ESX = exports['es_extended']:getSharedObject()
startedRobbery = false
robberyModels = {}
print(Config.locales.icon)
exports.ox_target:addModel("prop_till_01", {
	{
		distance = 2,
		onSelect = function()
			TriggerServerEvent('zozik:checkPolice')
		end,
		icon = Config.locales.icon,
		label = Config.locales.label,
		num = 2,
		canInteract = function(entity)
			if IsPedArmed(PlayerPedId(), 4) then
				return true
			else
				return false
			end
		end
	},
})


Citizen.CreateThread(function()
    while robberyModels do
    	for k,v in ipairs(robberyModels) do
			if robberyModels[k] ~= nil then
				local timer = Config.timeToReset * 60000
				Wait(timer)
				table.remove(robberyModels, k)
			end
		end
    	Wait(100)
    end

end)

function checkRobberyModel()
	local pedCoords = GetEntityCoords(PlayerPedId())
	local objectId = GetClosestObjectOfType(pedCoords, 2.5, GetHashKey("prop_till_01"), false)
	local objectCoords = GetEntityCoords(objectId)
	for k,v in ipairs(robberyModels) do
		if objectCoords == v then
			return true
		end
	end
	return false
end

function addRobberyModel()
	local pedCoords = GetEntityCoords(PlayerPedId())
	local objectId = GetClosestObjectOfType(pedCoords, 2.5, GetHashKey("prop_till_01"), false)
	local objectCoords = GetEntityCoords(objectId)
	table.insert(robberyModels, objectCoords)
end

function animation()
	local dict = "oddjobs@shop_robbery@rob_till"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
	TaskPlayAnim(GetPlayerPed(-1), dict, "loop", 8.0, 8.0, -1, 1, 0, false, false, false)
end

RegisterNetEvent('zozik:startRobbery')
AddEventHandler('zozik:startRobbery', function()
	local canRobbery = checkRobberyModel()
	if canRobbery == false then
		addRobberyModel()
		ESX.ShowNotification(Config.locales.startRobbery)
		ExecuteCommand(Config.locales.meCommand)
		animation()
		TriggerServerEvent("zozik:policeAlarm", GetEntityCoords(GetPlayerPed(-1),true))
		local success = exports['fancy_mathminigame']:StartGame()

		if success == true then
		    ESX.ShowNotification(Config.locales.successRobbery)
		    ClearPedTasks(GetPlayerPed(-1))
		    TriggerServerEvent('zozik:giveMoney')
		else
		    ESX.ShowNotification(Config.locales.failedRobbery)
		    ClearPedTasks(GetPlayerPed(-1))
		end

	else
		ESX.ShowNotification(Config.locales.canRobbery)
	end

end)

RegisterNetEvent('zozik:policeAlarmOnMap')
AddEventHandler('zozik:policeAlarmOnMap', function(x,y,z) 
    print(x, y, z)
    print(ESX.GetPlayerData().job.name)
    if ESX.GetPlayerData().job ~= nil and ESX.GetPlayerData().job.name == Config.police then

    	local street = GetStreetNameAtCoord(x, y, z)
    	local droga = GetStreetNameFromHashKey(street)

    	ESX.ShowNotification('Doniesiono o rabunku kasy fiskalnej w okolicy ~y~'..droga..'!')
		PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)

		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 161)
        SetBlipScale(blip, 1.2)
        SetBlipColour(blip, 75)
        SetBlipAlpha(blip, 180)
        SetBlipHighDetail(blip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.locales.robbery)
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(30000)
        RemoveBlip(blip)

    end
end)




