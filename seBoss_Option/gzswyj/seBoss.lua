local se_SELF = 0
local se_ALL = 1

local gzswyj = {
	bOn = true,
	szName = "¹¬ÖÐÉñÎäÒÅ¼£",
	[1] = {
		szName = "Ð»ÔÆÁ÷",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "½¥Ó°ÄýÊÓ",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "½øÈ¦ÃÍ´ò!",
				color = { r = 255, g = 0, b = 0, },
			},
                        [2] = {
				bOn = true,
				name = "½£³åÒõÑô",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "ÔÆÉÑÇýÉ¢£¡",
				color = { r = 255, g = 0, b = 0, },
                        },
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "¾ÓºÏ¡¤¹á³Ï",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "×¢Òâ·öÒ¡£¡×¢Òâ·öÒ¡£¡",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 800,
			},
		},
	},
	
}
table.insert(seBossTips, gzswyj)