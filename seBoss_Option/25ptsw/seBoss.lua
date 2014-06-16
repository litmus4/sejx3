local se_SELF = 0
local se_ALL = 1

local gzswyj = {
	bOn = true,
	szName = "25人普通宫中神武遗迹",
	[1] = {
		szName = "谢云流",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "渐影凝视",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "进圈猛打!",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "居合·贯诚",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "注意扶摇！",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 800,
			},

		},
	},
}
table.insert(seBossTips, gzswyj)