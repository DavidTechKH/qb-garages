
local OutsideVehicles = {}

QBCore.Functions.CreateCallback("qb-garage:server:checkVehicleOwner", function(source, cb, plate)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',{plate, pData.PlayerData.citizenid}, function(result)
        if result[1] then
            cb(true, result[1].balance)
        else
            cb(false)
        end
    end)
end)

--Lấy danh sách xe trong gara:
QBCore.Functions.CreateCallback("qb-garages:server:GetUserVehicles", function(source, cb, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ? AND garage = ?', {pData.PlayerData.citizenid, garage}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:GetDepotVehicles", function(source, cb)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE citizenid = ? AND state = ?',{pData.PlayerData.citizenid, 0}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

QBCore.Functions.CreateCallback("qb-garage:server:GetDepotPoliceVehicles", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE state = ?',{2}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

--Lấy thông tin xe:
QBCore.Functions.CreateCallback("qb-garages:server:GetVehicleProperties", function(source, cb, plate)
    local properties = {}
    local result = MySQL.Sync.fetchAll('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
    if result[1] ~= nil then
        properties = json.decode(result[1].mods)
    end
    cb(properties)
end)

RegisterNetEvent('qb-garages:server:UpdateOutsideVehicles', function(Vehicles)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local CitizenId = Ply.PlayerData.citizenid

    OutsideVehicles[CitizenId] = Vehicles
end)

RegisterNetEvent('qb-garages:server:updateVehicleState', function(state, plate, garage)
    MySQL.Async.execute('UPDATE player_vehicles SET state = ?, garage = ?, depotprice = ? WHERE plate = ?',
        {state, garage, 0, plate})
end)

RegisterNetEvent('qb-garages:server:updateVehicleStatus', function(fuel, engine, body, plate, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)

    if engine > 1000 then
        engine = engine / 1000
    end

    if body > 1000 then
        body = body / 1000
    end

    MySQL.Async.execute(
        'UPDATE player_vehicles SET fuel = ?, engine = ?, body = ? WHERE plate = ? AND citizenid = ? AND garage = ?',
        {fuel, engine, body, plate, pData.PlayerData.citizenid, garage})
end)

RegisterNetEvent('qb-garages:server:PayDepotPrice', function(vehicle, garage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cashBalance = Player.PlayerData.money["cash"]
    local bankBalance = Player.PlayerData.money["bank"]
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', {vehicle.plate}, function(result)
        if result[1] ~= nil then
            if cashBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("cash", result[1].depotprice, "paid-depot")
                TriggerClientEvent("qb-garages:client:doTakeOutImpoundVehicle", src, vehicle, garage)
                TriggerClientEvent('QBCore:Notify', src, 'You take out your impounded Vehicle!')
            elseif bankBalance >= result[1].depotprice then
                Player.Functions.RemoveMoney("bank", result[1].depotprice, "paid-depot")
                TriggerClientEvent("qb-garages:client:doTakeOutImpoundVehicle", src, vehicle, garage)
                TriggerClientEvent('QBCore:Notify', src, 'You take out your impounded Vehicle!')
            else
                TriggerClientEvent('QBCore:Notify', src, 'Not enough money', 'error')
            end
        end
    end)
end)