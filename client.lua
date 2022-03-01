AddEventHandler("playerLoaded", function()
	TriggerServerEvent( "playerLoaded")
end)

Citizen.CreateThread(function()
	while true do
		if NetworkIsSessionStarted() then
			TriggerEvent('playerLoaded')
			return
		end
	end
end )