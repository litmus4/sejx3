local se_SELF = 0
local se_ALL = 1

local zbjl = {
	bOn = true,
	szName = "英雄战宝迦兰",
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
				sInfo = "注意仇恨。副T接住",
				color = { r = 255, g = 0, b = 0, },

				bTimer = true,
				bSayTimer = true,
				nFrmCount = 120 * 16,
			},
			[2] = {
				bOn = true,
				name = "摧城枪·碎骨",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "减伤！御！",
				color = { r = 255, g = 0, b = 0, },

				bTimer = true,
				bSayTimer = false,
				nFrmCount = 30 * 16,
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
				sInfo = "注意排毒!",
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
				nFrmCount = 496,
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
				nFrmCount = 736,
			},
		},
	},
	[3] = {
		szName = "平等",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "佛心融雪",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "注意回蓝！",
				color = { r = 255, g = 255, b = 0, },
			},
		},
		["SkillList"] = {
			[1] = {
				bOn = true,
				name = "王眼镇魂",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_ALL,

				bSay = true,
				sInfo = "速度站位",
				color = { r = 255, g = 0, b = 0, },

				bTimer = true,
				bSayTimer = true,
				nFrmCount = 16 * 100,
			},
		},
	},
	[4] = {
		szName = "掌火",
		bOn = true,
		["BuffList"] = {
			[1] = {
				bOn = true,
				name = "注视",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "停止动作！",
				color = { r = 255, g = 0, b = 0, },
			},
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
			[1] = {
				bOn = true,
				name = "破冰掌",
				bRedAlarm = false,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "注意治疗",
				color = { r = 255, g = 0, b = 0, },
			},
		},
		["SkillList"] = {},
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

				bSay = false,
				sInfo = "注意驱散!",
				color = { r = 0, g = 255, b = 0, },
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
				sInfo = "打断！打断！",
				color = { r = 255, g = 0, b = 0, },

                                bTimer = true,
				bSayTimer = false,
				nFrmCount = 224,
			},
			[2] = {
				bOn = true,
				name = "火光烛天",
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
				name = "万水千山",
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
				name = "真·烧云",
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
				sInfo = "倒计时结束前靠近队友2尺",
				color = { r = 255, g = 0, b = 0, },
			},
			[2] = {
				bOn = true,
				name = "追击",
				bRedAlarm = true,
				bCenterAlarm = true,
				nTarget = se_SELF,

				bSay = true,
				sInfo = "风筝无我",
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