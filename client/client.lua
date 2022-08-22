
local inGarageStation = false
local currentgarage = nil
local nearspawnpoint = nil
local OutsideVehicles = {}
local Stations = {}
local PlayerData = {}

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

local function GetVehiclesInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(QBCore.Functions.GetVehicles(), false, coords, maxDistance) 
end

local function IsSpawnPointClear(coords, maxDistance) 
	return #GetVehiclesInArea(coords, maxDistance) == 0 
end

local function Deleteveh(plate)
	local gameVehicles = QBCore.Functions.GetVehicles()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if QBCore.Functions.GetPlate(vehicle) == plate then
				QBCore.Functions.DeleteVehicle(vehicle)
            end
        end
    end
end

local function GetNearSpawnPoint()
	local near = nil
	local distance = 10000
	if inGarageStation and currentgarage ~= nil then
		for k, v in pairs(Garages[currentgarage].spawnPoint) do
			if IsSpawnPointClear(vector3(v.x, v.y, v.z), 2.5) then
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local cur_distance = #(pos - vector3(v.x, v.y, v.z))
				if cur_distance < distance then
					distance = cur_distance
					near = k
				end
			end
		end
	end
	return near
end

local function CheckPlayers(vehicle)
    for i = -1, 5,1 do
        local seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,0)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            QBCore.Functions.DeleteVehicle(vehicle)
        end
   end
end

local function doCarDamage(currentVehicle, veh)
	local smash = false
	local damageOutside = false
	local damageOutside2 = false
	local engine = veh.engine + 0.0
	local body = veh.body + 0.0
	if engine < 200.0 then
		engine = 200.0
    end

    if engine > 1000.0 then
        engine = 1000.0
    end

	if body < 150.0 then
		body = 150.0
	end
	if body < 900.0 then
		smash = true
	end

	if body < 800.0 then
		damageOutside = true
	end

	if body < 500.0 then
		damageOutside2 = true
	end

    Wait(100)
    SetVehicleEngineHealth(currentVehicle, engine)
	if smash then
		SmashVehicleWindow(currentVehicle, 0)
		SmashVehicleWindow(currentVehicle, 1)
		SmashVehicleWindow(currentVehicle, 2)
		SmashVehicleWindow(currentVehicle, 3)
		SmashVehicleWindow(currentVehicle, 4)
	end
	if damageOutside then
		SetVehicleDoorBroken(currentVehicle, 1, true)
		SetVehicleDoorBroken(currentVehicle, 6, true)
		SetVehicleDoorBroken(currentVehicle, 4, true)
	end
	if damageOutside2 then
		SetVehicleTyreBurst(currentVehicle, 1, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 2, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 3, false, 990.0)
		SetVehicleTyreBurst(currentVehicle, 4, false, 990.0)
	end
	if body < 1000 then
		SetVehicleBodyHealth(currentVehicle, 985.1)
	end
end

local function getNearestVeh()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    return vehicleHandle
end

function IsInGarage()
	local check, garastate = false, nil
	if inGarageStation and currentgarage ~= nil then
		check = true
		garastate = Garages[currentgarage].garastate
	end
	return check, garastate
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    inGarageStation = false
	currentgarage = nil
	nearspawnpoint = nil
	OutsideVehicles = {}
	Stations = {}
	PlayerData = {}
end)

CreateThread(function()
	for k, v in pairs(Garages) do
		if v.showBlip then
			if v.job == nil then
				local Garage = AddBlipForCoord(Garages[k].blippoint)
				SetBlipSprite (Garage, Garages[k].blipsprite)
				SetBlipDisplay(Garage, 4)
				SetBlipScale  (Garage, Garages[k].blipscale)
				SetBlipAsShortRange(Garage, true)
				SetBlipColour(Garage, Garages[k].blipcolour)
				SetBlipAlpha(Blip, 0.7)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentSubstringPlayerName(Garages[k].label)
				EndTextCommandSetBlipName(Garage)
			end
		end
	end
end)

CreateThread(function()
    for k, v in pairs(Garages) do
		Stations[k] = PolyZone:Create(v.zones, {
			name="GarageStation "..k,
			minZ = 	v.minz,
			maxZ = v.maxz,
			debugPoly = false
		})
		Stations[k]:onPlayerInOut(function(isPointInside)
			if isPointInside then
				if Garages[k].job ~= nil then
					PlayerData = QBCore.Functions.GetPlayerData()
					if PlayerData.job and PlayerData.job.name == Garages[k].job or PlayerData.gang and PlayerData.gang.name == Garages[k].job then
						inGarageStation = true
						currentgarage = k
					else
						inGarageStation = false
						currentgarage = nil
					end
				else
					inGarageStation = true
					currentgarage = k
				end
			else
				inGarageStation = false
				currentgarage = nil
			end
		end)
    end
end)

CreateThread(function()
	while true do
		Wait(1000)
		if inGarageStation and currentgarage ~= nil then
			nearspawnpoint = GetNearSpawnPoint()
		end
	end
end)

CreateThread(function()
	local alreadyinzone = false
	while true do
		local inzone = false
		local sleep = 100
		local ped = PlayerPedId()
		if inGarageStation and currentgarage ~= nil and Garages[currentgarage].garastate == 1 then
			inzone = true
		end
		if inzone and not alreadyinzone then
			alreadyinzone = true
			exports["dv-ui"]:showInteraction('Parking')
		end
		if not inzone and alreadyinzone then
			alreadyinzone = false
			exports["dv-ui"]:hideInteraction()
			sleep = 1000
		end
		Wait(sleep)
	end
end)


RegisterNetEvent('qb-garages:openGarage', function()
    if inGarageStation and currentgarage ~= nil then
		QBCore.Functions.TriggerCallback("qb-garages:server:GetUserVehicles", function(result)
			if result == nil then
				QBCore.Functions.Notify("There are no vehicles in the garage", "error", 5000)
			else
				local MenuGaraOptions = {
					{
						header = 'Parking: ' .. Garages[currentgarage].label,
						isMenuHeader = true
					},
				}
				for k, v in pairs(result) do
					if v.garage == currentgarage then
						if v.state == 0 then
							v.state = "Out"
						elseif v.state == 1 then
							v.state = "Stored"
						elseif v.state == 2 then
							v.state = "Impounded"
						end

						MenuGaraOptions[#MenuGaraOptions+1] = {
							header = QBCore.Shared.Vehicles[v.vehicle].name,
                    		txt = "Plate: "..v.plate.." | "..v.state,
							params = {
								event = "qb-garages:client:VehicleListSpawnOption",
								args = v
							}
						}
					end
				end
				MenuGaraOptions[#MenuGaraOptions+1] = {
					header = 'Close',
					txt = "",
					params = {
						event = "qb-menu:closeMenu",
					}
				}
				exports['qb-menu']:openMenu(MenuGaraOptions)
			end
		end, currentgarage)
	end
end)

RegisterNetEvent("qb-garages:client:VehicleListSpawnOption", function(vehicle)
    if inGarageStation and currentgarage ~= nil then
		QBCore.Functions.TriggerCallback("qb-garages:server:GetUserVehicles", function()
			if vehicle.garage == currentgarage then
				if Garages[currentgarage].fullfix then
					vehicle.engine = 1000
					vehicle.body = 1000
					vehicle.fuel = 100
				end

				local enginePercent = QBCore.Shared.Round(vehicle.engine / 10, 0)
				local bodyPercent = QBCore.Shared.Round(vehicle.body / 10, 0)
				local currentFuel = vehicle.fuel

				if vehicle.state == 0 then
					vehicle.state = "Out"
				elseif vehicle.state == 1 then
					vehicle.state = "Stored"
				elseif vehicle.state == 2 then
					vehicle.state = "Impounded"
				end

				local VehicleListSpawnOption = {
					{
						header = "< Go Back",
						txt = "",
						params = {
							event = "qb-garages:openGarage",
						}
					},
					{
						header = "Take Out Vehicle",
						txt = "",
						params = {
							event = "qb-garages:client:TakeOutVehicle",
							args = vehicle
						}
					},
					{
						header = "Vehicle Status",
						txt = vehicle.state.." | Fuel: "..currentFuel.."% | Engine: "..enginePercent.."% | Body: "..bodyPercent.."%",
						isMenuHeader = true
					}
				}
				exports['qb-menu']:openMenu(VehicleListSpawnOption)
			end
		end, currentgarage)
	end
end)

RegisterNetEvent('qb-garages:openimpoundGarage', function()
    if inGarageStation and currentgarage ~= nil then
		QBCore.Functions.TriggerCallback("qb-garage:server:GetDepotVehicles", function(result)
			if result == nil then
				QBCore.Functions.Notify("There are no vehicles at the impound.", "error", 5000)
			else
				local MenuImpoundGaraOptions = {
					{
						header = Garages[currentgarage].label,
						isMenuHeader = true
					},
				}
				for k, v in pairs(result) do
					local info = {}

					if v.state == 0 and v.depotprice > 0 then
						info = "Price: $"..v.depotprice.." Plate: "..v.plate
					else
						info = "Plate: "..v.plate
					end
					
					MenuImpoundGaraOptions[#MenuImpoundGaraOptions+1] = {
						header = QBCore.Shared.Vehicles[v.vehicle].name,
						txt = info,
						params = {
							event = "qb-garages:client:ImpoundListSpawnOption",
							args = v
						}
					}
				end
				MenuImpoundGaraOptions[#MenuImpoundGaraOptions+1] = {
					header = 'Close',
					txt = "",
					params = {
						event = "qb-menu:closeMenu",
					}
				}
				exports['qb-menu']:openMenu(MenuImpoundGaraOptions)
			end
		end)
	end
end)

RegisterNetEvent("qb-garages:client:ImpoundListSpawnOption", function(vehicle)
    if inGarageStation and currentgarage ~= nil then
		QBCore.Functions.TriggerCallback("qb-garage:server:GetDepotVehicles", function()
			if Garages[currentgarage].fullfix then
				vehicle.engine = 1000
				vehicle.body = 1000
				vehicle.fuel = 100
			end

			local enginePercent = QBCore.Shared.Round(vehicle.engine / 10, 0)
			local bodyPercent = QBCore.Shared.Round(vehicle.body / 10, 0)
			local currentFuel = vehicle.fuel

			local ImpoundListSpawnOption = {
				{
					header = "< Go Back",
					txt = "",
					params = {
						event = "qb-garages:openimpoundGarage",
					}
				},
				{
					header = "Take Out Vehicle",
					txt = "",
					params = {
						event = "qb-garages:client:TakeOutImpoundVehicle",
						args = vehicle
					}
				},
				{
					header = "Vehicle Status",
					txt = "Fuel: "..currentFuel.."% | Engine: "..enginePercent.."% | Body: "..bodyPercent.."%",
					isMenuHeader = true
				}
			}
			exports['qb-menu']:openMenu(ImpoundListSpawnOption)
		end)
	end
end)

RegisterNetEvent('qb-garages:openimpoundpoliceGarage', function()
    if inGarageStation and currentgarage ~= nil then
		QBCore.Functions.TriggerCallback("qb-garage:server:GetDepotPoliceVehicles", function(result)
			if result == nil then
				QBCore.Functions.Notify("There are no vehicles at impound police.", "error", 5000)
			else
				local MenuImpoundPoliceGaraOptions = {
					{
						header = Garages[currentgarage].label,
						isMenuHeader = true
					},
				}
				for k, v in pairs(result) do
					if v.state == Garages[currentgarage].garastate then
						if Garages[currentgarage].fullfix then
							v.engine = 1000
							v.body = 1000
							v.fuel = 100
						end

						local enginePercent = QBCore.Shared.Round(v.engine / 10, 0)
						local bodyPercent = QBCore.Shared.Round(v.body / 10, 0)
						local currentFuel = v.fuel

						if v.state == 0 then
							v.state = "Out"
						elseif v.state == 1 then
							v.state = "Stored"
						elseif v.state == 2 then
							v.state = "Impounded"
						end

						MenuImpoundPoliceGaraOptions[#MenuImpoundPoliceGaraOptions+1] = {
							header = QBCore.Shared.Vehicles[v.vehicle].name,
							txt = "Plate: "..v.plate.." <br>Fuel: "..currentFuel.." | Engine: "..enginePercent.." | Body: "..bodyPercent,
							params = {
								event = "qb-garages:client:TakeOutImpoundPoliceVehicle",
								args = v
							}
						}
					end
				end
				MenuImpoundPoliceGaraOptions[#MenuImpoundPoliceGaraOptions+1] = {
					header = 'Close',
					txt = "",
					params = {
						event = "qb-menu:closeMenu",
					}
				}
				exports['qb-menu']:openMenu(MenuImpoundPoliceGaraOptions)
			end
		end)
	end
end)


RegisterNetEvent('qb-garages:client:TakeOutImpoundVehicle', function(vehicle)
    if inGarageStation and currentgarage ~= nil and nearspawnpoint ~= nil then
		if vehicle.depotprice > 0 then
			TriggerServerEvent("qb-garages:server:PayDepotPrice", vehicle)
			Wait(1000)
		else
			TriggerEvent("qb-garages:client:doTakeOutImpoundVehicle", vehicle)
			QBCore.Functions.Notify("You take out your impounded Vehicle!", "primary", 4000)
		end
	end
end)

RegisterNetEvent('qb-garages:client:doTakeOutImpoundVehicle', function(vehicle)
    if inGarageStation and currentgarage ~= nil and nearspawnpoint ~= nil then
		local lastnearspawnpoint = nearspawnpoint
		if not IsSpawnPointClear(vector3(Garages[currentgarage].spawnPoint[lastnearspawnpoint].x, Garages[currentgarage].spawnPoint[lastnearspawnpoint].y, Garages[currentgarage].spawnPoint[lastnearspawnpoint].z), 2.5) then
			QBCore.Functions.Notify('The receiving area is obstructed by something...', "error", 2500)
			return
		else
			enginePercent = QBCore.Shared.Round(vehicle.engine / 10, 1)
			bodyPercent = QBCore.Shared.Round(vehicle.body / 10, 1)
			currentFuel = vehicle.fuel
			QBCore.Functions.Notify("Being Checked, Please Wait...", "Primary", 1000)
			Wait(1000)
			Deleteveh(vehicle.plate)
			QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
				QBCore.Functions.TriggerCallback('qb-garages:server:GetVehicleProperties', function(properties)
					QBCore.Functions.SetVehicleProperties(veh, properties)
					if vehicle.plate ~= nil then
						OutsideVehicles[vehicle.plate] = veh
						TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
					end
					SetVehicleNumberPlateText(veh, vehicle.plate)
					SetEntityHeading(veh, Garages[currentgarage].spawnPoint[lastnearspawnpoint].w)
					exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
					doCarDamage(veh, vehicle)
					SetEntityAsMissionEntity(veh, true, true)
					TriggerServerEvent('qb-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
					--TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
					exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
					SetVehicleEngineOn(veh, false, false)
				end, vehicle.plate)

			end, Garages[currentgarage].spawnPoint[lastnearspawnpoint], true)
		end
	end
end)

RegisterNetEvent('qb-garages:client:TakeOutVehicle', function(vehicle)
    if inGarageStation and currentgarage ~= nil and nearspawnpoint ~= nil then
		TriggerEvent("qb-garages:client:doTakeOutVehicle", vehicle)
	end
end)


RegisterNetEvent('qb-garages:client:doTakeOutVehicle', function(vehicle)
    if inGarageStation and currentgarage ~= nil and nearspawnpoint ~= nil then
		if vehicle.state == 'Stored' then
			local lastnearspawnpoint = nearspawnpoint
			if not IsSpawnPointClear(vector3(Garages[currentgarage].spawnPoint[lastnearspawnpoint].x, Garages[currentgarage].spawnPoint[lastnearspawnpoint].y, Garages[currentgarage].spawnPoint[lastnearspawnpoint].z), 2.5) then
				QBCore.Functions.Notify('The receiving area is obstructed by something...', "error", 2500)
				return
			else
				enginePercent = QBCore.Shared.Round(vehicle.engine / 10, 1)
				bodyPercent = QBCore.Shared.Round(vehicle.body / 10, 1)
				currentFuel = vehicle.fuel
				QBCore.Functions.Notify("Being Checked, Please Wait...", "Primary", 1000)
				Wait(1000)
				Deleteveh(vehicle.plate)
				QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
					QBCore.Functions.TriggerCallback('qb-garages:server:GetVehicleProperties', function(properties)
						QBCore.Functions.SetVehicleProperties(veh, properties)
						if vehicle.plate ~= nil then
							OutsideVehicles[vehicle.plate] = veh
							TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
						end
						SetVehicleNumberPlateText(veh, vehicle.plate)
						SetEntityHeading(veh, Garages[currentgarage].spawnPoint[lastnearspawnpoint].w)
						exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
						doCarDamage(veh, vehicle)
						SetEntityAsMissionEntity(veh, true, true)
						TriggerServerEvent('qb-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
						--TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
						TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
						exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
						SetVehicleEngineOn(veh, true, true)
					end, vehicle.plate)

				end, Garages[currentgarage].spawnPoint[lastnearspawnpoint], true)
			end
		elseif vehicle.state == 'Out' then
			QBCore.Functions.Notify("This vehicle already out!", "error", 2500)
		elseif vehicle.state == 'Impounded' then
			QBCore.Functions.Notify("This vehicle was impounded by the police!", "error", 4000)
		end
	end
end)

RegisterNetEvent('qb-garages:client:TakeOutImpoundPoliceVehicle', function(vehicle)
    if inGarageStation and currentgarage ~= nil and nearspawnpoint ~= nil then
		TriggerEvent("qb-garages:client:doTakeOutPoliceImpoundVehicle", vehicle)
	end
end)


RegisterNetEvent('qb-garages:client:doTakeOutPoliceImpoundVehicle', function(vehicle)
    if inGarageStation and currentgarage ~= nil and nearspawnpoint ~= nil then
		local lastnearspawnpoint = nearspawnpoint
		if not IsSpawnPointClear(vector3(Garages[currentgarage].spawnPoint[lastnearspawnpoint].x, Garages[currentgarage].spawnPoint[lastnearspawnpoint].y, Garages[currentgarage].spawnPoint[lastnearspawnpoint].z), 2.5) then
			QBCore.Functions.Notify('The receiving area is obstructed by something...', "error", 2500)
			return
		else
			enginePercent = QBCore.Shared.Round(vehicle.engine / 10, 1)
			bodyPercent = QBCore.Shared.Round(vehicle.body / 10, 1)
			currentFuel = vehicle.fuel
			QBCore.Functions.Notify("Being Checked, Please Wait...", "Primary", 1000)
			Wait(1000)
			Deleteveh(vehicle.plate)
			QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
				QBCore.Functions.TriggerCallback('qb-garages:server:GetVehicleProperties', function(properties)
					QBCore.Functions.SetVehicleProperties(veh, properties)
					if vehicle.plate ~= nil then
						OutsideVehicles[vehicle.plate] = veh
						TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
					end
					SetVehicleNumberPlateText(veh, vehicle.plate)
					SetEntityHeading(veh, Garages[currentgarage].spawnPoint[lastnearspawnpoint].w)
					exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
					doCarDamage(veh, vehicle)
					SetEntityAsMissionEntity(veh, true, true)
					TriggerServerEvent('qb-garages:server:updateVehicleState', 0, vehicle.plate, vehicle.garage)
					--TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
					exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
					SetVehicleEngineOn(veh, false, false)
				end, vehicle.plate)
			end, Garages[currentgarage].spawnPoint[lastnearspawnpoint], true)
		end
	end
end)


RegisterNetEvent('qb-garages:storeVehicle', function()
    if inGarageStation and currentgarage ~= nil then
		if Garages[currentgarage].garastate == 1 then
			local curVeh = getNearestVeh()
			local plate = QBCore.Functions.GetPlate(curVeh)
			if curVeh then
				QBCore.Functions.TriggerCallback('qb-garage:server:checkVehicleOwner', function(owned)
					if owned then
						local bodyDamage = math.ceil(GetVehicleBodyHealth(curVeh))
						local engineDamage = math.ceil(GetVehicleEngineHealth(curVeh))
						local totalFuel = exports['LegacyFuel']:GetFuel(curVeh)
						local vehProperties = QBCore.Functions.GetVehicleProperties(curVeh)
						CheckPlayers(curVeh)
						TriggerServerEvent('qb-garages:server:updateVehicleStatus', totalFuel, engineDamage, bodyDamage, plate, currentgarage)
						TriggerServerEvent('qb-garages:server:updateVehicleState', 1, plate, currentgarage)
						TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', vehProperties)
						if plate ~= nil then
							OutsideVehicles[plate] = veh
							TriggerServerEvent('qb-garages:server:UpdateOutsideVehicles', OutsideVehicles)
						end
						Wait(500)
						Deleteveh(plate)
						QBCore.Functions.Notify('Vehicle parked in ' .. Garages[currentgarage].label, "primary", 4500)
					else
						QBCore.Functions.Notify("This vehicle not belong to you!", "error", 3500)
					end
				end, plate)
			else
				QBCore.Functions.Notify("You need to look at the vehicle to park!", "error", 4500)
			end
		end
	end
end)