-----------------------------
--| oUF_Drk
--| by Drakull (2010)
-----------------------------
-- INIT
-----------------------------

local addon, ns = ...
local cfg = ns.cfg
local cast = ns.cast
local lib = CreateFrame("Frame")  

local _, playerClass = UnitClass("player")

-----------------------------
-- FUNCTIONS
-----------------------------
-- pixel perfect script of custom ui scale.

local retVal = function(self, val1, val2, val3)
	if self.mystyle == "player" or self.mystyle == "party" or self.mystyle == "target" or self.mystyle == "focus"  then
		return val1
	elseif self.mystyle == "raid" then
		return val3
	else
		return val2
	end
end

local setFont = function(object, font, size, outline, shadow)
	local fs = object:CreateFontString(nil, "OVERLAY")
	fs:SetFont(font, size, outline)
	fs:SetShadowColor(0,0,0,0.8)
	fs:SetShadowOffset(shadow, shadow*(-1))
	return fs
end
local shadows = {
	edgeFile = "Interface\\AddOns\\oUF_Drk\\media\\glowTex", 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
function CreateShadowww(f, frameLevel)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(frameLevel)
	shadow:SetPoint("TOPLEFT", -6, 6)
	shadow:SetPoint("BOTTOMRIGHT", 6, -6)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	return shadow
end
local createBGFrame = function(anchorFrame, frameLevel, outset)
	if not outset then
		outset = 5
	end
	local hintFrame = CreateFrame("Frame", nil, anchorFrame)
	hintFrame:SetPoint("TOPLEFT", -2, 2)
	hintFrame:SetPoint("BOTTOMRIGHT", 2, -2)
	hintFrame:SetFrameLevel(frameLevel)

	local backdrop_tab = { 
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		tile = false,
		tileSize = 0, 
		edgeSize = 1, 
		insets = { 
			left = 1, 
			right = 1, 
			top = 1, 
			bottom = 1,
		},
	}

	hintFrame:SetBackdrop(backdrop_tab);
	hintFrame:SetBackdropColor(0,0,0,1)
	hintFrame:SetBackdropBorderColor(.2,.2,.2,1)
	return hintFrame
end
do
	UpdateReputationColor = function(self, event, unit, bar)
		local name, id = GetWatchedFactionInfo()
		bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
	end
end
function AltPowerBarOnToggle(self)
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
	if unit == nil or unit ~= "player" then return end
end
function AltPowerBarPostUpdate(self, min, cur, max)
	local perc = math.floor((cur/max)*100)

	if perc < 35 then
		self:SetStatusBarColor(0, 1, 0)
	elseif perc < 70 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end

	local unit = self:GetParent().unit or self:GetParent():GetParent().unit

	if unit == nil or unit ~= "player" then return end --Only want to see this on the players bar

	local type = select(10, UnitAlternatePowerInfo(unit))

	if self.text and perc > 0 then
		self.text:SetText(type..": ".."|cFF00A2FF"..format("%d%%", perc))
	elseif self.text then
		self.text:SetText(type..": ".."|cFF00A2FF".."0%")
	end
end	
-- Health bar function
local postUpdateHealth = function(Health, unit, min, max)

	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)

	Health:SetStatusBarColor(unpack(cfg.healthBarColor))

	if disconnnected or dead or ghost then
		Health:SetValue(max)

		if(disconnnected) then
			Health:SetStatusBarColor(0.1, 0.1, 0.1)
		elseif(ghost) then
			Health:SetStatusBarColor(1, 1, 1)
		elseif(dead) then
			Health:SetStatusBarColor(0.9, 0, 0)
		end
	else
		Health:SetValue(min)
		if(unit == "vehicle") then
			Health:SetStatusBarColor(22/255, 106/255, 44/255)
		end
	end
	Health.bg:SetAlpha(Health:GetAlpha())
end

local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	self.Highlight:Show()

	if self.mystyle == "raid" then
		if UnitAffectingCombat("player") then
			GameTooltip:Hide()
		end
		if self.LFDRole then 
			self.LFDRole:SetAlpha(1)
		end
	end
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Highlight:Hide()

	if self.mystyle == "raid" then
		if self.LFDRole then 
			self.LFDRole:SetAlpha(0)
		end
	end
end

lib.addHealthBar = function(self)
	local health = CreateFrame("StatusBar", nil, self)
	health:SetStatusBarTexture(cfg.statusBarTexture)
	health:GetStatusBarTexture():SetHorizTile(true)
	health:SetFrameLevel(1)

	local healthBG = health:CreateTexture(nil, "BACKGROUND", nil, -7)
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(cfg.statusBarTexture)
	health.bg = healthBG

	local bgoverlay = health:CreateTexture(nil, "BACKGROUND", nil, -6)
	bgoverlay:SetPoint("TOPLEFT", health,"TOPLEFT", 0, 0)
	bgoverlay:SetPoint("BOTTOMRIGHT", health,"BOTTOMRIGHT", 0, 0)
	bgoverlay:SetTexture(cfg.portraitOverlayTexture)
	bgoverlay:SetVertexColor(0, 0, 0, 0.8)

	self.Health = health
	if self.mystyle == "raid" then
		self.Health.PostUpdate = lib.postUpdateHealth
	else
		self.Health.Smooth = cfg.smoothHealth
	end

	createBGFrame(self.Health, 0)
	CreateShadowww(self.Health, 1)
	-- Mouseover highlight
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)

	local hl = self.Health:CreateTexture(nil, "OVERLAY")
	hl:SetAllPoints(self.Health)
	hl:SetTexture(cfg.highlightTexture)
	hl:SetVertexColor(.5,.5,.5,.1)
	hl:SetBlendMode("ADD")
	hl:Hide()
	self.Highlight = hl

	-- Heal Prediction
	if cfg.ShowIncHeals and (self.mystyle == "player" or self.mystyle == "party" or self.mystyle == "raid" or self.mystyle == "focus") then
		mhpb = CreateFrame("StatusBar", nil, self.Health)
		mhpb:SetWidth(self:GetWidth())
		mhpb:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT")
		mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT")
		mhpb:SetStatusBarTexture(cfg.statusBarTexture)
		mhpb:SetStatusBarColor(1, 1, 1, 0.4)
		mhpb:SetFrameLevel(1)

		ohpb = CreateFrame("StatusBar", nil, self.Health)
		ohpb:SetWidth(self:GetWidth())
		ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT")
		ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT")
		ohpb:SetStatusBarTexture(cfg.statusBarTexture)
		ohpb:SetStatusBarColor(1, 1, 1, 0.4)
		ohpb:SetFrameLevel(1)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end

	-- Target and aggro borders
	if self.mystyle == "raid" then
		local borderTexture = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}
		-- Target border
		self.targetBorder = CreateFrame("Frame", nil, self)
		self.targetBorder:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
		self.targetBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
		self.targetBorder:SetBackdrop(borderTexture)
		self.targetBorder:SetFrameLevel(1)
		self.targetBorder:SetBackdropBorderColor(.7,.7,.7,1)
		self.targetBorder:Hide()

		-- Aggro border
		self.aggroBorder = CreateFrame("Frame", nil, self)
		self.aggroBorder:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
		self.aggroBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
		self.aggroBorder:SetBackdrop(borderTexture)
		self.aggroBorder:SetFrameLevel(1)
		self.aggroBorder:Hide()	
	end
end

-- Power bar function
local postUpdatePower = function(power, unit, min, max)
	power.Spark:SetPoint("CENTER", power, "LEFT", ((min / max) * power:GetWidth())-1, 0)
	local perc = min * 100 / max
	if perc < 3 or perc == 100 then
		power.Spark:Hide()
	else
		power.Spark:Show()
	end
end

lib.addPowerBar = function(self)
	local power = CreateFrame("StatusBar", nil, self)
	power:SetStatusBarTexture(cfg.powerBarTexture)
	power:GetStatusBarTexture():SetHorizTile(true)
	power:SetFrameLevel(1)

	local powerBG = power:CreateTexture(nil, "BORDER")
	powerBG:SetAllPoints(power)
	powerBG:SetTexture(cfg.powerBarTexture)
	power.bg = powerBG	

	self.Power = power
	if self.mystyle == "player" then self.Power.Smooth = cfg.smoothPower end

	if self.mystyle ~= "player" and self.mystyle ~= "target" and self.mystyle ~= "party" and self.mystyle ~= "focus" then
		self.Power:SetAlpha(0.5)
		self.Power:SetFrameLevel(2)
		self.Power:SetStatusBarTexture(cfg.backdropTexture)
		self.Power.bg:SetTexture(1, 1, 1, 0.5)

		-- Power Spark
		sp = self.Power:CreateTexture(nil, "OVERLAY")
		sp:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]] 
		sp:SetBlendMode("ADD")
		sp:SetAlpha(0.8)
		sp:SetHeight(7)
		sp:SetPoint("CENTER", power, "RIGHT", -1, 0)

		self.Power.Spark = sp
		self.Power.PostUpdate = postUpdatePower
	else
		createBGFrame(self.Power, 0)
		CreateShadowww(self.Power, 0)
	end
end

-- Portrait
local postUpdatePortrait = function(element, unit)
	if unit == "target" then
		if not UnitExists(unit) or not UnitIsConnected(unit) or not UnitIsVisible(unit) then
			element:Hide()
		else
			element:Show()
			element:SetCamera(0)
		end
	end
end

lib.addPortrait = function(self)
	local p = CreateFrame("PlayerModel", nil, self)
	if self.mystyle == "party" or self.mystyle == "focus" then
		p:SetSize(130, 15)
	else
		p:SetSize(150, 15)
	end
	p:SetFrameLevel(4)
	p:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 6, 10)

	local darkoverlay = p:CreateTexture(nil, "OVERLAY")
	darkoverlay:SetPoint("TOPLEFT", p,"TOPLEFT", 0, 0)
	darkoverlay:SetPoint("BOTTOMRIGHT", p,"BOTTOMRIGHT", 0, 0)
	darkoverlay:SetTexture(cfg.debuffHighlightTexture)
	darkoverlay:SetVertexColor(0, 0, 0, 0.4)

	local bg = p:CreateTexture(nil, "OVERLAY")
	bg:SetPoint("TOPLEFT", p,"TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", p,"BOTTOMRIGHT", 0, 0)
	bg:SetTexture(cfg.portraitBGTexture)
	bg:SetVertexColor(0, 0, 0, 0.4)

	local overlay = p:CreateTexture(nil, "OVERLAY")
	overlay:SetPoint("TOPLEFT", p,"TOPLEFT", 0, 0)
	overlay:SetPoint("BOTTOMRIGHT", p,"BOTTOMRIGHT", 0, 0)
	overlay:SetTexture(cfg.portraitOverlayTexture)
	overlay:SetVertexColor(0, 0, 0, 1)

	createBGFrame(p, 3)
	CreateShadowww(p, 4)

	self.Portrait = p
	self.Portrait.PostUpdate = postUpdatePortrait
	self.Portrait:SetPortraitZoom(1) 
	self.Portrait:SetPortraitZoom(.98)
end

-- Target border
lib.changedTarget = function(self, event, unit)
	if UnitIsUnit("target", self.unit) then
		self.targetBorder:Show()
	else
		self.targetBorder:Hide()
	end
end

-- Aggro border
lib.updateAggro = function(self, event, unit)
	if (self.unit ~= unit) then return end

	local status = UnitThreatSituation(unit)
	unit = unit or self.unit

	if status and status > 1 then
		local r, g, b = GetThreatStatusColor(status)
		self.aggroBorder:Show()
		self.aggroBorder:SetBackdropBorderColor(r, g, b, 1)
	else
		self.aggroBorder:SetBackdropBorderColor(r, g, b, 0)
		self.aggroBorder:Hide()
	end
end

-- Text Tags
lib.addTextTags = function(self, fontsize)
	local hp = setFont(self.Health, cfg.font, 12, "OUTLINE", retVal(self,2,1,1))
	hp:SetPoint("TOPRIGHT", self.Health, "TOPRIGHT", retVal(self,0,-1,-1), retVal(self,-1,-1,-11))
	hp:SetJustifyH("RIGHT")
	if self.mystyle ~= "partytarget" then
		self:Tag(hp, retVal(self, "[drk:hp]", "[drk:hp]", "[drk:raidhp]"))
	end
	local name = setFont(self.Health, cfg.font, 12, "OUTLINE", retVal(self,2,1,1))
	if self.mystyle == "raid" then
		name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 2, 0)
	elseif self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
		name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 2, -1)
		local mp = setFont(self.Power, cfg.font, 12, "OUTLINE", retVal(self,2,1,1))
		mp:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", 3, 2)
		mp:SetJustifyH("RIGHT")
		self:Tag(mp, "[drk:color][drk:mp]")
	else
		name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 2, -3)
	end


	name:SetJustifyH("LEFT")
	if self.mystyle == "targettarget" or self.mystyle == "focustarget" or self.mystyle == "partypet" or self.mystyle == "partytarget" then
		name:SetPoint("TOPLEFT", self.Health, "TOPLEFT", 2, -1)
	end
	if self.mystyle == "raid" then
		name:SetPoint("RIGHT", self, "RIGHT", -1, 0)
	else
		name:SetPoint("RIGHT", hp, "LEFT", 0, 0)
	end

	if  self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
		self:Tag(name, "[drk:level] [drk:color][name][drk:afkdnd]")
	else
		self:Tag(name, "[drk:color][name]")
	end

	if ((playerClass == "ROGUE" or playerClass == "DRUID")) and self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
		local CPoints = setFont(self.Portrait, cfg.font, 25, "OUTLINE", 0)
		CPoints:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
		CPoints:SetJustifyH("CENTER")
		CPoints:SetAlpha(0.6)
		self:Tag(CPoints, "[myComboPoints]")
		if(playerClass == "ROGUE") then
			local DPTracker = setFont(self.Portrait, cfg.font, 11, "OUTLINE", 0)
			DPTracker:SetPoint("BOTTOMLEFT", CPoints, "TOPRIGHT",0,-13)
			DPTracker:SetJustifyH("CENTER")
			DPTracker:SetAlpha(0.6)
			DPTracker:SetShadowOffset(1, -1)
			self:Tag(DPTracker, "[myDeadlyPoison]")
		end			
	end
end

-- Frame Icons
lib.addIcons = function(self)
	-- common stuff
	local hintFrame = CreateFrame("Frame", nil, self)
	hintFrame:SetAllPoints(self)
	hintFrame:SetFrameLevel(10)
	hintFrame:SetAlpha(0.9)

	-- Leader icon
	li = hintFrame:CreateTexture(nil, "OVERLAY")
	li:SetPoint("TOPLEFT", hintFrame, 0, 8)
	li:SetSize(12,12)
	self.Leader = li

	-- Assistant icon
	ai = hintFrame:CreateTexture(nil, "OVERLAY")
	ai:SetPoint("TOPLEFT", hintFrame, 0, 8)
	ai:SetSize(12,12)
	self.Assistant = ai

	-- Master Looter icon
	local ml = hintFrame:CreateTexture(nil, "OVERLAY")
	ml:SetSize(10,10)
	ml:SetPoint("LEFT", self.Assistant, "RIGHT")
	self.MasterLooter = ml

	-- Raid Marks
	local rm = hintFrame:CreateTexture(nil,"OVERLAY")
	rm:SetPoint("CENTER", hintFrame, "TOP", 0, 2)
	rm:SetSize(retVal(self, 16, 13, 12), retVal(self, 16, 13, 12))
	self.RaidIcon = rm

	-- Frame specific stuff
	if self.mystyle == "player" then
		-- Combat icon
		comb = hintFrame:CreateTexture(nil, "OVERLAY")
		comb:SetSize(15,15)
		comb:SetPoint("CENTER", hintFrame, "BOTTOMRIGHT", 0, 0)
		comb:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
		comb:SetTexCoord(0.58, 0.90, 0.08, 0.41)
		self.Combat = comb

		-- Resting Icon
		rest = hintFrame:CreateTexture(nil, "OVERLAY")
		rest:SetSize(15,15)
		rest:SetPoint("CENTER", hintFrame, "BOTTOMLEFT", 0, 0)
		rest:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
		rest:SetTexCoord(0.09, 0.43, 0.08, 0.42)
		self.Resting = rest

		-- PvP Icon
		pvp = hintFrame:CreateTexture(nil, "OVERLAY")
		local faction = PvPCheck
		if faction == "Horde" then
			pvp:SetTexCoord(0.08, 0.58, 0.045, 0.545)
		elseif faction == "Alliance" then
			pvp:SetTexCoord(0.07, 0.58, 0.06, 0.57)
		else
			pvp:SetTexCoord(0.05, 0.605, 0.015, 0.57)
		end
		pvp:SetHeight(20)
		pvp:SetWidth(20)
		pvp:SetPoint("TOPRIGHT", 10, 10)
		self.PvP = pvp
	elseif self.mystyle == "target" then
		-- Quest Mob Icon
		local qicon = hintFrame:CreateTexture(nil, "OVERLAY")
		qicon:SetPoint("CENTER", hintFrame, "TOPLEFT", 0, 0)
		qicon:SetSize(20, 20)
		self.QuestIcon = qicon
	elseif self.mystyle == "party" then
		-- Quest Mob Icon
		local qicon = hintFrame:CreateTexture(nil, "OVERLAY")
		qicon:SetPoint("CENTER", hintFrame, "TOPLEFT", 0, 0)
		qicon:SetSize(20, 20)
		self.QuestIcon = qicon
		-- LFD Role Icon
		role = hintFrame:CreateTexture(nil, "OVERLAY")
		role:SetSize(13, 13)
		role:SetPoint("CENTER", hintFrame, "BOTTOMLEFT", 1, 0)
		self.LFDRole = role
		self.LFDRole:SetAlpha(1)
	elseif self.mystyle == "raid" then
		-- LFD Role Icon
		role = hintFrame:CreateTexture(nil, "OVERLAY")
		role:SetSize(13, 13)
		role:SetPoint("CENTER", hintFrame, "BOTTOMLEFT", 1, 0)
		self.LFDRole = role
		self.LFDRole:SetAlpha(0)
		-- Ready Check icon
		rCheck = hintFrame:CreateTexture(nil, "OVERLAY")
		rCheck:SetSize(14, 14)
		rCheck:SetPoint("BOTTOMLEFT", hintFrame, "TOPRIGHT", -13, -12)
		self.ReadyCheck = rCheck
	end
end

-- Class Bars
lib.addClassBar = function(self)
	if cfg.classBar and (playerClass == "WARLOCK" or playerClass == "DEATHKNIGHT" or playerClass == "PALADIN" or playerClass == "DRUID" or playerClass == "SHAMAN") then 
		local barFrame = CreateFrame("Frame", nil, self)
		local barGlow
		barFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
		barFrame:SetHeight(4)
		barFrame:SetWidth(self:GetWidth())
		barFrame:SetFrameLevel(4)

		if playerClass ~= "SHAMAN" then
			barGlow = createBGFrame(barFrame, 3)
			CreateShadowww(barFrame, 4)
		end

		if playerClass == "WARLOCK" then
			local ssOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "SOUL_SHARDS")) then return end
				local ss = self.SoulShards
				local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
				for i = 1, SHARD_BAR_NUM_SHARDS do
					if(i <= num) then
						ss[i]:SetAlpha(1)
					else
						ss[i]:SetAlpha(0.2)
					end
				end
			end

			for i= 1, 3 do
				local shard = CreateFrame("StatusBar", nil, barFrame)
				shard:SetSize((self:GetWidth() / 3)-2, 4)
				shard:SetStatusBarTexture(cfg.statusBarTexture)
				shard:SetStatusBarColor(.86,.44, 1)
				shard:SetFrameLevel(4)

				if (i == 1) then
					shard:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
				else
					shard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 3, 0)
				end
				barFrame[i] = shard
			end
			self.SoulShards = barFrame
			self.SoulShards.Override = ssOverride
		elseif playerClass == "DEATHKNIGHT" then
			oUF.colors.runes = {{0.87, 0.12, 0.23};{0.40, 0.95, 0.20};{0.14, 0.50, 1};{.70, .21, 0.94};}
			for i= 1, 6 do
				local rune = CreateFrame("StatusBar", nil, barFrame)
				rune:SetSize((self:GetWidth() / 6)-2, 4)
				rune:SetStatusBarTexture(cfg.statusBarTexture)
				rune:SetFrameLevel(4)

				if (i == 1) then
					rune:SetPoint("LEFT", barFrame, "LEFT", 1, 0)
				else
					rune:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 2, 0)
				end

				local runeBG = rune:CreateTexture(nil, "BACKGROUND")
				runeBG:SetAllPoints(rune)
				runeBG:SetTexture(cfg.statusBarTexture)
				rune.bg = runeBG
				rune.bg.multiplier = 0.3
				barFrame[i] = rune
			end
			self.Runes = barFrame
		elseif playerClass == "PALADIN" then
			local hpOverride = function(self, event, unit, powerType)
				if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end

				local hp = self.HolyPower
				if(hp.PreUpdate) then hp:PreUpdate(unit) end

				local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
				for i = 1, MAX_HOLY_POWER do
					if(i <= num) then
						hp[i]:SetAlpha(1)
					else
						hp[i]:SetAlpha(0.2)
					end
				end
			end

			for i = 1, 3 do
				local holyShard = CreateFrame("StatusBar", self:GetName().."_Holypower"..i, self)
				holyShard:SetHeight(4)
				holyShard:SetWidth((self:GetWidth() / 3)-2)
				holyShard:SetStatusBarTexture(cfg.statusBarTexture)
				holyShard:SetStatusBarColor(.9,.95,.33)
				holyShard:SetFrameLevel(4)

				if (i == 1) then
					holyShard:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
				else
					holyShard:SetPoint("TOPLEFT", barFrame[i-1], "TOPRIGHT", 3, 0)
				end
				barFrame[i] = holyShard
			end
			self.HolyPower = barFrame
			self.HolyPower.Override = hpOverride
		elseif playerClass == "DRUID" then
			local eclipseBarBuff = function(self, unit)
				if self.hasSolarEclipse then
					self.eBarBG:SetBackdropBorderColor(1,1,.5,.7)
				elseif self.hasLunarEclipse then
					self.eBarBG:SetBackdropBorderColor(.2,.2,1,.7)
				else
					self.eBarBG:SetBackdropBorderColor(0,0,0,1)
				end
			end

			barFrame.eBarBG = barGlow

			local lunarBar = CreateFrame("StatusBar", nil, barFrame)
			lunarBar:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
			lunarBar:SetSize(barFrame:GetWidth(), barFrame:GetHeight())
			lunarBar:SetStatusBarTexture(cfg.statusBarTexture)
			lunarBar:SetStatusBarColor(0, .1, .7)
			lunarBar:SetFrameLevel(5)
			barFrame.LunarBar = lunarBar

			local solarBar = CreateFrame("StatusBar", nil, barFrame)
			solarBar:SetPoint("LEFT", lunarBar:GetStatusBarTexture(), "RIGHT", 0, 0)
			solarBar:SetSize(barFrame:GetWidth(), barFrame:GetHeight())
			solarBar:SetStatusBarTexture(cfg.statusBarTexture)
			solarBar:SetStatusBarColor(1,1,.13)
			solarBar:SetFrameLevel(5)
			barFrame.SolarBar = solarBar

			local EBText = setFont(solarBar, cfg.font, 10, "OUTLINE", 2)
			EBText:SetPoint("CENTER", barFrame, "CENTER", 0, 0)
			self:Tag(EBText, "[pereclipse]")

			self.EclipseBar = barFrame
			self.EclipseBar.PostUnitAura = eclipseBarBuff
		elseif playerClass == "SHAMAN" then
			local barFrame = CreateFrame("Frame", nil, self)
			barFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -5)
			barFrame:SetHeight(4)
			barFrame:SetWidth(self:GetWidth())
			barFrame:SetFrameLevel(3)

			barFrame.Destroy = true
			barFrame.UpdateColors = true

			oUF.colors.totems = {
				{ 255/255, 072/255, 000/255 }, -- fire
				{ 073/255, 230/255, 057/255 }, -- earth
				{ 069/255, 176/255, 218/255 }, -- water
				{ 157/255, 091/255, 231/255 }  -- air
			}

			for i = 1, 4 do
				local totem = CreateFrame("Frame", nil, barFrame)
				totem:SetSize((self:GetWidth() / 4.2)-i+1, 4)
				if i == 1 then
					totem:SetPoint("LEFT", barFrame, "LEFT", 0, 0)
				else
					totem:SetPoint("LEFT", barFrame[i-1], "RIGHT", 6, 0)
				end
				totem:SetFrameLevel(4)

				createBGFrame(totem, 3)
				CreateShadowww(totem, 4)

				local bar = CreateFrame("StatusBar", nil, totem)
				bar:SetAllPoints(totem)
				bar:SetStatusBarTexture(cfg.statusBarTexture)
				totem.StatusBar = bar

				totem.bg = totem:CreateTexture(nil, "BACKGROUND")
				totem.bg:SetAllPoints()
				totem.bg:SetTexture(cfg.statusBarTexture)
				totem.bg.multiplier = 0.3

				barFrame[i] = totem
			end
			self.TotemBar = barFrame

		end
	end
end

-- Buffs and Debuffs
local format = string.format

local customAuraFilter = function(icons, _, icon, name, _, _, _, _, _, _, caster, _, _, spellID)
	local isPlayer

	if(caster == "player" or caster == "vehicle") then
		isPlayer = true
	end

	if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
		icon.isPlayer = isPlayer
		icon.owner = caster
	end

	return
end

--[[
local updateTooltip = function(self)
	GameTooltip:SetUnitAura(self.parent:GetParent().unit, self:GetID(), self.filter)
	if self.owner and UnitExists(self.owner) then
		GameTooltip:AddLine(format("|cff1369ca* Cast by %s|r", UnitName(self.owner) or UNKNOWN))
	end
	GameTooltip:Show()
end
]]
local formatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end

local setTimer = function (self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = formatTime(self.timeLeft)
				self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local postCreateIcon = function(element, button)
	local diffPos = 0
	local sLayout = "TOP"
	local nFont = 11
	local self = element:GetParent()
	if self.mystyle == "target" then diffPos = 1 end
	if self.mystyle == "player" then nFont = 15 sLayout = "CENTER" diffPos = -2 end

	element.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	createBGFrame(button, 0)
	CreateShadowww(button, 1)

	local time = setFont(button, cfg.font, nFont, "OUTLINE", 1)
	time:SetPoint("CENTER", button, sLayout, 2+diffPos, 0)
	time:SetJustifyH("CENTER")
	time:SetVertexColor(1,1,1)
	button.time = time

	local count = setFont(button, cfg.font, nFont, "OUTLINE", 1)
	count:SetPoint("CENTER", button, "BOTTOMRIGHT", 0, 3)
	count:SetJustifyH("RIGHT")
	button.count = count

	--button.UpdateTooltip = updateTooltip

	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer("ARTWORK")
end

local postUpdateIcon = function(element, unit, button, index)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, button.filter)

	if duration and duration > 0 then
		button.time:Show()
		button.timeLeft = expirationTime	
		button:SetScript("OnUpdate", setTimer)			
	else
		button.time:Hide()
		button.timeLeft = math.huge
		button:SetScript("OnUpdate", nil)
	end

	-- Desaturate non-Player Debuffs
	if(button.debuff) then
		if(unit == "target") then	
			if (unitCaster == "player" or unitCaster == "vehicle") then
				button.icon:SetDesaturated(false)                 
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don"t desaturate debuffs
				button:SetBackdropColor(0, 0, 0)
				button.overlay:SetVertexColor(0.3, 0.3, 0.3)      
				button.icon:SetDesaturated(true)  
			end
		end
	end
	button:SetScript('OnMouseUp', function(self, mouseButton)
		if mouseButton == 'RightButton' then
			CancelUnitBuff('player', index)
		end end)
		button.first = true
	end

	lib.addBuffs = function(self, position)
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetPoint(position.anchorPoint, position.relativeFrame and position.relativeFrame or self, position.relativePoint, position.offsetX, position.offsetY)
		buffs:SetSize(position.width, position.height)
		buffs.num = position.number
		buffs.size = position.size
		if self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
			buffs.spacing = 7
		end
		if self.mystyle == "player" then
			buffs.spacing = 10
		end
		buffs.initialAnchor = position.anchorPoint
		buffs["growth-x"] = position.growthX
		buffs["growth-y"] = position.growthY
		buffs.PostCreateIcon = postCreateIcon
		buffs.PostUpdateIcon = postUpdateIcon

		self.Buffs = buffs
	end

	lib.addDebuffs = function(self, position)
		local debuffs = CreateFrame("Frame", nil, self)
		local myFrame = self.Runes and self.Runes or
		self.TotemBar and self.TotemBar or
		self.SoulShards and self.SoulShards or
		self.HolyPower and self.HolyPower or
		self.EclipseBar and self.EclipseBar or
		self

		debuffs:SetPoint(position.anchorPoint, position.relativeFrame and position.relativeFrame or myFrame, position.relativePoint, position.offsetX, position.offsetY)
		debuffs:SetSize(position.width, position.height)
		debuffs.num = position.number
		debuffs.size = position.size
		debuffs.spacing = cfg.auras.spacing
		if self.mystyle == "player" then
			debuffs.spacing = 5
		end
		if self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
			debuffs.spacing = 7
		end
		debuffs.initialAnchor = position.anchorPoint
		debuffs["growth-x"] = position.growthX
		debuffs["growth-y"] = position.growthY
		debuffs.onlyShowPlayer = position.playerOnly
		debuffs.PostCreateIcon = postCreateIcon
		debuffs.PostUpdateIcon = postUpdateIcon

		self.Debuffs = debuffs
	end

	-- cast bar function
	local cbDefaultColor = {137/255, 153/255, 170/255}

	local function customTimeText(element, duration)
		element.Time:SetFormattedText("%.1f / %.1f", element.channeling and duration or (element.max - duration), element.max)
	end

	local function customDelayText(element, duration)
		element.Time:SetFormattedText("%.1f |cffff0000-%.1f|r / %.1f", element.channeling and duration or (element.max - duration), element.delay, element.max)
	end

	local function postCastStart(element, unit)
		if element.Text then
			local text = element.Text:GetText()
			element.Text:SetText("|cffffff88"..text.."|r")
		end
		if element.Inline then
			element:SetStatusBarColor(1,1,1,0.35)
		else
			local cbColor = RAID_CLASS_COLORS[select(2,  UnitClass(unit))]	
			local myMulti = 0.2
			if UnitIsPlayer(unit) and cbColor then
				element:SetStatusBarColor(cbColor.r, cbColor.g, cbColor.b)
				element.bg:SetTexture(cbColor.r * myMulti, cbColor.g * myMulti, cbColor.b * myMulti)
			else
				element:SetStatusBarColor(cbDefaultColor[1], cbDefaultColor[2], cbDefaultColor[3])	
				element.bg:SetTexture(cbDefaultColor[1] * myMulti, cbDefaultColor[2] * myMulti, cbDefaultColor[3] * myMulti)
			end
		end
	end

	lib.addCastBar = function(self, inline)
		if self.mystyle == "player" then return end
		if not cfg.Castbars then return end
		local cbHeight = 18
		local relativeFrame = self.Debuffs and self.Debuffs or self
		local textBorder = "NONE"
		local flvl = 1

		if inline then
			textBorder = "OUTLINE"
			if self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
				relativeFrame = self.Portrait
			else
				relativeFrame = self
			end
			cbHeight = relativeFrame:GetHeight()
		end

		local castbar = CreateFrame("StatusBar", nil, self)
		castbar:SetStatusBarTexture(cfg.statusBarTexture)
		castbar:SetFrameLevel(5)

		castbar.Inline = inline

		if not inline then
			createBGFrame(castbar, 0)

			local bgoverlay = castbar:CreateTexture(nil, "BACKGROUND", nil, -5)
			bgoverlay:SetPoint("TOPLEFT", castbar,"TOPLEFT", 0, 0)
			bgoverlay:SetPoint("BOTTOMRIGHT", castbar,"BOTTOMRIGHT", 0, 0)
			bgoverlay:SetTexture(cfg.portraitOverlayTexture)
			bgoverlay:SetVertexColor(0, 0, 0, 0.8)

			local castbarDummy = CreateFrame("Frame", nil, castbar)
			castbarDummy:SetSize(cbHeight, cbHeight)
			castbarDummy:SetPoint("TOPRIGHT", castbar, "TOPLEFT", -5, 0)
			createBGFrame(castbarDummy, 0)

			local castbarIcon = castbarDummy:CreateTexture(nil, "ARTWORK")
			castbarIcon:SetAllPoints(castbarDummy)
			castbarIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			castbar.Icon = castbarIcon

			castbar:SetSize(relativeFrame:GetWidth()-cbHeight-5, cbHeight)
			castbar:SetPoint("TOPRIGHT", relativeFrame, "BOTTOMRIGHT", 0, -3)
		else
			castbar:SetAllPoints(relativeFrame)
		end

		if self.mystyle == "player" or self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then
			if not inline then
				local castbarBG = castbar:CreateTexture(nil, "BACKGROUND", nil, -6)
				castbarBG:SetAllPoints(castbar)
				castbar.bg = castbarBG
			end
			local castbarTime = setFont(castbar, cfg.font, 12, textBorder, 1)
			castbarTime:SetPoint("RIGHT", castbar, "RIGHT", -2, 1)
			castbarTime:SetJustifyH("RIGHT")
			castbar.Time = castbarTime

			local castbarText = setFont(castbar, cfg.font, 12, textBorder, 1)
			castbarText:SetPoint("LEFT", castbar, "LEFT", 2, 1)
			castbarText:SetPoint("RIGHT", castbarTime, "LEFT", -4, 0)
			castbarText:SetJustifyH("LEFT")
			castbar.Text = castbarText
		end

		if self.mystyle == "target" or self.mystyle == "party" or self.mystyle == "focus" then flvl = 4 end

		if self.mystyle == "player" then
			castbar.SafeZone = castbar:CreateTexture(nil, "OVERLAY", nil, -4)
			castbar.SafeZone:SetAlpha(0.35)
		elseif self.mystyle == "target" or self.mystyle == "focus" then
			local shield = createBGFrame(castbar, flvl)
			shield:SetBackdropColor(0.65, 0, 0, 1)
			shield:SetBackdropBorderColor(0, 0, 0, 0)
			castbar.Shield = shield
		end

		local spark = castbar:CreateTexture(nil, "OVERLAY")
		spark:SetBlendMode("ADD")
		spark:SetAlpha(0.3)
		spark:SetHeight(cbHeight*2.5)
		castbar.Spark = spark

		self.Castbar = castbar
		if castbar.Time then 
			self.Castbar.CustomTimeText = customTimeText
			self.Castbar.CustomDelayText = customDelayText
		end
		self.Castbar.PostCastStart = postCastStart
		self.Castbar.PostChannelStart = postCastStart
	end

	-----------------------------
	-- PLUGINS
	-----------------------------

	-- AuraWatch
	local AWPostCreateIcon = function(AWatch, icon, spellID, name, self)
		icon.cd:SetReverse()
		local count = setFont(icon, cfg.nanofont, 10, "OUTLINE", 0)
		count:SetPoint("CENTER", icon, "BOTTOM", 3, 3)
		icon.count = count
		createBGFrame(icon, 4, 3)
		CreateShadowww(icon, 4)
	end

	lib.addAuraWatch = function(self)
		if cfg.showAuraWatch then
			local auras = {}
			local spellIDs = {
				DEATHKNIGHT = {
				},
				DRUID = {
					33763, -- Lifebloom
					8936, -- Regrowth
					774, -- Rejuvenation
					48438, -- Wild Growth
				},
				HUNTER = {
					34477, -- Misdirection
				},
				MAGE = {
					54646, -- Focus Magic
				},
				PALADIN = {
					53563, -- Beacon of Light
					25771, -- Forbearance
				},
				PRIEST = { 
					17, -- Power Word: Shield
					139, -- Renew
					33076, -- Prayer of Mending
					6788, -- Weakened Soul
				},
				ROGUE = {
					57934, -- Tricks of the Trade
				},
				SHAMAN = {
					974, -- Earth Shield
					61295, -- Riptide
				},
				WARLOCK = {
					20707, -- Soulstone Resurrection
				},
				WARRIOR = {
					50720, -- Vigilance
				},
			}

			auras.onlyShowPresent = true
			auras.anyUnit = true
			auras.PostCreateIcon = AWPostCreateIcon
			-- Set any other AuraWatch settings
			auras.icons = {}

			for i, sid in pairs(spellIDs[playerClass]) do
				local icon = CreateFrame("Frame", nil, self)
				icon.spellID = sid
				-- set the dimensions and positions
				icon:SetWidth(10)
				icon:SetHeight(10)
				icon:SetFrameLevel(5)
				icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", 12 * i, 5)

				auras.icons[sid] = icon
			end
			self.AuraWatch = auras
		end
	end

	-- debuffHighlight
	lib.addDebuffHighlight = function (self)
		if cfg.enableDebuffHighlight then
			local dbh = self.Health:CreateTexture(nil, "OVERLAY")
			dbh:SetAllPoints(self.Health)
			dbh:SetTexture(cfg.glowTexture)
			dbh:SetBlendMode("ADD")
			dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
			self.DebuffHighlight = dbh
			self.DebuffHighlightAlpha = 0.8
			self.DebuffHighlightFilter = true
		end
	end

	-- oUF_CombatFeedback
	lib.addCombatFeedback = function(self)
		if IsAddOnLoaded("oUF_CombatFeedback") then
			local obj = self.Portrait and self.Portrait or self.Health
			local cbft = setFont(obj, cfg.font, 20, "THICKOUTLINE", 0)
			cbft:SetPoint("CENTER", obj, "CENTER")

			self.CombatFeedbackText = cbft		
			self.CombatFeedbackText.ignoreEnergize = true
		end
	end
	lib.ThreatBar = function(self)
		if cfg.ThreatBar then
			local ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', UIParent)
			ThreatBar:SetFrameLevel(5)
			ThreatBar:SetPoint("BOTTOM", UIParent,"BOTTOM", 0, 150)
			ThreatBar:SetWidth(348)
			ThreatBar:SetHeight(16)
			ThreatBar:SetStatusBarTexture(cfg.statusBarTexture)  
			ThreatBar.Text = setFont(ThreatBar, cfg.font, 12, "OUTLINE", 2)
			ThreatBar.Text:SetPoint("RIGHT", ThreatBar, "RIGHT", -30, 0)	
			ThreatBar.Title = setFont(ThreatBar, cfg.font, 12, "OUTLINE", 2)
			ThreatBar.Title:SetText("Threat on current target:")
			ThreatBar.Title:SetPoint("LEFT", ThreatBar, "LEFT", 30, 0)				  
			ThreatBar.bg = ThreatBar:CreateTexture(nil, 'BORDER')
			ThreatBar.bg:SetAllPoints(ThreatBar)
			ThreatBar.bg:SetTexture(0.1,0.1,0.1)	   
			ThreatBar.useRawThreat = false

			local h = CreateFrame("Frame", nil, ThreatBar)
			h:SetFrameLevel(4)
			h:SetPoint("TOPLEFT",0,0)
			h:SetPoint("BOTTOMRIGHT",0,0)
			createBGFrame(h,1)
			CreateShadowww(h,2)

			self.ThreatBar = ThreatBar
		end
	end
	lib.Experience = function(self)
		if cfg.Experiencebar then 
			local Experience = CreateFrame('StatusBar', nil, self)
			Experience:SetStatusBarTexture(cfg.statusBarTexture)
			Experience:SetStatusBarColor(0, 0.7, 1)
			Experience:SetPoint('BOTTOMLEFT', self,'TOPLEFT', 0, 6)
			Experience:SetHeight(5)
			Experience:SetWidth(200)

			Experience:SetFrameLevel(11)
			Experience.Tooltip = true

			local h = CreateFrame("Frame", nil, Experience)
			h:SetFrameLevel(10)
			h:SetPoint("TOPLEFT",0,0)
			h:SetPoint("BOTTOMRIGHT",0,0)
			createBGFrame(h,1)
			CreateShadowww(h,2)

			local Rested = CreateFrame('StatusBar', nil, Experience)
			Rested:SetStatusBarTexture(cfg.statusBarTexture)
			Rested:SetStatusBarColor(0, 0.4, 1, 0.6)
			Rested:SetAllPoints(Experience)

			self.Experience = Experience
			self.Experience.Rested = Rested
			self.Experience.PostUpdate = ExperiencePostUpdate
		end
	end
	lib.Reputation = function(self)
		if cfg.Reputationbar then 
			local Reputation = CreateFrame('StatusBar', nil, self)
			Reputation:SetStatusBarTexture(cfg.statusBarTexture)
			Reputation:SetWidth(200)

			Reputation:SetHeight(5)
			Reputation:SetPoint('BOTTOMLEFT', self,'TOPLEFT', 0, cfg.Experiencebar and 17 or 6)
			Reputation:SetFrameLevel(30)

			local h = CreateFrame("Frame", nil, Reputation)
			h:SetFrameLevel(10)
			h:SetPoint("TOPLEFT",0,0)
			h:SetPoint("BOTTOMRIGHT",0,0)
			createBGFrame(h,1)
			CreateShadowww(h,2)
			Reputation.PostUpdate = UpdateReputationColor
			Reputation.Tooltip = true
			self.Reputation = Reputation
		end
	end
	lib.AltPowerBar = function(self)
		if cfg.AltPowerBar then 
			local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)
			AltPowerBar:SetHeight(10)
			AltPowerBar:SetWidth(200)

			AltPowerBar:SetStatusBarTexture(cfg.statusBarTexture)
			AltPowerBar:EnableMouse(true)
			AltPowerBar:SetFrameStrata("HIGH")
			AltPowerBar:SetFrameLevel(5)
			AltPowerBar:SetPoint('BOTTOMLEFT', self,'TOPLEFT', 0, 17)

			local h = CreateFrame("Frame", nil, AltPowerBar)
			h:SetFrameLevel(4)
			h:SetPoint("TOPLEFT",0,0)
			h:SetPoint("BOTTOMRIGHT",0,0)
			createBGFrame(h,1)
			CreateShadowww(h,2)

			AltPowerBar.text = setFont(AltPowerBar, cfg.font, 12, "THINOUTLINE", 2)
			AltPowerBar.text:SetPoint("CENTER")
			AltPowerBar.text:SetJustifyH("CENTER")

			AltPowerBar:HookScript("OnShow", AltPowerBarOnToggle)
			AltPowerBar:HookScript("OnHide", AltPowerBarOnToggle)

			self.AltPowerBar = AltPowerBar		
			self.AltPowerBar.PostUpdate = AltPowerBarPostUpdate
		end	
	end
	-- raid debuffs
	lib.raidDebuffs = function(f)
		if cfg.showRaidDebuffs then
			local raid_debuffs = {
				debuffs = {
					--Morchok
					[GetSpellInfo(103687)] = 11, --Crush Armor
					[GetSpellInfo(103821)] = 12, --Earthen Vortex
					[GetSpellInfo(103785)] = 13, --Black Blood of the Earth
					[GetSpellInfo(103534)] = 14, --Danger (Red)
					[GetSpellInfo(103536)] = 15, --Warning (Yellow)
					-- Don't need to show Safe people
					[GetSpellInfo(103541)] = 16, --Safe (Blue)

					--Warlord Zon'ozz
					[GetSpellInfo(104378)] = 21, --Black Blood of Go'rath
					[GetSpellInfo(103434)] = 22, --Disrupting Shadows (dispellable)

					--Yor'sahj the Unsleeping
					[GetSpellInfo(104849)] = 31, --Void Bolt
					[GetSpellInfo(105171)] = 32, --Deep Corruption

					--Hagara the Stormbinder
					[GetSpellInfo(105316)] = 41, --Ice Lance
					[GetSpellInfo(105465)] = 42, --Lightning Storm
					[GetSpellInfo(105369)] = 43, --Lightning Conduit
					[GetSpellInfo(105289)] = 44, --Shattered Ice (dispellable)
					[GetSpellInfo(105285)] = 45, --Target (next Ice Lance)
					[GetSpellInfo(104451)] = 46, --Ice Tomb
					[GetSpellInfo(110317)] = 47, --Watery Entrenchment

					--Ultraxion
					[GetSpellInfo(105925)] = 51, --Fading Light
					[GetSpellInfo(106108)] = 52, --Heroic Will
					[GetSpellInfo(105984)] = 53, --Timeloop
					[GetSpellInfo(105927)] = 54, --Faded Into Twilight

					--Warmaster Blackhorn
					[GetSpellInfo(108043)] = 61, --Sunder Armor
					[GetSpellInfo(107558)] = 62, --Degeneration
					[GetSpellInfo(107567)] = 64, --Brutal Strike
					[GetSpellInfo(108046)] = 64, --Shockwave

					--Spine of Deathwing
					[GetSpellInfo(105563)] = 71, --Grasping Tendrils
					[GetSpellInfo(105479)] = 72, --Searing Plasma
					[GetSpellInfo(105490)] = 73, --Fiery Grip

					--Madness of Deathwing
					[GetSpellInfo(105445)] = 81, --Blistering Heat
					[GetSpellInfo(105841)] = 82, --Degenerative Bite
					[GetSpellInfo(106385)] = 83, --Crush
					[GetSpellInfo(106730)] = 84, --Tetanus
					[GetSpellInfo(106444)] = 85, --Impale
					[GetSpellInfo(106794)] = 86, --Shrapnel (target)

					-- Priest
					[GetSpellInfo(6346)] = 1, -- Fear Ward
					[GetSpellInfo(605)] = 1, -- Mind Control
					[GetSpellInfo(8122)] = 1, -- Psychic Scream
					[GetSpellInfo(64044)] = 1, -- Psychic Horror   
					[GetSpellInfo(69910)] = 1, -- Pain Suppression
					[GetSpellInfo(15487)] = 1, -- Silence
					[GetSpellInfo(47585)] = 1, -- Dispersion   
					[GetSpellInfo(17)] = 1, -- Power Word: Shield
					[GetSpellInfo(88625)] = 1, -- Holy Word: Chastise

					-- Paladin
					[GetSpellInfo(853)] = 1, -- Hammer of Justice
					[GetSpellInfo(642)] = 1, -- Divine Shield
					[GetSpellInfo(1022)] = 1, -- Hand of Protection
					[GetSpellInfo(1044)] = 1, -- Hand of Freedom
					[GetSpellInfo(6940)] = 1, -- Hand of Sacrifice   
					[GetSpellInfo(20066)] = 1, -- Repentance
					[GetSpellInfo(20925)] = 1, -- 神圣之盾
					[GetSpellInfo(86150)] = 1, -- 远古列王守卫

					-- Rogue
					[GetSpellInfo(31224)] = 1, -- Cloak of Shadows
					[GetSpellInfo(5277)] = 1, -- Evasion
					[GetSpellInfo(43235)] = 1, -- Wound Poison
					[GetSpellInfo(2094)] = 1, -- Blind
					[GetSpellInfo(6770)] = 1, -- Sap
					[GetSpellInfo(408)] = 1, -- Kidney Shot
					[GetSpellInfo(1776)] = 1, -- Gouge   

					-- Warrior
					[GetSpellInfo(12294)] = 1, -- Mortal Strike
					[GetSpellInfo(1715)] = 1, -- Hamstring
					[GetSpellInfo(871)] = 1, -- Shield Wall   
					[GetSpellInfo(18499)] = 1, -- Berserker Rage

					-- Druid
					[GetSpellInfo(33786)] = 1, -- Cyclone
					[GetSpellInfo(339)] = 1, -- Entangling Roots
					[GetSpellInfo(29166)] = 1, -- Innervate
					[GetSpellInfo(2637)] = 1, -- Hibernate

					-- Warlock
					[GetSpellInfo(5782)] = 1, -- Fear
					[GetSpellInfo(5484)] = 1, -- Howl of Terror
					[GetSpellInfo(6358)] = 1, -- Seduction   
					[GetSpellInfo(1714)] = 1, -- Curse of Tongues
					[GetSpellInfo(18223)] = 1, -- Curse of Exhaustion
					[GetSpellInfo(6789)] = 1, -- Death Coil
					[GetSpellInfo(30283)] = 1, -- Shadowfury

					-- Shaman
					[GetSpellInfo(51514)] = 1, -- Hex

					-- Mage
					[GetSpellInfo(18469)] = 1, -- Silenced - Improved Counterspell - Rank1
					[GetSpellInfo(55021)] = 1, -- Silenced - Improved Counterspell - Rank2
					[GetSpellInfo(2139)] = 1, -- Counterspell
					[GetSpellInfo(118)] = 1, -- Polymorph
					[GetSpellInfo(44572)] = 1, -- Deep Freeze
					[GetSpellInfo(45438)] = 1, -- Ice Block   
					[GetSpellInfo(122)] = 1, -- Frost Nova

					-- Hunter
					[GetSpellInfo(19503)] = 1, -- Scatter Shot
					[GetSpellInfo(55041)] = 1, -- Freezing Trap Effect
					[GetSpellInfo(2974)] = 1, -- Wing Clip
					[GetSpellInfo(19263)] = 1, -- Deterrence
					[GetSpellInfo(34490)] = 1, -- Silencing Shot
					[GetSpellInfo(19386)] = 1, -- Wyvern Sting
					[GetSpellInfo(19577)] = 1, -- Intimidation

					-- Death Knight
					[GetSpellInfo(45524)] = 1, -- Chains of Ice
					[GetSpellInfo(48707)] = 1, -- Anti-Magic Shell
					[GetSpellInfo(47476)] = 1, -- Strangulate

				},
			}

			local instDebuffs = {}
			local instances = raid_debuffs.instances
			local getzone = function()
				local zone = GetInstanceInfo()
				if instances[zone] then
					instDebuffs = instances[zone]
				else
					instDebuffs = {}
				end
			end

			local debuffs = raid_debuffs.debuffs
			local CustomFilter = function(icons, ...)
				local _, icon, name, _, _, _, dtype = ...
				if instDebuffs[name] then
					icon.priority = instDebuffs[name]
					return true
				elseif debuffs[name] then
					icon.priority = debuffs[name]
					return true
				else
					icon.priority = 0
				end
			end

			local dbsize = 13
			local debuffs = CreateFrame("Frame", nil, f)
			debuffs:SetWidth(dbsize) debuffs:SetHeight(dbsize)
			debuffs:SetPoint("TOPRIGHT", -10, 3)
			debuffs.size = dbsize

			debuffs.CustomFilter = CustomFilter
			f.raidDebuffs = debuffs
		end
	end

	--hand the lib to the namespace for further usage...this is awesome because you can reuse functions in any of your layout files
ns.lib = lib
