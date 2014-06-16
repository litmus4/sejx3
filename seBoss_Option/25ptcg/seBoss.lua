local se_SELF = 0
local se_ALL = 1

local cgtwd = {
	bOn = true,
	szName = "25人普通持国天王殿",
	[1] = {
		szName = "提多罗吒",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "天绝华散曲·白露",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "快去[左上角]的>>瓶子<<！",
				color = { r = 255, g = 255, b = 255, },
			},
                        [2] = {
				bOn = true,
				name = "天绝华散曲·碧海",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "快去[右上角]的>>舟<<！",
				color = { r = 0, g = 255, b = 0, },
			},
                        [3] = {
				bOn = true,
				name = "天绝华散曲·朱云",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "快去[右下角]的>>鹤<<！",
				color = { r = 255, g = 0, b = 0, },
			},
                        [4] = {
				bOn = true,
				name = "天绝华散曲·黑洞",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "快去[左下角]的>>灯<<！",
				color = { r = 192, g = 192, b = 192, },
			},
                        [5] = {
				bOn = true,
				name = "天国镇魂曲·普渡八音",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "快去打[右边]的>>琴<<！",
				color = { r = 255, g = 0, b = 0, },
			},
                        [6] = {
				bOn = true,
				name = "天国镇魂曲·破静天门",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "快去打[下边]的>>鼓<<！",
				color = { r = 255, g = 0, b = 0, },
			},
                        [7] = {
				bOn = true,
				name = "天国镇魂曲·欲吐地葬",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "快去打[左边]的>>钟<<！",
				color = { r = 255, g = 0, b = 0, },
			},
                        [8] = {
				bOn = true,
				name = "天国镇魂曲·镇魂长曲",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "快去打[上边]的>>铃<<！",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "九音陀罗曲·刚震",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "注意跳跃!",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 240,
			},
		},
	},
}

table.insert(seBossTips, cgtwd)