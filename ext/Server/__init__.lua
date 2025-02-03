---@class init
init = class 'init'

function init:__init()
	Events:Subscribe('Extension:Loaded', self, self.OnExtensionLoaded)
end

function init:OnExtensionLoaded()
	print("Initializing init")
	self.m_HotReloadTimer = 0
	self.m_IsHotReload = self:GetIsHotReload()
	self:RegisterEvents()
end

function init:RegisterEvents()
	Events:Subscribe('Engine:Init', self, self.OnEngineInit)
	Events:Subscribe('Level:Destroy', self, self.OnLevelDestroy)
end

function init:OnEngineInit()
	self.m_config = require 'config'
	self.m_ChatCommands = require 'ChatCommands'
	self.m_DatabaseSetup = require 'DatabaseSetup'
	self.m_Roundover = require 'Roundover' -- Most of the magic happens here
end

function init:OnLevelDestroy()

local s_OldMemory = math.floor(collectgarbage("count")/1024)
	collectgarbage('collect')
	print("*Collecting Garbage on Level Destroy: " .. math.floor(collectgarbage("count")/1024) .. " MB | Old Memory: " .. s_OldMemory .. " MB")
end

function init:GetIsHotReload()
	if #SharedUtils:GetContentPackages() == 0 then
		return false
	else
		return true
	end
end

init()

--[[

]]