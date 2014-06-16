--[[
y	arg0,  playerID
y	arg1,  false = ���  true = ��ʧ
	arg2,  index
	arg3,  true = buff false = debuff
y	arg4,  buffID
y	arg5,  ����
y	arg6,  Endframe
	arg7,  ����
y	arg8,  buffLV
	arg9
]]

seEventAlert = {
	tBuffNames = {
		{ szName = "����",	bOn = true,},
		{ szName = "����",	bOn = true,},
		{ szName = "��Ѩ",	bOn = true,},
		{ szName = "�縮",	bOn = true,},
		{ szName = "����",	bOn = true,},
		{ szName = "����",	bOn = true,},
		{ szName = "�ٺ�",	bOn = true,},
	},
	tBuffNamesByKongfu = {
		--����
		[10015] = {
			{ szName = "תǬ��", bOn = true,},
			{ szName = "躹�����", bOn = true,},
		},
		--����
		[10014] = {
			{ szName = "�꼯", bOn = true,},
		},
		--����
		[10081] = {
			{ szName = "��������",	bOn = true},
			{ szName = "ǱԨ", bOn = true,},
			{ szName = "����", bOn = true,},
			{ szName = "ȵ̤֦", bOn = true,},
			{ szName = "��صͰ�", bOn = true,},
		},
		--����
		[10080] = {
			{ szName = "����", bOn = true,},
			{ szName = "ȵ̤֦", bOn = true,},
			{ szName = "��صͰ�", bOn = true,},
		},
		--�ؽ�
		[10144] = {
			{ szName = "����", bOn = true,},
			{ szName = "����", bOn = true,},
			{ szName = "����", bOn = true,},
		},
		[10145] = {
			{ szName = "����", bOn = true,},
			{ szName = "����", bOn = true,},
			{ szName = "����", bOn = true,},
		},
		--��ѩ
		[10026] = {
			{ szName = "�˵�", bOn = true,},
			{ szName = "��ˮ", bOn = true,},
			{ szName = "����", bOn = true,},
			{ szName = "Х�绢", bOn = true,},
		},
		--����
		[10062] = {
			{ szName = "Х�绢", bOn = true,},
			{ szName = "��صͰ�", bOn = true,},
			{ szName = "��", bOn = true,},
			{ szName = "���໤��", bOn = true,},
			{ szName = "����ɽ", bOn = true,},
		},
		--�뾭
		[10028] = {
			{ szName = "����", bOn = true,},
		},
		--����
		[10021] = {
			{ szName = "���໤��", bOn = true,},
			{ szName = "����", bOn = true,},
		},
		--�׽
		[10003] = {
			{ szName = "����ʽ", bOn = true,},
			{ szName = "�۹�", bOn = true,},
		},
		--ϴ��
		[10002] = {
			{ szName = "��صͰ�", bOn = true,},
			{ szName = "���໤��", bOn = true,},
			{ szName = "�����", bOn = true,},
			{ szName = "��������", bOn = true,},
			{ szName = "����", bOn = true,},
		},
		--�����
		[10176]	= {
			{ szName = "���Ͼ�", bOn = true, },
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
		szOption = "seEventAlert ������Ч����",
	}
	--����
	local menu_bOn = {
		szOption = "�������",
		bCheck = true,
		bChecked = seEventAlert.bOn,
		fnAction = function()
			seEventAlert.bOn = not seEventAlert.bOn
		end,
	}
	table.insert(menu, menu_bOn)
	--�����趨
	local menu_LayerOut = {
		szOption = "�����趨",
	}
	--λ������
	local menu_bDragable = {
		szOption = "λ������",
		bCheck = true,
		bChecked = not seBuffTimerAnchor.bDragable,
		fnAction = function()
			seBuffTimerAnchor.bDragable = not seBuffTimerAnchor.bDragable
			seBuffTimerAnchor.UpdateDrag()	
		end,
	}
	table.insert(menu_LayerOut, menu_bDragable)
	--����
	local menu_direct = {
		szOption = "���з���",
		{szOption = "��������", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_RIGHT, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_RIGHT end, fnAutoClose = function() return true end	},
		{szOption = "��������", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_LEFT, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_LEFT end, fnAutoClose = function() return true end	},
		{szOption = "��������", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_BOTTOM, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_BOTTOM end, fnAutoClose = function() return true end	},
		{szOption = "��������", bMCheck = true, bChecked = seBuffTimer.nDirection == seBuffTimer.DIRECTION_TOP, fnAction = function() seBuffTimer.nDirection = seBuffTimer.DIRECTION_TOP end, fnAutoClose = function() return true end	},
	}
	table.insert(menu_LayerOut, menu_direct)
	table.insert(menu_LayerOut, {
		szOption = "ͼ����",
		{ szOption = "Lv 1", bMCheck = true, bChecked = seBuffTimer.nDistance == 10, fnAction = function() seBuffTimer.nDistance = 10 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 2", bMCheck = true, bChecked = seBuffTimer.nDistance == 20, fnAction = function() seBuffTimer.nDistance = 20 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 3", bMCheck = true, bChecked = seBuffTimer.nDistance == 30, fnAction = function() seBuffTimer.nDistance = 30 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 4", bMCheck = true, bChecked = seBuffTimer.nDistance == 40, fnAction = function() seBuffTimer.nDistance = 40 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 5", bMCheck = true, bChecked = seBuffTimer.nDistance == 50, fnAction = function() seBuffTimer.nDistance = 50 end, fnAutoClose = function() return true end },
		{ szOption = "Lv 6", bMCheck = true, bChecked = seBuffTimer.nDistance == 60, fnAction = function() seBuffTimer.nDistance = 60 end, fnAutoClose = function() return true end },
	})
	table.insert(menu_LayerOut, {bDevide = true})
	table.insert(menu_LayerOut, {
		szOption = "������ʾ",
		fnAction = function()
			seBuffTimer.StartNewBuffTimer(208, 11, 2, GetLogicFrameCount() + 480)
			seBuffTimer.StartNewBuffTimer(834, 1, 1, GetLogicFrameCount() + 320)
			seBuffTimer.StartNewBuffTimer(409, 34, 1, GetLogicFrameCount() + 160)
		end,
		fnAutoClose = function() return true end,
	})
	table.insert(menu, menu_LayerOut)
	table.insert(menu, {bDevide = true} )
	--��������
	local menu_talent = {
		szOption = "�������ܾ���",
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
	--���ɼ���
	local menu_kungfu = {
		szOption = "���ɼ��ܾ���",
	}
	for dwKungfuID, kungfus in pairs(seEventAlert.tBuffNamesByKongfu) do
		if dwKungfuID == GetClientPlayer().GetKungfuMount().dwSkillID then
			table.insert(menu_kungfu, {
				szOption = "��"..Table_GetSkillName(dwKungfuID, 1).."��"
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
						szOption = "ɾ��",
						fnAction = function()
							table.remove(seEventAlert.tBuffNamesByKongfu[dwKungfuID], i)
						end,
					}
				})
			end
			table.insert(menu_kungfu, {bDevide = true} )
			table.insert(menu_kungfu, {
				szOption = "�Զ���Buff",
				fnAction = function()
					GetUserInput(
					"������Ҫ���ӵ�Buff���ƣ�", 
					function(szText) 
						table.insert(seEventAlert.tBuffNamesByKongfu[dwKungfuID], {szName = szText, bOn = true,}) 
					end, nil, nil, nil, nil, 20)
				end,
			})
		end
	end
	table.insert(menu, menu_kungfu)
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by Ҷ���ࡢ������", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seEventAlert.GetMenu) end end)
