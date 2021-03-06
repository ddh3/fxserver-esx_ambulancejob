ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	TriggerClientEvent('esx_ambulancejob:revive', target)
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		xPlayer.set('money', 0)
		xPlayer.setAccountMoney('black_money', 0)
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	end

	cb()

end)

TriggerEvent('esx_phone:registerCallback', function(source, phoneNumber, message, anon)

	local xPlayer  = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

	if phoneNumber == 'ambulance' then
		for k, v in pairs(xPlayers) do
			if v.job.name == 'ambulance' then
				TriggerEvent('esx_phone:getDistpatchRequestId', function(requestId)
					TriggerClientEvent('esx_phone:onMessage', v.source, xPlayer.get('phoneNumber'), message, xPlayer.get('coords'), anon, 'Alerte Ambulance', requestId)
				end)
			end
		end
	end
	
end)