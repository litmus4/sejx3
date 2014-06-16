se_SELF = 0
se_ALL = 1

seBoss_Set = {
nVersion = 1.89,
    bSayChannel = PLAYER_TALK_CHANNEL.NEARBY,
	SayChannel = PLAYER_TALK_CHANNEL.NEARBY,
	bRedAlarm = true,
	bCenterAlarm = true,
	bSay = false,
	bSayTimer = false,
	bPublic = false,
}

RegisterCustomData("seBoss_Set.bSayChannel")
RegisterCustomData("seBoss_Set.nSayChannel")
RegisterCustomData("seBoss_Set.bRedAlarm")
RegisterCustomData("seBoss_Set.bCenterAlarm")
RegisterCustomData("seBoss_Set.bSay")
RegisterCustomData("seBoss_Set.bSayTimer")
RegisterCustomData("seBoss_Set.bPublic")

seBoss_Option = {
}

seBossTips = {
}

function seBoss_Option.OnFrameCreate()
	this:RegisterEvent("ON_BG_CHANNEL_MSG")
	this:RegisterEvent("CUSTOM_DATA_LOADED")
end

function seBoss_Option.OnEvent(event)
	if event == "CUSTOM_DATA_LOADED" and arg0 == "Role" then
		seOption.RegMenu(seBossTips.GetMenu)
	elseif event == "ON_BG_CHANNEL_MSG" then
		local player = GetClientPlayer()
		local t = player.GetTalkData()
		if t and t[2] and t[2].text == "SayAbout" and player.szName ~= arg3 then
			seBoss_SayAbout()
		end
		if t and t[2] and t[2].text == "MyAbout" then
			seBoss_print(t[3].text)
		end
	end
end

Wnd.OpenWindow("interface\\seBoss_Option\\seBoss_Option.ini", "seBoss_Option")

function seBossTips.GetMenu()
	local total_menu = {szOption = "seBoss ����ģ��",}
	--red_alarm
	local red_alarm = {
		szOption = "ȫ��������ʾ",
		bCheck = true,
		bChecked = seBoss_Set.bRedAlarm,
		fnAction = function()
			seBoss_Set.bRedAlarm = not seBoss_Set.bRedAlarm
		end,
		fnAutoClose = function()
			return true
		end,
	}
	table.insert(total_menu, red_alarm)
	--center_alarm
	local center_alarm = {
		szOption = "����������ʾ",
		bCheck = true,
		bChecked = seBoss_Set.bCenterAlarm,
		fnAction = function()
			seBoss_Set.bCenterAlarm = not seBoss_Set.bCenterAlarm
		end,
		fnAutoClose = function()
			return true
		end,
	}
	table.insert(total_menu, center_alarm)
	--bSay,
	local say_alarm = {
		szOption = "����ͨ����ʾ",
		bCheck = true,
		bChecked = seBoss_Set.bSay,
		fnAction = function()
			seBoss_Set.bSay = not seBoss_Set.bSay
		end,
		fnAutoClose = function()
			return true
		end,
	}
	table.insert(total_menu, say_alarm)
	--timer
	local menu_timer = {
		szOption = "����ʱ����",
		{szOption = "λ������", bCheck = true, bChecked = not seSkillTimerAnchor.bDragable, fnAction = function() seSkillTimerAnchor.bDragable = not seSkillTimerAnchor.bDragable seSkillTimerAnchor.UpdateDrag() end,},
		{
			szOption = "���������㲥",
			bCheck = true,
			bChecked = seBoss_Set.bSayTimer,
			fnAction = function()
				seBoss_Set.bSayTimer = not seBoss_Set.bSayTimer
			end,
			fnAutoClose = function()
				return true
			end,
		},
		{bDevide = true},
		{szOption = "������ʾ", fnAction = function() StartNewSkillTimer(537, 5, 20*16, false) StartNewSkillTimer(542, 7, 15*16, false) StartNewSkillTimer(560, 1, 10*16, false) StartNewSkillTimer(572, 1, 5*16, false)  end}
	}
	table.insert(total_menu, menu_timer)
	--bPublic
	local public_alarm = {
		szOption = "�ŶӺ�̨�㲥",
		bCheck = true,
		bChecked = seBoss_Set.bPublic,
		fnAction = function()
			seBoss_Set.bPublic = not seBoss_Set.bPublic
		end,
		fnAutoClose = function()
			return true
		end,
	}
	table.insert(total_menu, public_alarm)

	table.insert(total_menu, {bDevide = true} )


	local menu = { szOption = "Ԥ������ģ��"}
	for i=1, #seBossTips, 1 do
		local fb = seBossTips[i]
		local m = {
			szOption = fb.szName,
			bCheck = true,
			bChecked = fb.bOn,
			fnAction = function()
				fb.bOn = not fb.bOn
			end,
			fnAutoClose = function()
				return true
			end
		}
		for j=1, #fb, 1 do
			local fb_boss = fb[j]
			local m_b = {
				szOption = fb_boss.szName,
				bCheck = true,
				bChecked = fb_boss.bOn,
				fnAction = function()
					fb_boss.bOn = not fb_boss.bOn
				end,
				fnAutoClose = function()
					return true
				end
			}
			bufflist = fb_boss["BuffList"]
			skilllist = fb_boss["SkillList"]
			for k=1, #bufflist, 1 do
				local m_b_m = {
					szOption = bufflist[k].name,
					bCheck = true,
					bChecked = bufflist[k].bOn,
					fnAction = function()
						fb_boss["BuffList"][k].bOn = not fb_boss["BuffList"][k].bOn
					end,
					fnAutoClose = function()
						return true
					end
				}
				table.insert(m_b, m_b_m)
			end
			for k=1, #skilllist, 1 do
				local m_b_m = {
					szOption = skilllist[k].name,
					bCheck = true,
					bChecked = skilllist[k].bOn,
					fnAction = function()
						fb_boss["SkillList"][k].bOn = not fb_boss["SkillList"][k].bOn
					end,
					fnAutoClose = function()
						return true
					end
				}
				table.insert(m_b, m_b_m)
			end
			table.insert(m, m_b)
		end
		table.insert(menu, m)
	end
	table.insert(total_menu, menu)

	--channel
	local menu_channel = {
		szOption = "״̬ͨ��Ƶ��ѡ��",
	        {szOption = "�ر�",bMCheck = true, bChecked = (seBoss_Set.bSayChannel==false), fnAction = function() seBoss_Set.bSayChannel=false end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_NORMAL, bMCheck = true, bChecked = seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.NEARBY, rgb = GetMsgFontColor("MSG_NORMAL", true), fnAction = function() seBoss_Set.bSayChannel = PLAYER_TALK_CHANNEL.NEARBY end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_PARTY, bMCheck = true, bChecked = seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.TEAM, rgb = GetMsgFontColor("MSG_PARTY", true), fnAction = function() seBoss_Set.bSayChannel = PLAYER_TALK_CHANNEL.TEAM end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_TEAM, bMCheck = true, bChecked = seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.RAID, rgb = GetMsgFontColor("MSG_TEAM", true), fnAction = function() seBoss_Set.bSayChannel = PLAYER_TALK_CHANNEL.RAID end, fnAutoClose = function() return true end},
		{szOption = "NPCƵ��", bMCheck = true, bChecked = seBoss_Set.bSayChannel == 7, fnAction = function() seBoss_Set.bSayChannel = 7 end, rgb = GetMsgFontColor("MSG_NPC_NEARBY", true), fnAutoClose = function() return true end},
                {szOption = "����Ƶ��", bMCheck = true, bChecked = seBoss_Set.bSayChannel == PLAYER_TALK_CHANNEL.WHISPER, fnAction = function() seBoss_Set.bSayChannel = PLAYER_TALK_CHANNEL.WHISPER end, rgb = GetMsgFontColor("MSG_WHISPER", true), fnAutoClose = function() return true end},
	}
	table.insert(total_menu, menu_channel)

	--channel
	local menu_channel = {
		szOption = "����ͨ��Ƶ��ѡ��",
	        {szOption = "�ر�",bMCheck = true, bChecked = (seBoss_Set.nSayChannel==false), fnAction = function() seBoss_Set.nSayChannel=false end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_NORMAL, bMCheck = true, bChecked = seBoss_Set.nSayChannel == PLAYER_TALK_CHANNEL.NEARBY, rgb = GetMsgFontColor("MSG_NORMAL", true), fnAction = function() seBoss_Set.nSayChannel = PLAYER_TALK_CHANNEL.NEARBY end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_PARTY, bMCheck = true, bChecked = seBoss_Set.nSayChannel == PLAYER_TALK_CHANNEL.TEAM, rgb = GetMsgFontColor("MSG_PARTY", true), fnAction = function() seBoss_Set.nSayChannel = PLAYER_TALK_CHANNEL.TEAM end, fnAutoClose = function() return true end},
		{szOption = g_tStrings.tChannelName.MSG_TEAM, bMCheck = true, bChecked = seBoss_Set.nSayChannel == PLAYER_TALK_CHANNEL.RAID, rgb = GetMsgFontColor("MSG_TEAM", true), fnAction = function() seBoss_Set.nSayChannel = PLAYER_TALK_CHANNEL.RAID end, fnAutoClose = function() return true end},
		{szOption = "NPCƵ��", bMCheck = true, bChecked = seBoss_Set.nSayChannel == 7, fnAction = function() seBoss_Set.nSayChannel = 7 end, rgb = GetMsgFontColor("MSG_NPC_NEARBY", true), fnAutoClose = function() return true end},
	}
	table.insert(total_menu, menu_channel)

	--version_check
	local menu_check = {
		szOption = "���ڰ汾���",
		fnAction = function()
			ShareShowAbout()
			seBoss_SayAbout()
		end,
	}
	table.insert(total_menu, menu_check)
	table.insert(total_menu, {bDevide = true} )
	table.insert(total_menu, {szOption = "Create by ������",})
	table.insert(total_menu, {szOption = "Patch by �������С˾",})
	return total_menu
end
