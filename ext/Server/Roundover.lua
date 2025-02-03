-- Spaghetti code by iamadeadpixel

---@class Roundover
Roundover = class 'Roundover'

Events:Subscribe('Level:LoadingInfo', function(screenInfo)
	if screenInfo == "Running" or screenInfo == "Blocking on shader creation" or screenInfo == "Loading done" then
		print("*** Roundover mod loaded ***");
	end
end)

Events:Subscribe('Server:RoundOver', function(roundTime, winningTeam)

--	gunMasterRotation
--	gunMasterWeaponsPreset
--	gunMasterWeaponsPresetDB

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
	do
	GetNextGameModeName()
	end

print ("Found this preset in DB:"..preset_GMpreset)

	if s_GetNextGameModeName == "GunMaster0" then
	s_MapData= "Roundover GunMaster information"

-- Here we set the new GM preset

	if preset_GMpreset == "8" then rotationpreset = 0 print ("Resetting preset to 0")
	else 
		rotationpreset = preset_GMpreset + 1 ; print ("Increasing GM preset from "..preset_GMpreset.." to "..rotationpreset)
	end

		if not SQL:Query('UPDATE tbl_gmsettings SET gunMasterWeaponsPreset = ? ', rotationpreset) then
			print('Failed to execute name change for "..value.." query: ' .. SQL:Error())
			return end

	RCON:SendCommand('vars.gunMasterWeaponsPreset', { tostring(rotationpreset) }) 

	if     rotationpreset == 0 then s_GMmessage = "Standard"
	elseif rotationpreset == 1 then s_GMmessage = "Standard reversed"
	elseif rotationpreset == 2 then s_GMmessage = "Light weight"
	elseif rotationpreset == 3 then s_GMmessage = "Heavy gear"
	elseif rotationpreset == 4 then s_GMmessage = "Pistol run"
	elseif rotationpreset == 5 then s_GMmessage = "Snipers heaven"
	elseif rotationpreset == 6 then s_GMmessage = "US arms race"
	elseif rotationpreset == 7 then s_GMmessage = "RU arms race"
	elseif rotationpreset == 8 then s_GMmessage = "EU arms race"
	end


print ("Set this preset in DB:"..rotationpreset)
		ChatManager:SendMessage("GunMaster preset: ("..rotationpreset.."):"..s_GMmessage)

end
end

end)

function GetNextGameModeName()
	local s_LevelList = RCON:SendCommand('mapList.list')
	local s_NextLevelIndex = RCON:SendCommand('mapList.getMapIndices')
	local s_NextGameModeName = (s_NextLevelIndex[3] + 1) * 3 + 2
	s_GetNextGameModeName = (s_LevelList[s_NextGameModeName])
	return s_LevelList[s_NextGameModeName]
end

return Roundover()
