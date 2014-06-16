local se_SELF = 0
local se_ALL = 1


seBossTipsLogic = {}
se_bSaid = {}	--控制buff通报时间间隔,防止刷屏

function seBossTipsLogic.OnFrameCreate()
	this:RegisterEvent("SYS_MSG")
	this:RegisterEvent("DO_SKILL_CAST")
	this:RegisterEvent("BUFF_UPDATE")
	this:RegisterEvent("PLAYER_ENTER_SCENE")
	this:RegisterEvent("CUSTOM_DATA_LOADED")
	seBoss_print("首领逻辑模块 Loaded by 翼宿怜、唐左道、小司")
end

function seBossTipsLogic.OnEvent(event)
	if event == "CUSTOM_DATA_LOADED" then
	elseif event == "PLAYER_ENTER_SCENE" then
		local hPlayer = GetClientPlayer()
		if hPlayer and arg0 == hPlayer.dwID then
			local szSceneName = Table_GetMapName(hPlayer.GetScene().dwMapID)
			for i=1, #seBossTips, 1 do
				if seBossTips[i].szName == szSceneName then
					seBossTips[i].bOn = true
				else
					seBossTips[i].bOn = false
				end
			end
		end
	elseif event == "BUFF_UPDATE" and arg5 > 0 then
		local tempName = Table_GetBuffName(arg4,arg8)
		if not se_bSaid[tempName] and tempName~="" then
			se_bSaid[tempName] = {bState = false , szTime = GetCurrentTime()}
		end
		seBossTipsLogic.OnBuffUpdate(arg0, arg4, arg8)
	elseif event == "DO_SKILL_CAST" then
		seBossTipsLogic.OnSkillCasting(arg0, arg1, arg2)
	elseif event == "SYS_MSG" then
		if arg0 == "UI_OME_SKILL_CAST_LOG" then
			seBossTipsLogic.OnSkillCasting(arg1, arg2, arg3)
		end
	end
end


function seBossTipsLogic.OnBuffUpdate(playerID, buffID, buffLV)
	local ad_hoc_Bufflist = { ["剑冲阴阳"] = true }	--buff列表(瞬间获得多层导致聊天频道刷屏的buff)
	local buffName
	local bRed
	local bCenter
	local bSay
	local sInfo
	local r, g, b
	local nTarget
	buffName = Table_GetBuffName(buffID, buffLV)
	local p
	if GetPlayer(playerID) then
		p = GetPlayer(playerID)
	elseif GetNpc(playerID) then
		p = GetNpc(playerID)
	else
		return
	end

	if se_bSaid[buffName] then
		local Now=GetCurrentTime()
		if (Now - se_bSaid[buffName].szTime)>1 then
			se_bSaid[buffName].bState = false
			se_bSaid[buffName].szTime = GetCurrentTime()
		end
	end

	local bFlash = false

	for i=1, #seBossTips, 1 do
		local fb = seBossTips[i]
		if fb.bOn then
			for j=1, #fb, 1 do
				local boss = fb[j]
				if boss.bOn then
					bufflist = boss["BuffList"]

					for i = 1, #bufflist, 1 do
						if bufflist[i].bOn and bufflist[i].name == buffName then
							bRed = bufflist[i].bRedAlarm
							bCenter = bufflist[i].bCenterAlarm
							bSay = bufflist[i].bSay
							sInfo = bufflist[i].sInfo
							nTarget = bufflist[i].nTarget
							bFlash = true
							r = bufflist[i].color.r
							g = bufflist[i].color.g
							b = bufflist[i].color.b
							break
						end
					end
				end
			end
		end
	end
	if bFlash then
		if not seBoss_Set.bRedAlarm then
			bRed = false
		end
		if not seBoss_Set.bCenterAlarm then
			bCenter = false
		end
		if nTarget == se_SELF and playerID == GetClientPlayer().dwID then
			if seBoss_Set.bRedAlarm then
				bRed = true
			end
			if seBoss_Set.bCenterAlarm then
				bCenter = true
			end
		elseif  nTarget == se_ALL then
			if seBoss_Set.bRedAlarm then
				bRed = true
			end
			if seBoss_Set.bCenterAlarm then
				bCenter = true
			end
		end

		if nTarget == se_SELF and playerID == GetClientPlayer().dwID then
			if not ad_hoc_Bufflist[buffName] then
				seRedAlarm.Flash(2, "你获得了["..buffName.."]  "..sInfo, bRed, bCenter, r, g, b)
			end
		elseif nTarget == se_ALL then
			if IsPlayer(playerID) then
				seRedAlarm.Flash(2, "你获得了["..buffName.."]  "..sInfo, bRed, bCenter, r, g, b)
			else
				seRedAlarm.Flash(2, p.szName.."获得了["..buffName.."]  "..sInfo, bRed, bCenter, r, g, b)
			end
		end

		if seBoss_Set.bSay and bSay then
			if nTarget == se_SELF and seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.WHISPER then
				if playerID ~= GetClientPlayer().dwID then
					if ad_hoc_Bufflist[buffName] then
						if not se_bSaid[buffName].bState then
							seBoss_Say(seBoss_Set.bSayChannel, p.szName, "你获得了["..buffName.."]  "..sInfo)
							se_bSaid[buffName].bState = true
						end
					else
						seBoss_Say(seBoss_Set.bSayChannel, p.szName, "你获得了["..buffName.."]  "..sInfo)
					end
				end
			elseif nTarget == se_SELF and seBoss_Set.bSayChannel ~= PLAYER_TALK_CHANNEL.WHISPER then
				if playerID ~= GetClientPlayer().dwID then
					if ad_hoc_Bufflist[buffName] then
						if not se_bSaid[buffName].bState then
							seBoss_Say(seBoss_Set.bSayChannel, p.szName, "["..p.szName.."]获得了["..buffName.."]  "..sInfo)
							se_bSaid[buffName].bState = true
						end
					else
						seBoss_Say(seBoss_Set.bSayChannel, p.szName, "["..p.szName.."]获得了["..buffName.."]  "..sInfo)
					end
				end
			elseif nTarget == se_ALL and IsPlayer(playerID) then
				if seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.WHISPER then
					seBoss_Say(7, "" , "大家都获得了["..buffName.."]  "..sInfo)
				elseif seBoss_Set.bSayChannel ~= PLAYER_TALK_CHANNEL.WHISPER then
					if not se_bSaid[buffName].bState then
						seBoss_Say(seBoss_Set.bSayChannel, "" , "大家都获得了["..buffName.."]  "..sInfo)
						se_bSaid[buffName].bState = true
					end
				end
			else
				if seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.WHISPER then
					if ad_hoc_Bufflist[buffName] then
						if not se_bSaid[buffName].bState then
							seBoss_Say(7, "" , "["..p.szName.."]获得了["..buffName.."]  "..sInfo)
							se_bSaid[buffName].bState = true
						end
					else
						seBoss_Say(7, "" , "["..p.szName.."]获得了["..buffName.."]  "..sInfo)
					end
				elseif seBoss_Set.bSayChannel ~= PLAYER_TALK_CHANNEL.WHISPER then
					if ad_hoc_Bufflist[buffName] then 
						if not se_bSaid[buffName].bState then
							seBoss_Say(seBoss_Set.bSayChannel, p.szName , "["..p.szName.."]获得了["..buffName.."]  "..sInfo)
							se_bSaid[buffName].bState = true
						end
					else
						seBoss_Say(seBoss_Set.bSayChannel, p.szName , "["..p.szName.."]获得了["..buffName.."]  "..sInfo)
					end
				end
			end
		end
	end
end

function seBossTipsLogic.OnSkillCasting(playerID, skillID, skillLV)
	local skillName
	local bRed
	local bCenter
	local bSay
	local sInfo
	local r, g, b
	local bTimer
	local bSayTimer
	local nFrmCount
	skillName=Table_GetSkillName(skillID, skillLV)

	local p
	if GetPlayer(playerID) then
		p = GetPlayer(playerID)
	elseif GetNpc(playerID) then
		p = GetNpc(playerID)
	else
		return
	end

	local tarID
	_, tarID = p.GetTarget()

	local bFlash = false
	for i=1, #seBossTips, 1 do
		local fb = seBossTips[i]
		if fb.bOn then
			for j=1, #fb, 1 do
				local boss = fb[j]
				if boss.bOn then
					skilllist = boss["SkillList"]

					for i = 1, #skilllist, 1 do
						if skilllist[i].bOn and skilllist[i].name == skillName then
							bRed = skilllist[i].bRedAlarm
							bCenter = skilllist[i].bCenterAlarm
							bSay = skilllist[i].bSay
							sInfo = skilllist[i].sInfo
							nTarget = skilllist[i].nTarget
							bTimer = skilllist[i].bTimer
							bSayTimer = skilllist[i].bSayTimer
							nFrmCount = skilllist[i].nFrmCount
							bFlash = true
							r = skilllist[i].color.r
							g = skilllist[i].color.g
							b = skilllist[i].color.b
							break
						end
					end
				end
			end
		end
	end
	if bFlash then
		if bTimer then
			se_arg0 = skillID
			se_arg1 = skillLV
			se_arg2 = nFrmCount
			se_arg3 = bSayTimer and seBoss_Set.bSayTimer
			FireEvent("new_seSkillTimer")
		end
		if not seBoss_Set.bRedAlarm then
			bRed = false
		end
		if not seBoss_Set.bCenterAlarm then
			bCenter = false
		end

		if nTarget == se_SELF and tarID ~= GetClientPlayer().dwID then
			bRed = false
			bCenter = false
		end

		seRedAlarm.Flash(2, p.szName.." 正在释放 "..skillName.."  "..sInfo, bRed, bCenter, r, g, b)

		if seBoss_Set.bSay and bSay then
			seBoss_Say(seBoss_Set.nSayChannel, "", "["..p.szName.."]正在释放 "..skillName.."！ "..sInfo)
		end
	end
end

Wnd.OpenWindow("interface\\seBoss_BossTipsLogic\\seBoss_BossTipsLogic.ini", "seBossTipsLogic")