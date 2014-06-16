local addon, ns = ...
local cfg = ns.cfg

local SVal = function(val)
	if val then
		if (val >= 1e6) then
			return ("%.1fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.1fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end
end

local addCommas = function(value)
	if value then
		local result = string.gsub(value, "(%d)(%d%d%d)$", "%1,%2", 1)
		while true do
			result, found = string.gsub(result, "(%d)(%d%d%d),", "%1,%2,", 1)
			if found == 0 then break end
		end
		return result
	end
end

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

oUF.Tags['drk:hp']  = function(u) 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['drk:DDG'](u)
	else
		local per = oUF.Tags['perhp'](u).."%" or 0
		local min, max = UnitHealth(u), UnitHealthMax(u)
		if u == "player" or u == "target" or u:match("party%d") then
			if min~=max then 
				return "|cFFFFAAAA"..SVal(min).."|r/"..SVal(max).." | "..per
			else
				return SVal(max).." | "..per
			end
		else
			return per
		end
	end
end
oUF.TagEvents['drk:hp'] = 'UNIT_HEALTH UNIT_MAXHEALTH'

oUF.Tags['drk:mp']  = function(u) 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['drk:DDG'](u)
	else
		return SVal(UnitPower(u))
	end
end
oUF.TagEvents['drk:mp'] = 'UNIT_POWER UNIT_MAXPOWER'

oUF.Tags['drk:raidhp']  = function(u) 
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return oUF.Tags['drk:DDG'](u)
	else
		local per = oUF.Tags['perhp'](u).."%" or 0
		return per
	end
end
oUF.TagEvents['drk:raidhp'] = 'UNIT_HEALTH UNIT_MAXHEALTH'

oUF.Tags['drk:color'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")

	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.TagEvents['drk:color'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

oUF.Tags["drk:afkdnd"] = function(unit) 

	return UnitIsAFK(unit) and "|cffCFCFCF <afk>|r" or UnitIsDND(unit) and "|cffCFCFCF <dnd>|r" or ""
end
oUF.TagEvents["drk:afkdnd"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags['drk:DDG'] = function(u)
	if UnitIsDead(u) then
		return "|cffCFCFCF Dead|r"
	elseif UnitIsGhost(u) then
		return "|cffCFCFCF Ghost|r"
	elseif not UnitIsConnected(u) then
		return "|cffCFCFCF D/C|r"
	end
end
oUF.TagEvents['drk:DDG'] = 'UNIT_HEALTH'

oUF.Tags['drk:power']  = function(u) 
	local min, max = UnitPower(u), UnitPowerMax(u)
	if min~=max then 
		return SVal(min).."/"..SVal(max)
	else
		return SVal(max)
	end
end
oUF.TagEvents['drk:power'] = 'UNIT_POWER UNIT_MAXPOWER'

-- ComboPoints
oUF.Tags["myComboPoints"] = function(unit)

	local cp, str		
	if(UnitExists'vehicle') then
		cp = GetComboPoints('vehicle', 'target')
	else
		cp = GetComboPoints('player', 'target')
	end

	if (cp == 1) then
		str = string.format("|cff69e80c%d|r",cp)
	elseif cp == 2 then
		str = string.format("|cffb2e80c%d|r",cp)
	elseif cp == 3 then
		str = string.format("|cffffd800%d|r",cp) 
	elseif cp == 4 then
		str = string.format("|cffffba00%d|r",cp) 
	elseif cp == 5 then
		str = string.format("|cfff10b0b%d|r",cp)
	end

	return str
end
oUF.TagEvents["myComboPoints"] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED"

-- Deadly Poison Tracker
function hasUnitDebuff(unit, name)
	local _, _, _, count, _, _, _, caster = UnitDebuff(unit, name)
	if (count and caster == 'player') then return count end
end

oUF.Tags["myDeadlyPoison"] = function(unit)

	local Spell = "Deadly Poison" or GetSpellInfo(43233)
	local ct = hasUnitDebuff(unit, Spell)
	local cp = GetComboPoints('player', 'target')

	if cp > 0 then
		if (not ct) then
			str = ""
		elseif (ct == 1) then
			str = string.format("|cffc1e79f%d|r",ct)
		elseif ct == 2 then
			str = string.format("|cfface678%d|r",ct)
		elseif ct == 3 then
			str = string.format("|cff9de65c%d|r",ct) 
		elseif ct == 4 then
			str = string.format("|cff8be739%d|r",ct) 
		elseif ct == 5 then
			str = string.format("|cff90ff00%d|r",ct)
		end
	else
		str = ""
	end

	return str
end

oUF.TagEvents["myDeadlyPoison"] = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED UNIT_AURA"

-- Level
oUF.Tags["drk:level"] = function(unit)

	local c = UnitClassification(unit)
	local l = UnitLevel(unit)
	local d = GetQuestDifficultyColor(l)

	local str = l

	if l <= 0 then l = "??" end

	if c == "worldboss" then
		str = string.format("|cff%02x%02x%02xBoss|r",250,20,0)
	elseif c == "eliterare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "elite" then
		str = string.format("|cff%02x%02x%02x%s|r+",d.r*255,d.g*255,d.b*255,l)
	elseif c == "rare" then
		str = string.format("|cff%02x%02x%02x%s|r|cff0080FFR|r",d.r*255,d.g*255,d.b*255,l)
	else
		if not UnitIsConnected(unit) then
			str = "??"
		else
			if UnitIsPlayer(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			elseif UnitPlayerControlled(unit) then
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			else
				str = string.format("|cff%02x%02x%02x%s",d.r*255,d.g*255,d.b*255,l)
			end
		end		
	end

	return str
end

oUF.TagEvents["drk:level"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

oUF.Tags['drk:repstanding']  = function(unit)
	local _, standing = GetWatchedFactionInfo()
	if GetWatchedFactionInfo() then
		return "(".._G["FACTION_STANDING_LABEL"..standing]..")"
	end
end
oUF.TagEvents['drk:repstanding'] = 'UPDATE_FACTION'

oUF.Tags['drk:currep']  = function(unit)
	local _, _, cur, _, total = GetWatchedFactionInfo()
	if GetWatchedFactionInfo() then
		return addCommas(total-cur)
	end
end
oUF.TagEvents['drk:currep'] = 'UPDATE_FACTION'

oUF.Tags['drk:maxrep']  = function(unit)
	local _, _, cur, max = GetWatchedFactionInfo()
	if GetWatchedFactionInfo() then
		return addCommas(max-cur)
	end
end
oUF.TagEvents['drk:maxrep'] = 'UPDATE_FACTION'

oUF.Tags['drk:curxp']  = function(unit)
	return addCommas(UnitXP(unit))
end
oUF.TagEvents['drk:curxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UPDATE_EXHAUSTION'

oUF.Tags['drk:maxxp']  = function(unit)
	return addCommas(UnitXPMax(unit))
end
oUF.TagEvents['drk:maxxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UPDATE_EXHAUSTION'

oUF.Tags['drk:restedxp']  = function(unit)
	local rested = GetXPExhaustion()
	if (rested and rested > 0) then
		return "(+"..math.floor(rested / UnitXPMax(unit) * 100 + 0.5).."%)"
	end
end
oUF.TagEvents['drk:restedxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UPDATE_EXHAUSTION'
