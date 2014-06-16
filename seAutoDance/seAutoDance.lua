function HasJW()
	return HasBuff(GetClientPlayer().dwID, 409)
end

function HasMD()
	return HasBuff(GetClientPlayer().dwID, 2352)
end

function seAutoDance()
	_OnUseSkill = OnUseSkill
	OnUseSkill = function(dwSkillID, dwSkillLevel)
		-- 剑主天地	562
		-- 剑气长江	561
		-- 剑神无我	559
		-- 剑灵寰宇	564
		-- 满堂势	573
		-- 繁音集结	568
		-- 清音五岳	2707
		-- 剑斩风流	2716
		if (dwSkillID == 562 or dwSkillID == 561 or dwSkillID == 559 or dwSkillID == 564 or dwSkillID == 573 or dwSkillID == 568 or dwSkillID == 2707 or dwSkillID == 2716 ) then
			if not HasJW() then
				_OnUseSkill(537, 7)
			end
			if (dwSkillID == 573) then
				_OnUseSkill(573, 1)
				_OnUseSkill(568, 4)
				_OnUseSkill(2716,1)
			elseif (dwSkillID == 568) then
				_OnUseSkill(568, 4)
				_OnUseSkill(561, 9)
			elseif (dwSkillID == 561) then
				_OnUseSkill(561, 9)
				_OnUseSkill(562, 10)
			elseif (dwSkillID == 2716) then
				_OnUseSkill(2716, 1)
			else
				_OnUseSkill(dwSkillID, dwSkillLevel)
			end
		elseif (dwSkillID == 554 or dwSkillID == 556 or dwSkillID == 569 or dwSkillID == 555 or dwSkillID == 565 or dwSkillID == 567 or dwSkillID == 566) then
			if not HasJW() then
				_OnUseSkill(537, 7)
			end
			--[[
			if dwSkillID == 565 then
				local _, id = GetClientPlayer().GetTarget()
				if not HasBuff( id, 680 ) then
					_OnUseSkill(554, 7)
				end
				if not HasBuff( id, 681 ) then
					_OnUseSkill(556, 6)
				end
			end
			]]
			_OnUseSkill(dwSkillID, dwSkillLevel)
		else
			_OnUseSkill(dwSkillID, dwSkillLevel)
		end
	end
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

function Jumpback()
	OnUseSkill(9007, 1)
	OnUseSkill(9004, 1)
	OnUseSkill(9005, 1)
	OnUseSkill(9006, 1)
end
function HitJumpback()
	OnUseSkill(9004, 1)
	OnUseSkill(9005, 1)
	OnUseSkill(9006, 1)
	OnUseSkill(9007, 1)
end

Hotkey.AddBinding("Jumpback", "隐藏后翻", "反和谐后翻", Jumpback, nil)
Hotkey.AddBinding("HitJumpback", "攻击后翻", nil, HitJumpback, nil)

seAutoDance()

