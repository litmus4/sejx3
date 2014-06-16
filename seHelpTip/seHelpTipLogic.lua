local se_SELF = 0
local se_ALL = 1

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seHelpTip] " .. table.concat(a, "\t").. "\n" )
end

_seHelpTipList = {
	nVersion = 3,
	bSayChannel = PLAYER_TALK_CHANNEL.NEARBY,
	bRedAlarm = true,
	bCenterAlarm = true,
	bSay = false,
	["BuffList"] = {
		["Self"] = {
			[1] = {
				bOn = true,
				name = "��������",
				bRedAlarm = true,
				bCenterAlarm = true,
				bSay = false,
				sInfo = "��Ҫʹ�ü��ܣ�",
				color = { r = 255, g = 0, b = 0, },
			},
			[2] = {
				bOn = true,
				name = "����ʽ",
				bRedAlarm = true,
				bCenterAlarm = true,
				bSay = false,
				sInfo = "���Ṧ��",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["Others"] = {
		},
	},
	["SkillList"] = {
		["Target"] = {
			[1] = {
				bOn = true,
				name = "��������",
				bRedAlarm = true,
				bCenterAlarm = true,
				bSay = false,
				sInfo = "��ϣ���ϣ���ϣ�",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["Others"] = {
			
		},
	},
}

seHelpTipList = {}

seHelpTipLogic = {

}

RegisterCustomData("seHelpTipList")

function seHelpTipLogic.Say(nChannel, szName, say)
	local player=GetClientPlayer() 
  player.Talk(nChannel, szName, {{type = "text", text = say}})
end

function seHelpTipLogic.OnFrameCreate()
	this:RegisterEvent("SYS_MSG")
	this:RegisterEvent("DO_SKILL_CAST")
	this:RegisterEvent("BUFF_UPDATE")
	this:RegisterEvent("CUSTOM_DATA_LOADED")
	this:RegisterEvent("seHelpTipLogic.Set")
	print("��Ŀ��ʾ Loaded by Ҷ���ࡢ������")
end

function seHelpTipLogic.OnFrameBreathe()
	
end

function seHelpTipLogic.OnEvent(event)
	if event == "CUSTOM_DATA_LOADED" and arg0 == "Role" then
		seOption.RegMenu(seHelpTipLogic.UpdateMenu)
		if seHelpTipList then
			if seHelpTipList.nVersion then
				if seHelpTipList.nVersion == _seHelpTipList.nVersion then
					return
				end
			end
		end
		seHelpTipList = _seHelpTipList
	elseif event == "BUFF_UPDATE" and arg5 > 0 then
		seHelpTipLogic.OnBuffUpdate(arg0, arg4, arg8)
	elseif event == "SYS_MSG" then
    if arg0 == "UI_OME_SKILL_CAST_LOG" then
    	--print(arg1, arg2, arg3, arg4, arg5, arg6)
    	seHelpTipLogic.OnSkillCasting(arg1, arg2, arg3)
    end
	end
end

function seHelpTipLogic.OnBuffUpdate(playerID, buffID, buffLV)
	local buffName
	local bRed
	local bCenter
	local bSay
	local sInfo
	local r, g, b
	buffName = Table_GetBuffName(buffID, buffLV)
	
	local p
	if GetPlayer(playerID) then
		p = GetPlayer(playerID)
	elseif GetNpc(playerID) then
		p = GetNpc(playerID)
	else
		return 
	end

	local bFlash = false
	if playerID == GetClientPlayer().dwID then
		for i = 1, #seHelpTipList["BuffList"]["Self"], 1 do
			if seHelpTipList["BuffList"]["Self"][i].bOn and seHelpTipList["BuffList"]["Self"][i].name == buffName then
				bRed = seHelpTipList["BuffList"]["Self"][i].bRedAlarm
				bCenter = seHelpTipList["BuffList"]["Self"][i].bCenterAlarm
				bSay = seHelpTipList["BuffList"]["Self"][i].bSay
				sInfo = seHelpTipList["BuffList"]["Self"][i].sInfo
				bFlash = true
				r = seHelpTipList["BuffList"]["Self"][i].color.r
				g = seHelpTipList["BuffList"]["Self"][i].color.g
				b = seHelpTipList["BuffList"]["Self"][i].color.b
			end
		end
	else
		for i = 1, #seHelpTipList["BuffList"]["Others"], 1 do
			if seHelpTipList["BuffList"]["Others"][i].bOn and seHelpTipList["BuffList"]["Others"][i].name == buffName then
				bRed = seHelpTipList["BuffList"]["Others"][i].bRedAlarm
				bCenter = seHelpTipList["BuffList"]["Others"][i].bCenterAlarm
				bSay = seHelpTipList["BuffList"]["Others"][i].bSay
				sInfo = seHelpTipList["BuffList"]["Others"][i].sInfo
				bFlash = true
				r = seHelpTipList["BuffList"]["Others"][i].color.r
				g = seHelpTipList["BuffList"]["Others"][i].color.g
				b = seHelpTipList["BuffList"]["Others"][i].color.b
			end
		end
	end
	
	if bFlash then
		if not seHelpTipList.bRedAlarm then
			bRed = false
		end
		if not seHelpTipList.bCenterAlarm then
			bCenter = false
		end
		seRedAlarm.Flash(2, p.szName.." ����� "..buffName, bRed, bCenter, r, g, b)
		if seHelpTipList.bSay and bSay then
			seHelpTipLogic.Say(seHelpTipList.bSayChannel, "", p.szName.." ����� "..buffName.."�� "..sInfo)
		end
	end
end

function seHelpTipLogic.OnSkillCasting(playerID, skillID, skillLV)
	local skillName
	local bRed
	local bCenter
	local bSay
	local sInfo
	local r, g, b
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
	_, tarID = GetClientPlayer().GetTarget()
	
	local bFlash = false
	if playerID == tarID then
		for i = 1, #seHelpTipList["SkillList"]["Target"], 1 do
			if seHelpTipList["SkillList"]["Target"][i].bOn and seHelpTipList["SkillList"]["Target"][i].name == skillName then
				bRed = seHelpTipList["SkillList"]["Target"][i].bRedAlarm
				bCenter = seHelpTipList["SkillList"]["Target"][i].bCenterAlarm
				bSay = seHelpTipList["SkillList"]["Target"][i].bSay
				sInfo = seHelpTipList["SkillList"]["Target"][i].sInfo
				bFlash = true
				r = seHelpTipList["SkillList"]["Target"][i].color.r
				g = seHelpTipList["SkillList"]["Target"][i].color.g
				b = seHelpTipList["SkillList"]["Target"][i].color.b
			end
		end
	elseif playerID ~= GetClientPlayer().dwID then
		for i = 1, #seHelpTipList["SkillList"]["Others"], 1 do
			if seHelpTipList["SkillList"]["Others"][i].bOn and seHelpTipList["SkillList"]["Others"][i].name == skillName then
				bRed = seHelpTipList["SkillList"]["Others"][i].bRedAlarm
				bCenter = seHelpTipList["SkillList"]["Others"][i].bCenterAlarm
				bSay = seHelpTipList["SkillList"]["Others"][i].bSay
				sInfo = seHelpTipList["SkillList"]["Others"][i].sInfo
				bFlash = true
				r = seHelpTipList["SkillList"]["Others"][i].color.r
				g = seHelpTipList["SkillList"]["Others"][i].color.g
				b = seHelpTipList["SkillList"]["Others"][i].color.b
			end
		end
	end
	if bFlash then
		if not seHelpTipList.bRedAlarm then
			bRed = false
		end
		if not seHelpTipList.bCenterAlarm then
			bCenter = false
		end
		seRedAlarm.Flash(2, p.szName.." �����ͷ� "..skillName, bRed, bCenter, r, g, b)
		if seHelpTipList.bSay and bSay then
			seHelpTipLogic.Say(seHelpTipList.bSayChannel, "", p.szName.." �����ͷ� "..skillName.."�� "..sInfo)
		end
	end
end

function seHelpTipLogic.OnFrameBreathe()
	
end

function seHelpTipLogic.UpdateList(strType1, strType2, szName)
	for i = 1, #seHelpTipList[strType1][strType2], 1 do
		if seHelpTipList[strType1][strType2][i].name == szName then
			return
		end
	end
	table.insert(seHelpTipList[strType1][strType2], {bOn = true, name = szName,	bRedAlarm = true,	bCenterAlarm = true, bSay = false, sInfo = "", color = {r = 255, g = 0, b = 0}})
end

function seHelpTipLogic.GetMenu(sType, sTarget, szName)
	local menu = 
	{	
		szOption = szName,
	}
	for i = 1, #seHelpTipList[sType][sTarget], 1 do
		local m = {
			szOption = seHelpTipList[sType][sTarget][i].name, 
			bCheck = true,
			bChecked = seHelpTipList[sType][sTarget][i].bOn,
			fnAction = function() 
				seHelpTipList[sType][sTarget][i].bOn = not seHelpTipList[sType][sTarget][i].bOn
			end, 
			fnAutoClose = function() 
				return true 
			end
		}
		local m_1 = {
			szOption = "��Ļ����",			bCheck = true,			bChecked =  seHelpTipList[sType][sTarget][i].bRedAlarm,
			fnAction = function()
				seHelpTipList[sType][sTarget][i].bRedAlarm = not seHelpTipList[sType][sTarget][i].bRedAlarm
			end,
			bColorTable = true,
			rgb = {
				seHelpTipList[sType][sTarget][i].color.r,
				seHelpTipList[sType][sTarget][i].color.g,
				seHelpTipList[sType][sTarget][i].color.b,
			},
			fnChangeColor = function(UserData, r, g, b)
				seHelpTipList[sType][sTarget][i].color.r = r
				seHelpTipList[sType][sTarget][i].color.g = g
				seHelpTipList[sType][sTarget][i].color.b = b
			end,
			fnAutoClose = function() 
				return true 
			end
		}
		local m_2 = {
			szOption = "��������",			bCheck = true,			bChecked =  seHelpTipList[sType][sTarget][i].bCenterAlarm,
			fnAction = function()
				seHelpTipList[sType][sTarget][i].bCenterAlarm = not seHelpTipList[sType][sTarget][i].bCenterAlarm
			end,
			fnAutoClose = function() 
				return true 
			end
		}
		local m_3 = {
			szOption = "����ͨ��",			bCheck = true,			bChecked =  seHelpTipList[sType][sTarget][i].bSay,
			fnAction = function()
				seHelpTipList[sType][sTarget][i].bSay = not seHelpTipList[sType][sTarget][i].bSay
			end,
			fnAutoClose = function() 
				return true 
			end
		}
		local m_3_1 = {
			szOption = seHelpTipList[sType][sTarget][i].sInfo,
		}
		local m_3_2 = {
			szOption = "�޸���ʾ",
			fnAction = function()
				GetUserInput("���븽����ʾ��Ϣ��", function(szText) seHelpTipList[sType][sTarget][i].sInfo = szText end, nil, nil, nil, nil, 20)
			end,
		}
		
		table.insert(m_3, m_3_1)
		table.insert(m_3, {bDevide = true})
		table.insert(m_3, m_3_2)
		
		table.insert(m, m_1)
		table.insert(m, m_2)
		table.insert(m, m_3)
		table.insert(m, {bDevide = true} )
		local m_4 = {
			szOption = "ɾ��",
			fnAction = function()
				table.remove(seHelpTipList[sType][sTarget], i)
			end,
		}
		table.insert(m, m_4)
		table.insert(menu, m)
	end
	table.insert(menu, {bDevide = true})
	local m = {
		szOption = "���",
		fnAction = function()
			GetUserInput("�������ƣ�", function(szText) seHelpTipLogic.UpdateList(sType, sTarget, szText) end, nil, nil, nil, nil, 20)
		end,
	}
	table.insert(menu, m)
	return menu
end

function seHelpTipLogic.UpdateMenu()
	local menu = {
		szOption = "seHelpTip ��Ŀ��ʾ", 
	}
	--red_alarm
	local red_alarm = {
		szOption = "ȫ��������ʾ",
		bCheck = true,
		bChecked = seHelpTipList.bRedAlarm,
		fnAction = function()
			seHelpTipList.bRedAlarm = not seHelpTipList.bRedAlarm
		end,
		fnAutoClose = function() 
			return true 
		end,
	}
	table.insert(menu, red_alarm)
	--center_alarm
	local center_alarm = {
		szOption = "����������ʾ",
		bCheck = true,
		bChecked = seHelpTipList.bCenterAlarm,
		fnAction = function()
			seHelpTipList.bCenterAlarm = not seHelpTipList.bCenterAlarm
		end,
		fnAutoClose = function() 
			return true 
		end,
	}
	table.insert(menu, center_alarm)
	--bSay,
	local say_alarm = {
		szOption = "����ͨ����ʾ",
		bCheck = true,
		bChecked = seHelpTipList.bSay,
		fnAction = function()
			seHelpTipList.bSay = not seHelpTipList.bSay
		end,
		fnAutoClose = function() 
			return true 
		end,
	}
	table.insert(menu, say_alarm)
	
	
	table.insert(menu, {bDevide = true} )
--[[	
	if seBossTips.GetMenu then
		table.insert(menu, seBossTips.GetMenu() )
	end
	]]
	local m_help = {
		szOption = "�Զ���ģ��"
	}
	--menu_buff
	local menu_buff = {
		szOption = "��ʾ״̬ѡ��",
	}

	table.insert(menu_buff, seHelpTipLogic.GetMenu("BuffList", "Self", "����״̬"))
	table.insert(menu_buff, seHelpTipLogic.GetMenu("BuffList","Others", "����״̬"))
	table.insert(m_help, menu_buff )
	
	--menu_skill
	local menu_skill = {
		szOption = "��ʾ����ѡ��",
	}
	
	table.insert(menu_skill, seHelpTipLogic.GetMenu("SkillList","Target", "Ŀ�����"))
	table.insert(menu_skill, seHelpTipLogic.GetMenu("SkillList","Others", "���˶���"))
	table.insert(m_help, menu_skill )
	
	table.insert(menu, m_help)
	
	--channel
	local menu_channel = {
		szOption = "ͨ��Ƶ��ѡ��",
		{szOption = g_tStrings.tChannelName.MSG_NORMAL, bMCheck = true, bChecked = seHelpTipList.bSayChannel == PLAYER_TALK_CHANNEL.NEARBY, rgb = GetMsgFontColor("MSG_NORMAL", true), fnAction = function() seHelpTipList.bSayChannel = PLAYER_TALK_CHANNEL.NEARBY end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_PARTY, bMCheck = true, bChecked = seHelpTipList.bSayChannel == PLAYER_TALK_CHANNEL.TEAM, rgb = GetMsgFontColor("MSG_PARTY", true), fnAction = function() seHelpTipList.bSayChannel = PLAYER_TALK_CHANNEL.TEAM end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_TEAM, bMCheck = true, bChecked = seHelpTipList.bSayChannel == PLAYER_TALK_CHANNEL.RAID, rgb = GetMsgFontColor("MSG_TEAM", true), fnAction = function() seHelpTipList.bSayChannel = PLAYER_TALK_CHANNEL.RAID end, fnAutoClose = function() return true end},
		{szOption = "NPCƵ��", bMCheck = true, bChecked = seHelpTipList.bSayChannel == 7, fnAction = function() seHelpTipList.bSayChannel = 7 end, rgb = GetMsgFontColor("MSG_NPC_NEARBY", true), fnAutoClose = function() return true end},
	}
	table.insert(menu, menu_channel)
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by Ҷ���ࡢ������",})
	--table.insert(menu, {bDevide = true} )
	return menu
end


Wnd.OpenWindow("interface\\seHelpTip\\seHelpTipLogic.ini", "seHelpTipLogic")