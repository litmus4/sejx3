local se_SELF = 0
local se_ALL = 1

local gzswyj = {
	bOn = true,
	szName = "25����ͨ���������ż�",
	[1] = {
		szName = "л����",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "��Ӱ����",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��Ȧ�ʹ�!",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�Ӻϡ����",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "ע���ҡ��",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 800,
			},

		},
	},
}
table.insert(seBossTips, gzswyj)