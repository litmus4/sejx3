local addon, ns = ...

local cfg = ns.cfg
local lib = ns.lib

-----------------------------
-- STYLE FUNCTIONS
-----------------------------

local bgMulti = 0.4

-- Hide Blizzard stuff
if cfg.hideRaidFrame then
	CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager:Hide()
end

if cfg.hideRaidFrameContainer then 
	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer:Hide()
end

if cfg.hideBuffFrame then
	BuffFrame:Hide()
end

if cfg.hideWeaponEnchants then
	TemporaryEnchantFrame:Hide()
end

-- Menus
local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")

UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if not unit then return end

	local menu, name, id
	if UnitIsUnit(unit, "player") then
		menu = "SELF"
	elseif UnitIsUnit(unit, "vehicle") then
		menu = "VEHICLE"
	elseif UnitIsUnit(unit, "pet") then
		menu = "PET"
	elseif UnitIsPlayer(unit) then
		id = UnitInRaid(unit)
		if id then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id)
		elseif UnitInParty(unit) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "TARGET"
		name = RAID_TARGET_ICON
	end
	if menu then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end, "MENU")

local menu = function(self)
	dropdown:SetParent(self)
	ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end

UnitSpecific = {
	player = function(self)
		-- unit specifics
		self.mystyle = "player"
		lib.addHealthBar(self)
		lib.addPowerBar(self)
		lib.addPortrait(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(200)
		self:SetHeight(43)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(200, 23)
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		self.Power:SetSize(200, 15)
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.3
		self.Power.frequentUpdates = true

		lib.addTextTags(self, 17)
		lib.ThreatBar(self)
		lib.Experience(self)
		lib.Reputation(self)
		lib.AltPowerBar(self)

		lib.addIcons(self)

		lib.addClassBar(self)

		-- Buffs and Debuffs
		if cfg.showPlayerBuffs then	lib.addBuffs(self, cfg.auras.BUFFPOSITIONS.player) end
		if cfg.showPlayerDebuffs then lib.addDebuffs(self,cfg.auras.DEBUFFPOSITIONS.player) end

		lib.addCastBar(self, true)

		-- Plugins
		lib.addCombatFeedback(self)
	end,

	target = function(self)
		-- unit specifics
		self.mystyle = "target"
		lib.addHealthBar(self)
		lib.addPowerBar(self)
		lib.addPortrait(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(200)
		self:SetHeight(43)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(200, 23)
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		self.Power:SetSize(200, 15)
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorHappiness = false
		self.Power.colorReaction = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.3

		lib.addTextTags(self, 17)

		lib.addIcons(self)

		-- Buffs and Debuffs
		if cfg.showTargetBuffs then	lib.addBuffs(self, cfg.auras.BUFFPOSITIONS.target) end
		if cfg.showTargetDebuffs then lib.addDebuffs(self,cfg.auras.DEBUFFPOSITIONS.target) end

		lib.addCastBar(self, true)

		-- Plugins
		lib.addCombatFeedback(self)
	end,

	pet = function(self)
		-- unit specifics
		self.mystyle = "pet"
		lib.addHealthBar(self)
		lib.addPowerBar(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(110)
		self:SetHeight(21)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(self:GetWidth(), self:GetHeight())
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 3)
		self.Power:SetSize(self:GetWidth()-7, 2)
		self.Power:SetStatusBarColor(1, 1, 1)
		self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

		lib.addTextTags(self, 12)

		lib.addIcons(self)

		-- Buffs and Debuffs
		if cfg.showPetBuffs then lib.addBuffs(self, cfg.auras.BUFFPOSITIONS.pet) end
		if cfg.showPetDebuffs then lib.addDebuffs(self,cfg.auras.DEBUFFPOSITIONS.pet) end

		lib.addCastBar(self, true)

	end,

	pettarget = function(self)
		-- unit specifics
		self.mystyle = "pettarget"
		lib.addHealthBar(self)
		lib.addPowerBar(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(80)
		self:SetHeight(21)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(self:GetWidth(), self:GetHeight())
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 3)
		self.Power:SetSize(self:GetWidth()-7, 2)
		self.Power:SetStatusBarColor(1, 1, 1)
		self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

		lib.addTextTags(self, 12)

		lib.addIcons(self)
	end,

	targettarget = function(self)
		-- unit specifics
		self.mystyle = "targettarget"
		lib.addHealthBar(self)
		lib.addPowerBar(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(110)
		self:SetHeight(21)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(self:GetWidth(), self:GetHeight())
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 3)
		self.Power:SetSize(self:GetWidth()-7, 2)
		self.Power:SetStatusBarColor(1, 1, 1)
		self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

		lib.addTextTags(self, 12)

		lib.addIcons(self)
	end,

	focus = function(self)
		-- unit specifics
		self.mystyle = "focus"
		lib.addHealthBar(self)
		lib.addPowerBar(self)
		lib.addPortrait(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(180)
		self:SetHeight(43)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(180, 23)
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		self.Power:SetSize(180, 15)
		self.Power.colorTapping = true
		self.Power.colorDisconnected = true
		self.Power.colorClass = true
		self.Power.bg.multiplier = 0.3
		self.Power.frequentUpdates = true

		lib.addTextTags(self, 17)

		lib.addIcons(self)

		-- Buffs and Debuffs
		if cfg.showFocusBuffs then	lib.addBuffs(self, cfg.auras.BUFFPOSITIONS.focus) end
		if cfg.showFocusDebuffs then lib.addDebuffs(self,cfg.auras.DEBUFFPOSITIONS.focus) end

		lib.addCastBar(self, true)
	end,

	focustarget = function(self)
		-- unit specifics
		self.mystyle = "focustarget"
		lib.addHealthBar(self)
		lib.addPowerBar(self)

		-- Set frame size
		self:SetScale(cfg.frameScale)
		self:SetWidth(80)
		self:SetHeight(21)

		-- Set statusbars specifics
		self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
		self.Health:SetSize(self:GetWidth(), self:GetHeight())
		self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
		self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

		self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 3)
		self.Power:SetSize(self:GetWidth()-7, 2)
		self.Power:SetStatusBarColor(1, 1, 1)
		self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

		lib.addTextTags(self, 12)

		lib.addIcons(self)
	end,
}

local Style = function(self, unit)
	-- Shared layout code
	self:RegisterForClicks('AnyUp')
	self.menu = menu
	self:SetAttribute("*type2", "menu")

	if UnitSpecific[unit] then
		return UnitSpecific[unit](self)
	end

end

local raidStyle = function(self, unit)
	self:RegisterForClicks('AnyUp')
	self.menu = menu
	self:SetAttribute("*type2", "menu")

	self.mystyle = "raid"
	lib.addHealthBar(self)
	lib.addPowerBar(self)

	self.Range = {
		insideAlpha = 1,
		outsideAlpha = .3,
	}

	self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
	self.Health:SetSize(self:GetWidth(), self:GetHeight())
	self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
	self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

	self.Health.frequentUpdates = true
	
	--self.Health.colorTapping = true
	--self.Health.colorDisconnected = true
	--self.Health.colorClass = true
	--self.Health.bg.multiplier = 0.3

	self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 2)
	self.Power:SetSize(self:GetWidth()-6, 2)
	self.Power:SetStatusBarColor(1, 1, 1)
	self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

	--self.Power.colorTapping = true
	--self.Power.colorDisconnected = true
	self.Power.colorClass = true
	--self.Power.colorPower = true
	self.Power.bg.multiplier = 0.3

	lib.addTextTags(self, 12)

	lib.addIcons(self)
	self.LFDRole:Hide()
	lib.addAuraWatch(self)
	lib.addDebuffHighlight(self)
	lib.raidDebuffs(self)

	-- Event hooks
	self:RegisterEvent('PLAYER_TARGET_CHANGED', lib.changedTarget)
	self:RegisterEvent('RAID_ROSTER_UPDATE', lib.changedTarget)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", lib.updateAggro)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", lib.updateAggro)
end

local bossStyle = function(self, unit, isSingle)
	self:RegisterForClicks('AnyUp')
	self.menu = menu
	self:SetAttribute("*type2", "menu")

	self.mystyle = "boss"
	lib.addHealthBar(self)
	lib.addPowerBar(self)
	self:SetScale(cfg.frameScale)
	self:SetSize(200, 21)

	self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
	self.Health:SetSize(self:GetWidth(), self:GetHeight())
	self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
	self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

	self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 3)
	self.Power:SetSize(self:GetWidth()-7, 2)
	self.Power:SetStatusBarColor(1, 1, 1)
	self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

	lib.addTextTags(self, 12)

	lib.addIcons(self)

	-- Buffs and Debuffs
	if cfg.showBossBuffs then	lib.addBuffs(self, cfg.auras.BUFFPOSITIONS.boss) end

	lib.addCastBar(self, true)

end

local function StyleForPartyPetTarget(self)
	lib.addHealthBar(self)
	lib.addPowerBar(self)

	-- Set frame size
	self:SetScale(cfg.frameScale)
	if self.mystyle == "partypet" then
		self:SetWidth(110)
	elseif self.mystyle == "partytarget" then
		self:SetWidth(75)
	end
	self:SetHeight(21)

	-- Set statusbars specifics
	self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
	self.Health:SetSize(self:GetWidth(), self:GetHeight())
	self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
	self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

	self.Power:SetPoint('BOTTOM', self, 'BOTTOM', 0, 3)
	self.Power:SetSize(self:GetWidth()-7, 2)
	self.Power:SetStatusBarColor(1, 1, 1)
	self.Power.bg:SetVertexColor(1, 1, 1, 0.6)

	lib.addTextTags(self, 12)

	lib.addIcons(self)

	-- Buffs and Debuffs
end

local partyStyle = function(self, unit)
	self:RegisterForClicks('AnyUp')
	self.menu = menu
	self:SetAttribute("*type2", "menu")
	-- unit specifics
	if self:GetAttribute("unitsuffix") == "pet" then
		self.mystyle = "partypet"
		StyleForPartyPetTarget(self)
		if cfg.showPartyPetDebuffs then lib.addDebuffs(self,cfg.auras.DEBUFFPOSITIONS.partypet) end
		return
	elseif self:GetAttribute("unitsuffix") == "target" then
		self.mystyle = "partytarget"
		StyleForPartyPetTarget(self)
		return
	else
		self.mystyle = "party"
	end

	lib.addHealthBar(self)
	lib.addPowerBar(self)
	lib.addPortrait(self)

	-- Set frame size
	self:SetScale(cfg.frameScale)
	self:SetWidth(180)
	self:SetHeight(43)

	-- Set statusbars specifics
	self.Health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
	self.Health:SetSize(180, 23)
	self.Health:SetStatusBarColor(unpack(cfg.healthBarColor))
	self.Health.bg:SetVertexColor(unpack(cfg.healthBgColor))

	self.Power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
	self.Power:SetSize(180, 15)
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorClass = true
	self.Power.bg.multiplier = 0.3
	self.Power.frequentUpdates = true

	lib.addTextTags(self, 17)
	lib.AltPowerBar(self)

	lib.addIcons(self)

	lib.addClassBar(self)

	-- Buffs and Debuffs
	lib.addBuffs(self, cfg.auras.BUFFPOSITIONS.party)
	lib.addDebuffs(self,cfg.auras.DEBUFFPOSITIONS.party)

	lib.addCastBar(self, true)

	-- Plugins
	lib.addCombatFeedback(self)

end
-----------------------------
-- SPAWN UNITS
-----------------------------

oUF:RegisterStyle('drk', Style)
oUF:RegisterStyle('drkParty', partyStyle)
oUF:RegisterStyle('drkRaid', raidStyle)
oUF:RegisterStyle('drkBoss', bossStyle)

oUF:Factory(function(self)
	-- Single Frames
	self:SetActiveStyle('drk')

	self:Spawn('player'):SetPoint("BOTTOMRIGHT", UIParent, cfg.playerRelativePoint, cfg.playerX, cfg.playerY)
	self:Spawn('target'):SetPoint("BOTTOMLEFT", UIParent, cfg.targetRelativePoint, cfg.targetX, cfg.targetY)
	if cfg.showTot then self:Spawn('targettarget'):SetPoint("TOPLEFT",oUF_drkTarget,"TOPRIGHT", 8, 0) end
	if cfg.showPet then self:Spawn('pet'):SetPoint("BOTTOMLEFT",oUF_drkPlayer,"TOPLEFT", 0, 8) end
	if cfg.showPetTarget then self:Spawn('pettarget'):SetPoint("BOTTOMRIGHT",oUF_drkPlayer,"TOPRIGHT", 0, 8) end
	if cfg.showFocus then self:Spawn('focus'):SetPoint("BOTTOMLEFT",oUF_drkPlayer,"TOPLEFT", 0, 136) end
	if cfg.showFocusTarget then self:Spawn('focustarget'):SetPoint("BOTTOMLEFT",oUF_drkPlayer,"TOPLEFT", 0, 108) end

	if cfg.showParty then
		self:SetActiveStyle('drkParty')
		local party = oUF:SpawnHeader("oUF_Party", nil, "custom [@raid6,exists] hide;show",
		"showParty", true, 
		"showPlayer", false, 
		"xOffset", 100,
		"yOffset", -100,
		--"point", "LEFT",
		"template", "oUF_Party"
		)
		party:SetPoint("TOPLEFT", UIParent, cfg.partyRelativePoint, cfg.partyX, cfg.partyY)
	end

	-- Raid/Party Frames
	if cfg.showRaid then
		self:SetActiveStyle('drkRaid')
		local raid = {}
		for i = 1, 8 do
			local raidgroup = self:SpawnHeader("oUF_Raid"..i, nil, "custom [@raid6,exists] show; hide",
			"groupFilter", tostring(i),
			"showRaid", true,
			"point", "LEFT",
			"xOffSet", 8,
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%d)
			self:SetHeight(%d)
			]]):format(72, 28))
			raid[i] = raidgroup
			if i == 1 then
				raidgroup:SetPoint("TOPLEFT", UIParent, cfg.raidRelativePoint, cfg.raidX, cfg.raidY)
			else
				raidgroup:SetPoint("TOPLEFT", raid[i-1], "BOTTOMLEFT", 0, -7)
			end
		end
	end

	-- Boss frames
	if cfg.showBossFrames then
		self:SetActiveStyle('drkBoss')
		local bossFrames = {}
		for i = 1, MAX_BOSS_FRAMES do
			local unit = self:Spawn('boss' .. i)
			if i > 1 then
				unit:SetPoint('TOPLEFT', bossFrames[i - 1], 'BOTTOMLEFT', 0, -8)
			else
				unit:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', cfg.bossX, cfg.bossY) 
			end
			bossFrames[i] = unit
		end
	end
end)
do
	UnitPopupMenus["SELF"] = {  "LOOT_METHOD", "LOOT_THRESHOLD", "OPT_OUT_LOOT_TITLE", "LOOT_PROMOTE", "DUNGEON_DIFFICULTY", "RAID_DIFFICULTY", "RESET_INSTANCES", "RAID_TARGET_ICON", "SELECT_ROLE", "LEAVE", "CANCEL" };
	UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "MUTE", "UNMUTE", "PARTY_SILENCE", "PARTY_UNSILENCE", "RAID_SILENCE", "RAID_UNSILENCE", "BATTLEGROUND_SILENCE", "BATTLEGROUND_UNSILENCE", "WHISPER", "PROMOTE", "PROMOTE_GUIDE", "LOOT_PROMOTE", "VOTE_TO_KICK", "UNINVITE", "INSPECT", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "SELECT_ROLE", "PVP_REPORT_AFK", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "ACHIEVEMENTS", "TRADE", "FOLLOW", "DUEL", "RAID_TARGET_ICON", "RAF_SUMMON", "RAF_GRANT_LEVEL", "CANCEL" }
	UnitPopupMenus["VEHICLE"] = { "RAID_TARGET_ICON", "VEHICLE_LEAVE", "CANCEL" }
	UnitPopupMenus["TARGET"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["ARENAENEMY"] = { "CANCEL" }
	UnitPopupMenus["FOCUS"] = { "RAID_TARGET_ICON", "CANCEL" }
	UnitPopupMenus["BOSS"] = { "RAID_TARGET_ICON", "CANCEL" }
end
