local se_SELF = 0
local se_ALL = 1

local zbjl = {
	bOn = true,
	szName = "战宝迦兰",
	[1] = {
		szName = "王海银",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "摧城枪·撕喉",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "速度驱散！",
				color = { r = 255, g = 128, b = 64, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "熊！熊！熊！",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "打断！打断！打断！",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 704,
			},
		},
	},
	[2] = {
		szName = "朱癸",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "虫蛊·销魂",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "迅速排毒！",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "镇龙头",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "御！御！御！",
				color = { r = 128, g = 255, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 512,
			},
			
			[2] = {
				bOn = true,
				name = "蛇蛊·葵之甲",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "停止输出！驱散！",
				color = { r = 0, g = 255, b = 255, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 741,
			},
		},
	},
	[3] = {
		szName = "平等",
		bOn = true,
		["BuffList"] = {
			
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "王眼镇魂",
				bRedAlarm = false,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "后翻!",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 492,
			},
		},
	},
	[4] = {
		szName = "掌火",
		bOn = true,
		["BuffList"] = {

		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "融火经·佛西归",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "御！断骨诀！扶摇！",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 1040,
			},
		},
	},
	[5] = {
		szName = "镇恶",
		bOn = true,
		["BuffList"] = {

		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "破冰真气",
				bRedAlarm = false,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = false,
				sInfo = "加血!",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 154,
			},
		},
	},
	[6] = {
		szName = "风 火 云",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "如坐春风",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "驱散！驱散！",
				color = { r = 0, g = 255, b = 128, },
			},
			
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "餐风饮露",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "打断！打断！打断！",
				color = { r = 255, g = 128, b = 64, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 220,
			},

		},
        },
	[7] = {
		szName = "千手观音",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "梵音轮回咒",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "倒计时结束前靠近队友!",
				color = { r = 255, g = 0, b = 0, },
			},	
			[2] = {
				bOn = true,
				name = "追击",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "风筝无我!",
				color = { r = 255, g = 0, b = 0, },
			},	
			[3] = {
				bOn = true,
				name = "禁锢咒",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "靠墙驱散!",
				color = { r = 255, g = 0, b = 0, },
			},	
		},
		["SkillList"] = {},
	},
}

table.insert(seBossTips, zbjl)