local se_SELF = 0
local se_ALL = 1

local zbjl = {
	bOn = true,
	szName = "Ӣ��ս������",
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
				sInfo = "ע���ޡ���T��ס",
				color = { r = 255, g = 0, b = 0, },

				bTimer = true,
				bSayTimer = true,
				nFrmCount = 120 * 16,
			},
			[2] = {
				bOn = true,
				name = "�ݳ�ǹ�����",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "���ˣ�����",
				color = { r = 255, g = 0, b = 0, },

				bTimer = true,
				bSayTimer = false,
				nFrmCount = 30 * 16,
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
				sInfo = "ע���Ŷ�!",
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
				nFrmCount = 496,
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
				nFrmCount = 736,
			},
		},
	},
	[3] = {
		szName = "ƽ��",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "������ѩ",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "ע�������",
				color = { r = 255, g = 255, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "�������",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,

				bSay = true,
				sInfo = "�ٶ�վλ",
				color = { r = 255, g = 0, b = 0, },

				bTimer = true,
				bSayTimer = true,
				nFrmCount = 16 * 100,
			},
		},
	},
	[4] = {
		szName = "�ƻ�",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "ע��",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "ֹͣ������",
				color = { r = 255, g = 0, b = 0, },
			},
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
			[1] = {
				bOn = true,
				name = "�Ʊ���",
				bRedAlarm = false,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "ע������",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {},
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

				bSay = false,
				sInfo = "ע����ɢ!",
				color = { r = 0, g = 255, b = 0, },
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
				sInfo = "��ϣ���ϣ�",
				color = { r = 255, g = 0, b = 0, },

                                bTimer = true,
				bSayTimer = false,
				nFrmCount = 224,
			},
			[2] = {
				bOn = true,
				name = "�������",
				bRedAlarm = false,
				bCenterAlarm = false,
				nTarget = se_ALL,

				bSay = false,
				sInfo = "",
				color = { r = 255, g = 0, b = 0, },

                                bTimer = true,
				bSayTimer = false,
				nFrmCount = 352,
		        },
			[3] = {
				bOn = true,
				name = "��ˮǧɽ",
				bRedAlarm = false,
				bCenterAlarm = false,
				nTarget = se_ALL,

				bSay = false,
				sInfo = "",
				color = { r = 0, g = 255, b = 0, },

                                bTimer = true,
				bSayTimer = false,
				nFrmCount = 336,
		        },
			[4] = {
				bOn = true,
				name = "�桤����",
				bRedAlarm = false,
				bCenterAlarm = false,
				nTarget = se_ALL,

				bSay = false,
				sInfo = "",
				color = { r = 255, g = 0, b = 0, },

                                bTimer = true,
				bSayTimer = false,
				nFrmCount = 1024,
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
				sInfo = "����ʱ����ǰ��������2��",
				color = { r = 255, g = 0, b = 0, },
			},
			[2] = {
				bOn = true,
				name = "׷��",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "��������",
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