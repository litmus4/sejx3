--[[
y	arg0,  playerID
y	arg1,  false = 获得  true = 丢失
	arg2,  index
	arg3,  true = buff false = debuff
y	arg4,  buffID
y	arg5,  层数
y	arg6,  Endframe
	arg7,  修正
y	arg8,  buffLV
	arg9
]]

seEventAlert = {
	tBuffNames = {
		{ szName = "阳白",	bOn = true,},
		{ szName = "本神",	bOn = true,},
		{ szName = "气穴",	bOn = true,},
		{ szName = "风府",	bOn = true,},
		{ szName = "外丘",	bOn = true,},
		{ szName = "关门",	bOn = true,},
		{ szName = "百合",	bOn = true,},
	},
	tBuffNamesByKongfu = {
		--剑纯
		[10015] = {
			{ szName = "转乾坤", bOn = true,},
			{ szName = "韬光养晦", bOn = true,},
		},
		--气纯
		[10014] = {
			{ szName = "雨集", bOn = true,},
		},
		--冰心
		[10081] = {
			{ szName = "繁音急节",	bOn = true},
			{ szName = "潜渊", bOn = true,},
			{ szName = "冻逝", bOn = true,},
			{ szName = "鹊踏枝", bOn = true,},
			{ szName = "天地低昂", bOn = true,},
		},
		--云裳
		[10080] = {
			{ szName = "斗室", bOn = true,},
			{ szName = "鹊踏枝", bOn = true,},
			{ szName = "天地低昂", bOn = true,},
		},
		--藏剑
		[10144] = {
			{ szName = "剑鸣", bOn = true,},
			{ szName = "灵蕴", bOn = true,},
			{ szName = "暗香", bOn = true,},
		},
		[10145] = {
			{ szName = "剑鸣", bOn = true,},
			{ szName = "灵蕴", bOn = true,},
			{ szName = "暗香", bOn = true,},
		},
		--傲雪
		[10026] = {
			{ szName = "克敌", bOn = true,},
			{ szName = "背水", bOn = true,},
			{ szName = "力拔", bOn = true,},
			{ szName = "啸如虎", bOn = true,},
		},
		--铁牢
		[10062] = {
			{ szName = "啸如虎", bOn = true,},
			{ szName = "天地低昂", bOn = true,},
			{ szName = "御", bOn = true,},
			{ szName = "春泥护花", bOn = true,},
			{ szName = "守如山", bOn = true,},
		},
		--离经
		[10028] = {
			{ szName = "逐流", bOn = true,},
		},
		--花间
		[10021] = {
			{ szName = "春泥护花", bOn = true,},
			{ szName = "毫针", bOn = true,},
		},
		--易筋经
		[10003] = {
			{ szName = "捕风式", bOn = true,},
			{ szName = "折骨", bOn = true,},
		},
		--洗髓
		[10002] = {
			{ szName = "天地低昂", bOn = true,},
			{ szName = "春泥护花", bOn = true,},
			{ szName = "无相诀", bOn = true,},
			{ szName = "不动明王", bOn = true,},
			{ szName = "西宗", bOn = true,},
		},
		--补天诀
		[10176]	= {
			{ szName = "冰蚕诀", bOn = true, },
		},
		
	},
	bOn = true,
}
RegisterCustomData("seEventAlert.bOn")
RegisterCustomData("seEventAlert.tBuffNames")
RegisterCustomData("seEventAlert.tBuffNamesByKongfu")

function seEventAlert.OnBuffUpdate()
	if not seEventAlert.bOn then
		return
	end
	if arg0 == GetClientPlayer().dwID then
		for i, v in pairs(seEventAlert.tBuffNames) do
			if v.bOn and Table_GetBuffName(arg4, arg8) == v.szName then
				if not arg1 then
					seBuffTimer.StartNewBuffTimer(arg4, arg8, arg5, arg6)
				else
					seBuffTimer.RemoveBuffTimer(arg4, arg8, arg5, arg6)
				end
				break
			end
		end
		local dwKungFuID = GetClientPlayer().GetKungfuMount().dwSkillID
		if seEventAlert.tBuffNamesByKongfu[dwKungFuID] then
			for i, v in pairs(seEventAlert.tBuffNamesByKongfu[dwKungFuID]) do
				if v.bOn and Table_GetBuffName(arg4, arg8) == v.szName then
					if not arg1 then
						seBuffTimer.StartNewBuffTimer(arg4, arg8, arg5, arg6)
					else
						seBuffTimer.RemoveBuffTimer(arg4, arg8, arg5, arg6)
					end
					break
				end
			end
		end
	end
end
RegisterEvent("BUFF_UPDATE", seEventAlert.OnBuffUpdate)

function seEventAlert.GetMenu()
	local menu = {
		szOption = "seEventAlert 技能特效警报",
	}
	--开关
	local menu_bOn = {
		szOption = "开启插件",
		bCheck = true,
		bChecked = seEventAlert.bOn,
		fnAction = function()
			seEventAlert.bOn = not seEventAlert.bOn
		end,
	}
	table.insert(menu, menu_bOn)
	--布局设定
	local menu_LayerOut = {
		szOption = "布局设定",
	}
	--位置锁定
	local menu_bDragable = {
		szOption = "位置锁定",
		bCheck = true,
		bChecked = not seBuffTimerAnchor.bDragable,
		fnAction = function()
			seBuffTimerAnchor.bDragable = not seBuffTimerAnchor.bDragable
			seBuffTimerAnchor.UpdateDrag()	
		end,
	}
	table.insert(menu_LayerOut, menu_bDragable)
	--排列
	local menu_direct = {
		szOption = "排列方向",
		{szOption = "从左往右", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_RIGHT, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_RIGHT end, fnAutoClose = function() return true end	},
		{szOption = "从右往左", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_LEFT, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_LEFT end, fnAutoClose = function() return true end	},
		{szOption = "从上往下", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_BOTTOM, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_BOTTOM end, fnAutoClose = function() return true end	},
		{szOption = "从下往上", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_TOP, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_TOP end, fnAutoClose = function() return true end	},
	}
	table.insert(menu_LayerOut, menu_direct)
	table.insert(menu_LayerOut, {
		szOption = "图标间距",
		{ szOption = "Lv 1", bMCheck = true, bChecked = seBuffTimer.nDistance == 10, fnAction = function() seBuffTimer.nDistance = 10 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 2", bMCheck = true, bChecked = seBuffTimer.nDistance == 20, fnAction = function() seBuffTimer.nDistance = 20 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 3", bMCheck = true, bChecked = seBuffTimer.nDistance == 30, fnAction = function() seBuffTimer.nDistance = 30 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 4", bMCheck = true, bChecked = seBuffTimer.nDistance == 40, fnAction = function() seBuffTimer.nDistance = 40 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 5", bMCheck = true, bChecked = seBuffTimer.nDistance == 50, fnAction = function() seBuffTimer.nDistance = 50 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 6", bMCheck = true, bChecked = seBuffTimer.nDistance == 60, fnAction = function() seBuffTimer.nDistance = 60 end, fnAutoClose = function() return true end },
	})
	table.insert(menu_LayerOut, {bDevide = true})
	table.insert(menu_LayerOut, {
		szOption = "测试显示",
		fnAction = function()
			seBuffTimer.StartNewBuffTimer(208, 11, 2, GetLogicFrameCount() + 480)
			seBuffTimer.StartNewBuffTimer(834, 1, 1, GetLogicFrameCount() + 320)
			seBuffTimer.StartNewBuffTimer(409, 34, 1, GetLogicFrameCount() + 160)
		end,
		fnAutoClose = function() return true end,
	})
	table.insert(menu, menu_LayerOut)
	table.insert(menu, {bDevide = true} )
	--经脉技能
	local menu_talent = {
		szOption = "经脉技能警报",
	}
	for i, v in pairs(seEventAlert.tBuffNames) do
		table.insert(menu_talent,{
			szOption = v.szName,
			bCheck = true,
			bChecked = v.bOn,
			fnAction = function()
				seEventAlert.tBuffNames[i].bOn = not v.bOn	
			end,
		})
	end
	table.insert(menu, menu_talent)
	--门派技能
	local menu_kungfu = {
		szOption = "门派技能警报",
	}
	for dwKungfuID, kungfus in pairs(seEventAlert.tBuffNamesByKongfu) do
		if dwKungfuID == GetClientPlayer().GetKungfuMount().dwSkillID then
			table.insert(menu_kungfu, {
				szOption = "【"..Table_GetSkillName(dwKungfuID, 1).."】"
			})
			table.insert(menu_kungfu, {bDevide = true} )
			for i, v in pairs(kungfus) do
				table.insert(menu_kungfu, {
					szOption = v.szName,
					bCheck = true,
					bChecked = v.bOn,
					fnAction = function()
						seEventAlert.tBuffNamesByKongfu[dwKungfuID][i].bOn = not v.bOn
					end,
					{
						szOption = "删除",
						fnAction = function()
							table.remove(seEventAlert.tBuffNamesByKongfu[dwKungfuID], i)
						end,
					}
				})
			end
			table.insert(menu_kungfu, {bDevide = true} )
			table.insert(menu_kungfu, {
				szOption = "自定义Buff",
				fnAction = function()
					GetUserInput(
					"输入需要监视的Buff名称：", 
					function(szText) 
						table.insert(seEventAlert.tBuffNamesByKongfu[dwKungfuID], {szName = szText, bOn = true,}) 
					end, nil, nil, nil, nil, 20)
				end,
			})
		end
	end
	table.insert(menu, menu_kungfu)
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by 叶芷青、翼宿怜", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seEventAlert.GetMenu) end end)
