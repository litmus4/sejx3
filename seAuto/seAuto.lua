seAuto = {
	bOn = false,
	ticks = 0,
}

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seAuto] " .. table.concat(a, "\t").. "\n" )
end

function seAuto.OnFrameCreate()
	print("各种自动 Loaded by 叶芷青、翼宿怜")
	seAuto.box = Station.Lookup("Topmost/seAuto"):Lookup("",""):Lookup("Box")
	seAuto.box:Hide()
end

function seAuto.OnUseSkill(nSkillID, nLevel)
	seAuto.box:SetObject(UI_OBJECT_SKILL, nSkillID, nLevel)
	seAuto.box:SetObjectIcon(Table_GetSkillIconID(nSkillID, nLevel))
	PetActionBar.OnUseActionBarObject(seAuto.box)
end

function seAuto.OnFrameBreathe()
--[[
	if GetClientPlayer().nCurrentMana < 500 then
		seAuto.bOn = false
	elseif GetClientPlayer().nCurrentMana == GetClientPlayer().nMaxMana then
		seAuto.bOn = true
	end
	
	if not seAuto.bOn then
		if not HasBuff(GetClientPlayer().dwID, 103)then
			RemoveBuff(409)
			OnUseSkill(17, 1)
		end
		return
	else
		if not HasBuff(GetClientPlayer().dwID, 409) then
			RemoveBuff(103)
			OnUseSkill(537)
		end
	end
	--now_tick = GetTime()
	--if (now_tick - seAuto.ticks) > 3200 then
	--	seAuto.ticks = GetTime()
		OnUseSkill(568,4)
		OnUseSkill(571,5)
		OnUseSkill(561,2)
		OnUseSkill(563,2)
		--OnUseItem(1, 0)
		--OnUseSkill(565,1)
	--end
]]
end

function RemoveBuff(dwBuffID)
	local player = GetClientPlayer()
	local tab = player.GetBuffList()
	if not tab then return end
	for _, v in pairs(tab) do
		if v.dwID == dwBuffID then
			player.CancelBuff(v.nIndex)
		end
	end
end

function HasBuff(dwTarget, dwBuffID)
	local player 
	if IsPlayer(dwTarget) then
		player = GetPlayer(dwTarget)
	else
		player = GetNpc(dwTarget)
	end
	if (not player) or IsEnemy(GetClientPlayer().dwID, player.dwID) then
		player = GetClientPlayer()
	end
	local tab = player.GetBuffList()
    if not tab then return false end
    for _, v in pairs(tab) do
        if v.dwID == dwBuffID then
            return true
        end
    end
	return false
end

Wnd.OpenWindow("interface\\seAuto\\seAuto.ini", "seAuto")
