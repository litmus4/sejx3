local se_SELF = 0
local se_ALL = 1

local zbjl = {
	bOn = true,
	szName = "ս������",
	[1] = {
		szName = "������",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "�ݳ�ǹ��˺��",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "�ٶ���ɢ��",
				color = { r = 255, g = 128, b = 64, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�ܣ��ܣ��ܣ�",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ϣ���ϣ���ϣ�",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 704,
			},
		},
	},
	[2] = {
		szName = "���",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "��ơ�����",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "Ѹ���Ŷ���",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "����ͷ",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "������������",
				color = { r = 128, g = 255, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 512,
			},
			
			[2] = {
				bOn = true,
				name = "�߹ơ���֮��",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "ֹͣ�������ɢ��",
				color = { r = 0, g = 255, b = 255, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 741,
			},
		},
	},
	[3] = {
		szName = "ƽ��",
		bOn = true,
		["BuffList"] = {
			
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�������",
				bRedAlarm = false,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��!",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 492,
			},
		},
	},
	[4] = {
		szName = "�ƻ�",
		bOn = true,
		["BuffList"] = {

		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�ڻ𾭡�������",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "�����ϹǾ�����ҡ��",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 1040,
			},
		},
	},
	[5] = {
		szName = "���",
		bOn = true,
		["BuffList"] = {

		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�Ʊ�����",
				bRedAlarm = false,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = false,
				sInfo = "��Ѫ!",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 154,
			},
		},
	},
	[6] = {
		szName = "�� �� ��",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "��������",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ɢ����ɢ��",
				color = { r = 0, g = 255, b = 128, },
			},
			
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�ͷ���¶",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ϣ���ϣ���ϣ�",
				color = { r = 255, g = 128, b = 64, },
				
				bTimer = true,
				bSayTimer = false,
				nFrmCount = 220,
			},

		},
        },
	[7] = {
		szName = "ǧ�ֹ���",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "�����ֻ���",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "����ʱ����ǰ��������!",
				color = { r = 255, g = 0, b = 0, },
			},	
			[2] = {
				bOn = true,
				name = "׷��",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��������!",
				color = { r = 255, g = 0, b = 0, },
			},	
			[3] = {
				bOn = true,
				name = "������",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��ǽ��ɢ!",
				color = { r = 255, g = 0, b = 0, },
			},	
		},
		["SkillList"] = {},
	},
}

table.insert(seBossTips, zbjl)