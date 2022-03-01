local staff = {}
local es = {}

RegisterServerEvent('playerLoaded')
AddEventHandler('playerLoaded', function()
	local player = GetPlayerIdentifiers(source)[1]
	
	if IsPlayerAceAllowed(source, config.staffAcePerm) then
		table.insert(staff, source)
	end

	if config.esAceRequired == false then 
		table.insert(es, source)
	else
		if IsPlayerAceAllowed(source, config.esAcePerm) then
			table.insert(es, source)
		end
	end
end)

RegisterCommand(config.staffChatCommand, function(source, args)
	if IsPlayerAceAllowed(source, config.staffAcePerm) then
	local msg = table.concat(args, ' ')
	local name = GetPlayerName(source)..":"

		if config.useWebhook == true then
			sendToDiscord(source, config.staffChatCommand, msg, name, 15990528)
		end

		for _,id in ipairs(staff) do
			TriggerClientEvent('chat:addMessage', id, { args = {"^3^*STAFF | " .. name .. '^0 ' .. msg}})
		end
	end
end)


RegisterCommand(config.esChatCommand, function(source, args)
	if IsPlayerAceAllowed(source, config.esAcePerm) then
	local msg = table.concat(args, ' ')
	local name = GetPlayerName(source)..":"

		if config.useWebhook == true then
			sendToDiscord(source, config.esChatCommand, msg, name, 64511)
		end

		for _,id in ipairs(es) do
			TriggerClientEvent('chat:addMessage', id, { args = {"^4^*ES | " .. name .. '^0 ' .. msg}})
			CancelEvent()
		end
	end
end)




function GetDiscordUserTag(source)
	local identifiers = {}
	local identifierCount = GetNumPlayerIdentifiers(source)
		for a = 0, identifierCount do
			table.insert(identifiers, GetPlayerIdentifier(source, a))
		end
		for b = 1, #identifiers do
		if string.find(identifiers[b], "discord", 1) then
			local discordIdentifier = identifiers[b]
			local splitId = string.gsub(discordIdentifier, "discord:", "")
			return "<@"..splitId..">"
		end
	end
	return "Discord not found"
end
  
function sendToDiscord(source, command, msg, name, color)
	local content = {
		{
			["color"] = color,
			["fields"] = {
				{
					["name"] = "**Player Name:**",
					["value"] = name,
					["inline"] = true
				},{
					["name"] = "**Discord:**",
					["value"] = GetDiscordUserTag(source),
					["inline"] = true
				},{
					["name"] = "**Message:**",
					["value"] = '/' .. command .. ' ' .. msg,
					["inline"] = false
				}
			}
		}
	}
	PerformHttpRequest(config.webhook, function(err) end, 'POST', json.encode({username = name..' [ID:'..source..']',embeds = content}), { ['Content-Type'] = 'application/json' })
end
