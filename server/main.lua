ESX = nil
local PlayersTransforming  = {}
local PlayersSelling       = {}
local PlayersHarvesting = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.EnableESXService then
	TriggerEvent('esx_service:activateService', 'vigne', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'vigne', _U('alert_vigne'), true, true)
TriggerEvent('esx_society:registerSociety', 'vigne', 'Vigne', 'society_vigne', 'society_vigne', 'society_vigne', {type = 'public'})

RegisterNetEvent('esx_vigneronjob:getStockItem')
AddEventHandler('esx_vigneronjob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				xPlayer.showNotification(_U('have_withdrawn', count, inventoryItem.label))
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

RegisterNetEvent('esx_vigneronjob:putStockItems')
AddEventHandler('esx_vigneronjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification(_U('have_deposited', count, inventoryItem.label))
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vigneronjob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_vigneronjob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plazte, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_vigneronjob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
	local vehicles = Config.AuthorizedVehicles[type][jobGrade]

	for k,v in ipairs(vehicles) do
		if GetHashKey(v.model) == vehicleHash then
			return v.price
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_vigneronjob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vigne', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_vigneronjob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local playerId = source

	-- Did the player ever join?
	if playerId then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		-- Is it worth telling all clients to refresh?
		if xPlayer and xPlayer.job.name == 'vigne' then
			Citizen.Wait(5000)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'vigne')
	end
end)

RegisterNetEvent('esx_vigneronjob:spawned')
AddEventHandler('esx_vigneronjob:spawned', function()
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and xPlayer.job.name == 'vigne' then
		Citizen.Wait(5000)
	end
end)


-------- JOB --------

local function Harvest(source, part)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if part == "RRFarm" then
			local itemQuantity = xPlayer.getInventoryItem('raisinr').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(7500, function()
					xPlayer.addInventoryItem('raisinr', 1)
					Harvest(source, part)
				end)
			end
		end
		if part == "RBFarm" then
			local itemQuantity = xPlayer.getInventoryItem('raisinb').count
			if itemQuantity >= 100 then
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_place'))
				return
			else
				SetTimeout(7500, function()
					xPlayer.addInventoryItem('raisinb', 1)
					Harvest(source, part)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_vigneronjob:startHarvest')
AddEventHandler('esx_vigneronjob:startHarvest', function(part)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, _U('glitch'))
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
		Harvest(_source,part)
	end
end)


RegisterServerEvent('esx_vigneronjob:stopHarvest')
AddEventHandler('esx_vigneronjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, _U('cancel_action'))
	else
		TriggerClientEvent('esx:showNotification', _source, _U('can_collect'))
		PlayersHarvesting[_source]=true
	end
end)


local function Transform(source, part, CurrentTYpe)

    if PlayersTransforming[source] == true then

        local xPlayer  = ESX.GetPlayerFromId(source)
        if part == "Traitement" then
        	if CurrentTYpe == "jus_rouge" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinr').count
            	local itemQuantity2 = xPlayer.getInventoryItem('jus_raisin_rouge').count
            	if itemQuantity <= 4 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinr'))
                	return
            	elseif itemQuantity2 >= 50 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_jus_rouge'))
                	return
            	else
                	SetTimeout(3500, function()
                    	xPlayer.removeInventoryItem('raisinr', 5)
                    	xPlayer.addInventoryItem('jus_raisin_rouge', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            elseif CurrentTYpe == "jus_blanc" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinb').count
            	local itemQuantity2 = xPlayer.getInventoryItem('jus_raisin_blanc').count
            	if itemQuantity <= 4 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinb'))
                	return
            	elseif itemQuantity2 >= 50 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_jus_blanc'))
                	return
            	else
                	SetTimeout(3500, function()
                    	xPlayer.removeInventoryItem('raisinb', 5)
                    	xPlayer.addInventoryItem('jus_raisin_blanc', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            elseif CurrentTYpe == "vin_rouge" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinr').count
            	local itemQuantity2 = xPlayer.getInventoryItem('vin_rouge').count
            	if itemQuantity <= 9 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinr'))
                	return
            	elseif itemQuantity2 >= 35 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_vin_rouge'))
                	return
            	else
                	SetTimeout(7500, function()
                    	xPlayer.removeInventoryItem('raisinr', 10)
                    	xPlayer.addInventoryItem('vin_rouge', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            elseif CurrentTYpe == "vin_blanc" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinb').count
            	local itemQuantity2 = xPlayer.getInventoryItem('vin_blanc').count
            	if itemQuantity <= 9 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinb'))
                	return
            	elseif itemQuantity2 >= 35 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_vin_blanc'))
                	return
            	else
                	SetTimeout(7500, function()
                    	xPlayer.removeInventoryItem('raisinb', 10)
                    	xPlayer.addInventoryItem('vin_blanc', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            elseif CurrentTYpe == "champ" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinb').count
            	local itemQuantity2 = xPlayer.getInventoryItem('champagne').count
            	if itemQuantity <= 15 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinb'))
                	return
            	elseif itemQuantity2 >= 25 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_champ'))
                	return
            	else
                	SetTimeout(10000, function()
                    	xPlayer.removeInventoryItem('raisinb', 15)
                    	xPlayer.addInventoryItem('champagne', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            elseif CurrentTYpe == "cru" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinr').count
            	local itemQuantity2 = xPlayer.getInventoryItem('grand_cru').count
            	if itemQuantity <= 15 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinr'))
                	return
            	elseif itemQuantity2 >= 25 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_cru'))
                	return
            	else
                	SetTimeout(13500, function()
                    	xPlayer.removeInventoryItem('raisinr', 20)
                    	xPlayer.addInventoryItem('grand_cru', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            elseif CurrentTYpe == "golem" then
            	local itemQuantity = xPlayer.getInventoryItem('raisinb').count
            	local itemQuantity1 = xPlayer.getInventoryItem('raisinr').count
            	local itemQuantity2 = xPlayer.getInventoryItem('golem').count
            	if itemQuantity1 <= 9 and itemQuantity <= 24 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinb'))
                	return
                elseif itemQuantity1 <= 9 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinr'))
                	return
                elseif itemQuantity <= 24 then
                	TriggerClientEvent('esx:showNotification', source, _U('not_enough_raisinr'))
                	return
            	elseif itemQuantity2 >= 15 then
                	TriggerClientEvent('esx:showNotification', source, _U('to_enough_golem'))
                	return
            	else
                	SetTimeout(17500, function()
                    	xPlayer.removeInventoryItem('raisinb', 25)
                    	xPlayer.removeInventoryItem('raisinr', 10)
                    	xPlayer.addInventoryItem('golem', 1)

                    	Transform(source, part, CurrentTYpe)
                	end)
            	end
            end
        end
    end
end

RegisterServerEvent('esx_vigneronjob:startTransform')
AddEventHandler('esx_vigneronjob:startTransform', function(part, CurrentTYpe)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, _U('glitch'))
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,part,CurrentTYpe)
	end
end)

RegisterServerEvent('esx_vigneronjob:stopTransform')
AddEventHandler('esx_vigneronjob:stopTransform', function()

	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, _U('cancel_action'))
		
	else
		TriggerClientEvent('esx:showNotification', _source, _U('can_trans'))
		PlayersTransforming[_source]=true
		
	end
end)

local function Sell(source, part, CurrentTYpe)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if part == 'Revente' then
			if CurrentTYpe == 'jus_rouge' then
				if xPlayer.getInventoryItem('jus_raisin_rouge').count <= 0  then
					TriggerClientEvent('esx:showNotification', source, _U('no_j_r_sale'))
				
				else 
					SetTimeout(3500, function()
						local money = 50
						local ben = 5
						xPlayer.removeInventoryItem('jus_raisin_rouge', 1)
						local societyAccount = nil
						xPlayer.addMoney(ben)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_earned') ..' '.. ben ..' $')
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money-ben)
							
							--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money-ben)
						end
						Sell(source,part,CurrentTYpe)
					end)
				end
			elseif CurrentTYpe == 'jus_blanc' then
				if xPlayer.getInventoryItem('jus_raisin_blanc').count <= 0  then
					TriggerClientEvent('esx:showNotification', source, _U('no_j_b_sale'))
				
				else 
					SetTimeout(3500, function()
						local money = 60
						local ben = 6
						xPlayer.removeInventoryItem('jus_raisin_blanc', 1)
						local societyAccount = nil
						xPlayer.addMoney(ben)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_earned') ..' '.. ben ..' $')
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money-ben)
							
							--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money-ben)
						end
						Sell(source,part,CurrentTYpe)
					end)
				end
			elseif CurrentTYpe == 'vin_rouge' then
				if xPlayer.getInventoryItem('vin_rouge').count <= 0  then
					TriggerClientEvent('esx:showNotification', source, _U('no_v_r_sale'))
				
				else 
					SetTimeout(7500, function()
						local money = 100
						local ben = 10
						xPlayer.removeInventoryItem('vin_rouge', 1)
						local societyAccount = nil
						xPlayer.addMoney(ben)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_earned') ..' '.. ben ..' $')
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money-ben)
							
							--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money-ben)
						end
						Sell(source,part,CurrentTYpe)
					end)
				end
			elseif CurrentTYpe == 'vin_blanc' then
				if xPlayer.getInventoryItem('vin_blanc').count <= 0  then
					TriggerClientEvent('esx:showNotification', source, _U('no_v_b_sale'))
				
				else 
					SetTimeout(7500, function()
						local money = 120
						local ben = 12
						xPlayer.removeInventoryItem('vin_blanc', 1)
						local societyAccount = nil
						xPlayer.addMoney(ben)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_earned') ..' '.. ben ..' $')
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money-ben)
							
							--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money-ben)
						end
						Sell(source,part,CurrentTYpe)
					end)
				end
			elseif CurrentTYpe == 'champ' then
				if xPlayer.getInventoryItem('champagne').count <= 0  then
					TriggerClientEvent('esx:showNotification', source, _U('no_c_sale'))
				
				else 
					SetTimeout(10000, function()
						local money = 150
						local ben = 15
						xPlayer.removeInventoryItem('champagne', 1)
						local societyAccount = nil
						xPlayer.addMoney(ben)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_earned') ..' '.. ben ..' $')
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_vigne', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money-ben)
							
							--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money-ben)
						end
						Sell(source,part,CurrentTYpe)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_vigneronjob:startSell')
AddEventHandler('esx_vigneronjob:startSell', function(part, CurrentTYpe)

	local _source = source
	
	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, _U('glitch'))
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, part, CurrentTYpe)
	end

end)

RegisterServerEvent('esx_vigneronjob:stopSell')
AddEventHandler('esx_vigneronjob:stopSell', function()

	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, _U('cancel_action'))
		
	else
		TriggerClientEvent('esx:showNotification', _source, _U('can_sell'))
		PlayersSelling[_source]=true
	end

end)

-- système d'annonce
RegisterServerEvent('esx_vigneronjob:PayToAnnonces')
AddEventHandler('esx_vigneronjob:PayToAnnonces', function()
    
    local _source = source

        TriggerClientEvent('esx_vigneronjob:Annonces', _source) 
end)

RegisterServerEvent('esx_vigneronjob:Annonces')
AddEventHandler('esx_vigneronjob:Annonces', function(result)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local Players = ESX.GetPlayers()

    for i=1, #Players, 1 do
        TriggerClientEvent('esx_vigneronjob:ToAnnonces', Players[i], result)
    end
end)    