local se_SELF = 0
local se_ALL = 1

local cgtwd = {
	bOn = true,
	szName = "25����ͨ�ֹ�������",
	[1] = {
		szName = "�����߸",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "�����ɢ������¶",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��ȥ[���Ͻ�]��>>ƿ��<<��",
				color = { r = 255, g = 255, b = 255, },
			},
                        [2] = {
				bOn = true,
				name = "�����ɢ�����̺�",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��ȥ[���Ͻ�]��>>��<<��",
				color = { r = 0, g = 255, b = 0, },
			},
                        [3] = {
				bOn = true,
				name = "�����ɢ��������",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��ȥ[���½�]��>>��<<��",
				color = { r = 255, g = 0, b = 0, },
			},
                        [4] = {
				bOn = true,
				name = "�����ɢ�����ڶ�",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,
				
				bSay = true,
				sInfo = "��ȥ[���½�]��>>��<<��",
				color = { r = 192, g = 192, b = 192, },
			},
                        [5] = {
				bOn = true,
				name = "�����������նɰ���",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ȥ��[�ұ�]��>>��<<��",
				color = { r = 255, g = 0, b = 0, },
			},
                        [6] = {
				bOn = true,
				name = "�����������ƾ�����",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ȥ��[�±�]��>>��<<��",
				color = { r = 255, g = 0, b = 0, },
			},
                        [7] = {
				bOn = true,
				name = "�������������µ���",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ȥ��[���]��>>��<<��",
				color = { r = 255, g = 0, b = 0, },
			},
                        [8] = {
				bOn = true,
				name = "������������곤��",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "��ȥ��[�ϱ�]��>>��<<��",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "����������������",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,
				
				bSay = true,
				sInfo = "ע����Ծ!",
				color = { r = 255, g = 0, b = 0, },
				
				bTimer = true,
				bSayTimer = true,
				nFrmCount = 240,
			},
		},
	},
}

table.insert(seBossTips, cgtwd)