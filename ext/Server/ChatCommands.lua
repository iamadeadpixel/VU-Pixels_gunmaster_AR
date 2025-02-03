---@class ChatCommands
ChatCommands = class 'ChatCommands'

Events:Subscribe('Level:LoadingInfo', function(screenInfo)
	if screenInfo == "Running" or screenInfo == "Blocking on shader creation" or screenInfo == "Loading done" then
		print("*** GM Player Chat mod loaded ***");
	end
end)

-- This code is ripped from the ingameadmin mod
function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

-- ---

	--[[
	Here we start with the "real fun"
	]]
-- ---

Events:Subscribe('Player:Chat', function(player, recipientMask, message)
	if message == ".gm status" then


	if Config.serverowner ~= player.name then
		ChatManager:SendMessage("You dont have permissions " .. player.name, player)
				print("*** You dont have permissions "..player.name)

    elseif Config.serverowner == player.name then

	local preset_results = SQL:Query('SELECT gunMasterRotation, gunMasterWeaponsPreset FROM tbl_gmsettings')
	if not preset_results then
		print('Failed to read Guid query: ' .. SQL:Error())
		return
	end

	for _, l_Row in pairs(preset_results) do
		preset_rotation = l_Row["gunMasterRotation"]
		preset_GMpreset = l_Row["gunMasterWeaponsPreset"]
    end


	if preset_rotation == "start"  then
		ChatManager:SendMessage("GunMaster Rotation preset: Active", player)
				print("*** GunMaster Rotation preset: Active")
	end

	if preset_rotation == "stop"  then
		ChatManager:SendMessage("GunMaster Rotation preset: not active", player)
				print("*** GunMaster Rotation preset: not active")
	end


	if     preset_GMpreset == "0" then s_GMmessage = "Standard"
	elseif preset_GMpreset == "1" then s_GMmessage = "Standard reversed"
	elseif preset_GMpreset == "2" then s_GMmessage = "Light weight"
	elseif preset_GMpreset == "3" then s_GMmessage = "Heavy gear"
	elseif preset_GMpreset == "4" then s_GMmessage = "Pistol run"
	elseif preset_GMpreset == "5" then s_GMmessage = "Snipers heaven"
	elseif preset_GMpreset == "6" then s_GMmessage = "US arms race"
	elseif preset_GMpreset == "7" then s_GMmessage = "RU arms race"
	elseif preset_GMpreset == "8" then s_GMmessage = "EU arms race"
	end


print ("Set this preset in DB:"..preset_GMpreset)
		ChatManager:SendMessage("GunMaster preset: ("..preset_GMpreset.."):"..s_GMmessage)

end
end
end)

-- ---

Events:Subscribe('Player:Chat', function(player, recipientMask, message)
-- This code is ripped from the ingameadmin mod
	if message == '' or player == nil then
		return
	end

	
	-- split the message into parts
	local s_Parts = message:split(' ')
	
	-- check if the first key is not a "!"
	if s_Parts[1]:sub(1,1) ~= "." then
		return
	end
	-- only if it starts with "." we go on

	if s_Parts[1] == '.gm' and s_Parts[2] == 'preset' then

	if Config.serverowner ~= player.name then
		ChatManager:SendMessage("You dont have permissions " .. player.name, player)
				print("*** You dont have permissions "..player.name)

    elseif Config.serverowner == player.name then

	local preset_results = SQL:Query('SELECT gunMasterRotation, gunMasterWeaponsPreset FROM tbl_gmsettings')
	if not preset_results then
		print('Failed to read Guid query: ' .. SQL:Error())
		return
	end

	for _, l_Row in pairs(preset_results) do
		preset_rotation = l_Row["gunMasterRotation"]
		preset_GMpreset = l_Row["gunMasterWeaponsPreset"]
    end

	if s_Parts[3] == nil then
	  ChatManager:SendMessage("Error: We need a value here ( 0-8)", player)
			   print ("Error: We need a value here ( 0-8)")
		end

	if preset_GMpreset == s_Parts[3] then 
	print ("Preset ("..preset_GMpreset..") already set !")
	ChatManager:SendMessage("Preset ("..preset_GMpreset..") already set !", player)
	end

	if preset_GMpreset ~= s_Parts[3] then 

	if s_Parts[3] == nil then return end -- if we dont use this when no value is given, the stuff below will gives a error message
	if s_Parts[3] == "0" or s_Parts[3] == "1" or s_Parts[3] == "2"
	or s_Parts[3] == "3" or s_Parts[3] == "4" or s_Parts[3] == "5"
	or s_Parts[3] == "6" or s_Parts[3] == "7" or s_Parts[3] == "8" then

			  print("Updating table tbl_gmsettings with new preset")

		if not SQL:Query('UPDATE tbl_gmsettings SET gunMasterWeaponsPreset = ? ', s_Parts[3]) then
			print('Failed to execute name change for "..value.." query: ' .. SQL:Error())
			return end
-- Here we set the new GM preset
	RCON:SendCommand('vars.gunMasterWeaponsPreset', { tostring(s_Parts[3]) }) 

	if     s_Parts[3] == "0" then s_GMmessage = "Standard"
	elseif s_Parts[3] == "1" then s_GMmessage = "Standard reversed"
	elseif s_Parts[3] == "2" then s_GMmessage = "Light weight"
	elseif s_Parts[3] == "3" then s_GMmessage = "Heavy gear"
	elseif s_Parts[3] == "4" then s_GMmessage = "Pistol run"
	elseif s_Parts[3] == "5" then s_GMmessage = "Snipers heaven"
	elseif s_Parts[3] == "6" then s_GMmessage = "US arms race"
	elseif s_Parts[3] == "7" then s_GMmessage = "RU arms race"
	elseif s_Parts[3] == "8" then s_GMmessage = "EU arms race"
	end

				print  ("Gun Master preset set to "..s_Parts[3])
		ChatManager:SendMessage("Gun Master preset set to ("..s_Parts[3].."):"..s_GMmessage)

		else
			   print ("no matching preset found")
	  ChatManager:SendMessage("no matching preset found", player)


return end

end
end
end
end)

-- ---

-- Here start the rotation and do a check first

Events:Subscribe('Player:Chat', function(player, recipientMask, message)
-- This code is ripped from the ingameadmin mod
	if message == '' or player == nil then
		return
	end

	
	-- split the message into parts
	local s_Parts = message:split(' ')
	
	-- check if the first key is not a "!"
	if s_Parts[1]:sub(1,1) ~= "." then
		return
	end
	-- only if it starts with "." we go on

	if s_Parts[1] == '.gm' and s_Parts[2] == 'rotation' then

	if Config.serverowner ~= player.name then
		ChatManager:SendMessage("You dont have permissions " .. player.name, player)
				print("*** You dont have permissions "..player.name)

    elseif Config.serverowner == player.name then

	if s_Parts[3] == nil then
	  ChatManager:SendMessage("Error: We need a value here ( start / stop )", player)
			   print ("Error: We need a value here ( start / stop )")
		end
	
	if s_Parts[3] == nil then return end -- if we dont use this when no value is given, the stuff below will gives a error message
	if s_Parts[3] == "start" then
	rotationpreset = "start"

	local preset_results = SQL:Query('SELECT gunMasterRotation FROM tbl_gmsettings')
	if not preset_results then
		print('Failed to read Guid query: ' .. SQL:Error())
		return
	end

	for _, l_Row in pairs(preset_results) do
		preset_rotation = l_Row["gunMasterRotation"]
    end

		if preset_rotation == "start"  then
		ChatManager:SendMessage("Rotation already started", player)
				print("*** Rotation already started")

		elseif preset_rotation == "stop"  then
		ChatManager:SendMessage("Starting GunMaster Rotation", player)
				print("*** Starting GunMaster Rotation")

			   print ("Starting GunMaster preset rotation ")
	  ChatManager:SendMessage("Starting GunMaster preset rotation ", player)

			  print("Updating table tbl_gmsettings with start preset")

		if not SQL:Query('UPDATE tbl_gmsettings SET gunMasterRotation = ? ', rotationpreset) then
			print('Failed to execute name change for "..value.." query: ' .. SQL:Error())
			return end

return end

end
end
end
end)

-- ------------------------

-- Here stop the rotation and do a check first
Events:Subscribe('Player:Chat', function(player, recipientMask, message)
-- This code is ripped from the ingameadmin mod
	if message == '' or player == nil then
		return
	end
	
	-- split the message into parts
	local s_Parts = message:split(' ')
	
	-- check if the first key is not a "!"
	if s_Parts[1]:sub(1,1) ~= "." then
		return
	end
	-- only if it starts with "." we go on

	if s_Parts[1] == '.gm' and s_Parts[2] == 'rotation' then

	if Config.serverowner ~= player.name then
		ChatManager:SendMessage("You dont have permissions " .. player.name, player)
				print("*** You dont have permissions "..player.name)

    elseif Config.serverowner == player.name then

	if s_Parts[3] == nil then
		end
	
	if s_Parts[3] == nil then return end -- if we dont use this when no value is given, the stuff below will gives a error message
	if s_Parts[3] == "stop" then
	rotationpreset = "stop"

	local preset_results = SQL:Query('SELECT gunMasterRotation FROM tbl_gmsettings')
	if not preset_results then
		print('Failed to read Guid query: ' .. SQL:Error())
		return
	end

	for _, l_Row in pairs(preset_results) do
		preset_rotation = l_Row["gunMasterRotation"]
    end

		if preset_rotation == "stop"  then
		ChatManager:SendMessage("Rotation already stopped", player)
				print("*** Rotation already stopped")

		elseif preset_rotation == "start"  then
		ChatManager:SendMessage("stopping GunMaster Rotation", player)
				print("*** stopping GunMaster Rotation")

			   print ("Stopping GunMaster preset rotation ")
	  ChatManager:SendMessage("Stopping GunMaster preset rotation ", player)

			  print("Updating table tbl_gmsettings with stop preset")

		if not SQL:Query('UPDATE tbl_gmsettings SET gunMasterRotation = ? ', rotationpreset) then
			print('Failed to execute name change for "..value.." query: ' .. SQL:Error())
			return end

return end

end
end
end
end)


-- ------------------------
return ChatCommands()
