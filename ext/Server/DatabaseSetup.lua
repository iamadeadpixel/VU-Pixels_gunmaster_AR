---@class DBsetup
DBsetup = class 'DBsetup'

Events:Subscribe('Level:LoadingInfo', function(screenInfo)
	if screenInfo == "Running" or screenInfo == "Blocking on shader creation" then
		print("*** GM DataBase Setup mod loaded ***");
		local syncedBFSettings = ResourceManager:GetSettings("SyncedBFSettings")
		if syncedBFSettings ~= nil then
			syncedBFSettings = SyncedBFSettings(syncedBFSettings)
			syncedBFSettings.teamSwitchingAllowed = false
		end
	end
end)


Events:Subscribe('Level:LoadResources', function(p_IsDedicatedServer)
	if not SQL:Open() then return end

	local s_Results = SQL:Query('SELECT * FROM tbl_gmsettings')
	if not s_Results then
		print("*** Creating Table: 'tbl_gmsettings' ***")
		s_Query = [[
	CREATE TABLE IF NOT EXISTS `tbl_gmsettings` (
	`gunMasterRotation` TEXT,
	`gunMasterWeaponsPreset` TEXT,
	`gunMasterWeaponsPresetDB` TEXT
	);
		]]

		if not SQL:Query(s_Query) then
			print('Failed to execute query for tbl_gmsettings Table: ' .. SQL:Error())
			return
		end


	local s_GMsettingsRCON = RCON:SendCommand('vars.gunMasterWeaponsPreset')
	local s_GMsettings = tostring(s_GMsettingsRCON[2])


--[[
On creating: it reads the gunmasterpreset what is written in the startup.txt, and writes it as the default config...
this wil be updated when a round ends (gunmaster gamemode that is)
]]

		s_Query ='INSERT INTO tbl_gmsettings  (gunMasterRotation, gunMasterWeaponsPreset, gunMasterWeaponsPresetDB) VALUES (?,?,?)'
				if not SQL:Query(s_Query,   "stop",            s_GMsettings,            s_GMsettings) then
			print('Failed to execute query: ' .. SQL:Error())
			return
		end
		print("*** Inserting Table entries: 'tbl_gmsettings' ***")
	end


	print("*** GunMaster DATABASE INIT COMPLETE ***")

end)

return DBsetup()
