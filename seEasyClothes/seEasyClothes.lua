local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seEasyClothes] " .. table.concat(a, "\t").. "\n" )
end

--使用事件机制。。。第一次试着写事件。。。本来可以不用事件的。。。
se_arg0 = nil
se_arg1 = nil
se_arg2 = nil
se_arg3 = nil
se_arg4 = nil
se_arg5 = nil

ENTER_EASY_CLOTHES_MODE = "ENTER_EASY_CLOTHES_MODE"
EXIT_EASY_CLOTHES_MODE = "EXIT_EASY_CLOTHES_MODE"

seEasyClothes = {
	CurrentBox = CharacterPanel.GetEquipBox(CharacterPanel.GetPageBattle(), EQUIPMENT_INVENTORY.MELEE_WEAPON),
	bShow = false,
	Anchor = {s = "TOPLEFT", r = "TOPLEFT",  x = 500, y = 100},
	bOn = true,
}

RegisterCustomData("seEasyClothes.bOn")

function seEasyClothes.OnFrameCreate()
	this:RegisterEvent(ENTER_EASY_CLOTHES_MODE)
	this:RegisterEvent(EXIT_EASY_CLOTHES_MODE)
	this:RegisterEvent("EQUIP_ITEM_UPDATE")
	
	local frame = Station.Lookup("Topmost/seEasyClothes")
--	frame:SetPoint(seEasyClothes.Anchor.s, 0, 0, seEasyClothes.Anchor.r, seEasyClothes.Anchor.x, seEasyClothes.Anchor.y)
--	frame:CorrectPos()
	print("简单换装 Loaded by 叶芷青、翼宿怜")
end

--如果松开alt，则关闭换装box条
function seEasyClothes.OnFrameBreathe()
	if seEasyClothes.bShow and not IsAltKeyDown() then
		FireEvent(EXIT_EASY_CLOTHES_MODE)
	end
end

--开启换装条，和关闭换装条事件
function seEasyClothes.OnEvent(event)
	if event == ENTER_EASY_CLOTHES_MODE then
		if seEasyClothes.CurrentBox then
			seEasyClothes.CurrentBox:SetObjectPressed(0)
		end
		seEasyClothes.ShowBarOnBox(se_arg0)
		seEasyClothes.CurrentBox:SetObjectPressed(1)
	elseif event == EXIT_EASY_CLOTHES_MODE then
		seEasyClothes.HideBar()
		seEasyClothes.CurrentBox:SetObjectPressed(0)
	elseif event == "EQUIP_ITEM_UPDATE" and seEasyClothes.bShow then	--点击更换装备后，需要刷新装备条
		seEasyClothes.UpdateBar()
	end
end

--给出适合当前鼠标位置的“装备s”。
function seEasyClothes.SetSuitableItems(BoxList, XList)
	local player = GetClientPlayer()
	local EquipPos = seEasyClothes.GetCurrentEquipPos()
	for i = 1, BigBagPanel.nCount, 1 do
		local dwBox = BigBagPanel.BagIndexToInventoryIndex(i)
		local dwSize = player.GetBoxSize(dwBox)

		for dwX = 0, dwSize - 1, 1 do
			local eRetCode, nEquipPos = player.GetEquipPos(dwBox, dwX)
			if eRetCode == ITEM_RESULT_CODE.SUCCESS then
				if EquipPos == EQUIPMENT_INVENTORY.LEFT_RING or EquipPos == EQUIPMENT_INVENTORY.RIGHT_RING then
					if nEquipPos == EQUIPMENT_INVENTORY.LEFT_RING or nEquipPos == EQUIPMENT_INVENTORY.RIGHT_RING then
						BoxList[#BoxList + 1] = dwBox
						XList[#XList + 1] = dwX
					end
				elseif EquipPos == nEquipPos then
					BoxList[#BoxList + 1] = dwBox
					XList[#XList + 1] = dwX
				end
			end
		end
	end
	if not seEasyClothes.CurrentBox:IsEmpty() then
		local em_dwBox, em_dwX = seEasyClothes.FindEmptyBagBox()
		if em_dwBox then
			BoxList[#BoxList + 1] = em_dwBox
			XList[#XList + 1] = em_dwX
		end
	end
	--print("boxlist:"..#BoxList)
	--print("xlist:"..#XList)

end

--从box返回装备类型
function seEasyClothes.GetCurrentEquipPos()
	local szName = seEasyClothes.CurrentBox:GetName()
	if szName == "Box_Helm" then
		return EQUIPMENT_INVENTORY.HELM
	elseif szName == "Box_Chest" then
		return EQUIPMENT_INVENTORY.CHEST
	elseif szName == "Box_Bangle" then
		return EQUIPMENT_INVENTORY.BANGLE
	elseif szName == "Box_Waist" then
		return EQUIPMENT_INVENTORY.WAIST
	elseif szName == "Box_Pants" then
		return EQUIPMENT_INVENTORY.PANTS
	elseif szName == "Box_Boots" then
		return EQUIPMENT_INVENTORY.BOOTS
	elseif szName == "Box_Extend" then
		return EQUIPMENT_INVENTORY.WAIST_EXTEND
	elseif szName == "Box_Amulet" then
		return EQUIPMENT_INVENTORY.AMULET
	elseif szName == "Box_Pendant" then
		return EQUIPMENT_INVENTORY.PENDANT
	elseif szName == "Box_LeftRing" then
		return EQUIPMENT_INVENTORY.LEFT_RING
	elseif szName == "Box_RightRing"then
		return EQUIPMENT_INVENTORY.RIGHT_RING
	elseif szName == "Box_MeleeWeapon" then
		return EQUIPMENT_INVENTORY.MELEE_WEAPON
	elseif szName == "Box_RangeWeapon" then
		return EQUIPMENT_INVENTORY.RANGE_WEAPON
	elseif szName == "Box_AmmoPouch" then
		return EQUIPMENT_INVENTORY.ARROW
	elseif szName == "Box_Amice" then
		return EQUIPMENT_INVENTORY.BACK_EXTEND
	elseif szName == "Box_HeavySword" then
		return EQUIPMENT_INVENTORY.BIG_SWORD
	elseif szName == "Box_LightSword" then
		return EQUIPMENT_INVENTORY.MELEE_WEAPON
	elseif szName == "Box_RangeWeaponCJ" then
		return EQUIPMENT_INVENTORY.RANGE_WEAPON
	elseif szName == "Box_AmmoPouchCJ" then
		return EQUIPMENT_INVENTORY.ARROW
	else
		return nil
	end
end

--不解释
function seEasyClothes.OnItemLButtonDown()
	this:SetObjectStaring(false)
	this:SetObjectPressed(1)
end

--不解释
function seEasyClothes.OnItemLButtonUp()
	this:SetObjectPressed(0)
end

--针对“脱下”寻找背包内空栏
function seEasyClothes.FindEmptyBagBox()
	local player = GetClientPlayer()
	for i = 1, BigBagPanel.nCount, 1 do
		local dwBox = BigBagPanel.BagIndexToInventoryIndex(i)
		local dwSize = player.GetBoxSize(dwBox)
		for dwX = 0, dwSize - 1, 1 do
			local item = player.GetItem(dwBox, dwX)
			if not item then
				return dwBox, dwX
			end
		end
	end
	return nil, nil
end

--点击换装。
function seEasyClothes.OnItemLButtonClick()
	local player = GetClientPlayer()
	if this:IsEmpty() then	--脱下
		local dwBox, dwX = this.dwBox, this.dwX
		OnExchangeItem(INVENTORY_INDEX.EQUIP, seEasyClothes.GetCurrentEquipPos(), dwBox, dwX)
		PlayItemSound(nUiId)
	else	--换装。
		local nUiId, dwBox, dwX = this:GetObjectData()
		local eRetCode, nEquipPos = player.GetEquipPos(dwBox, dwX)
		if eRetCode == ITEM_RESULT_CODE.SUCCESS then
			OnExchangeItem(dwBox, dwX, INVENTORY_INDEX.EQUIP, seEasyClothes.GetCurrentEquipPos())
			PlayItemSound(nUiId)
		else
			OutputMessage("MSG_ANNOUNCE_RED", g_tStrings.tItem_Msg[eRetCode]);
		end
	end
end

--给出box内的装备tip
function seEasyClothes.OnItemMouseEnter()
	if this:GetType() == "Box" then
		this:SetObjectMouseOver(1)
		if not this:IsEmpty() then
			local _, dwBox, dwX = this:GetObjectData()
			local x, y = this:GetAbsPos()
			local w, h = this:GetSize()
			OutputItemTip(UI_OBJECT_ITEM, dwBox, dwX, nil, {x, y, w, h})
		else
			local x, y = this:GetAbsPos()
			local w, h = this:GetSize()
			OutputTip(GetFormatText("脱下", 162), 200, {x, y, w, h})
		end
		--print(this:GetBoxIndex())
	end
	
end

--不解释
function seEasyClothes.OnItemMouseLeave()
	if this:GetType() == "Box" then
		this:SetObjectMouseOver(0)	
		HideTip()
	end
end

--设置box。
function seEasyClothes.UpdateItem(box)
	local player = GetClientPlayer()
	local item = player.GetItem(box.dwBox, box.dwX)
	if item then
		UpdataItemBoxObject(box, box.dwBox, box.dwX, item)
	end
	if box:IsObjectMouseOver() then
		local thisSave = this
		this = box
		thisSave:GetSelf().OnItemMouseEnter()
		this = thisSave
	end
end

--画boxes的条。
function seEasyClothes.UpdateBar()
	local itemBoxList = {}
	local itemXList = {}
	seEasyClothes.SetSuitableItems(itemBoxList, itemXList)	--获得所有适合的装备。
	local nW = 3
	local frame = Station.Lookup("Topmost/seEasyClothes")
	local handle = frame:Lookup("", "")
	local hBg = handle:Lookup("Handle_BG")
	local hBox = handle:Lookup("Handle_Box")
	hBg:Clear()
	hBox:Clear()

	local x, y, n = 0, 0, 1
	--左括号
	hBg:AppendItemFromString("<image>path=\"ui/Image/Minimap/Minimap.UITex\" frame=145 </image>")
	local img = hBg:Lookup(hBg:GetItemCount() - 1)
	img:SetRelPos(x, y)
	x = x + 2
	for j = 1, #itemBoxList, 1 do
		--可选装备
		hBg:AppendItemFromString("<image>path=\"ui/Image/Minimap/Minimap.UITex\" frame=135 </image>")
		hBox:AppendItemFromString("<box>w=48 h=48 eventid=525311 lockshowhide=1 </box>")
		
		local img = hBg:Lookup(hBg:GetItemCount() - 1)
		local box = hBox:Lookup(hBox:GetItemCount() - 1)
		
		img:SetName("BG_"..n)
		box:SetName("Box_"..n)
		
		img:Show()
		box:Show()
		box.dwBox = itemBoxList[j]
		box.dwX = itemXList[j]
		--box:SetObject(UI_OBJECT_SKILL, 537, 5)
		--box:SetObjectIcon(Table_GetSkillIconID(537, 5))
		
		img:SetRelPos(x, y)
		box:SetRelPos(x + 1, y + 2)
		
		seEasyClothes.UpdateItem(box)
		
		x = x + 50
		n = n + 1
	end
	
	--[[
	--脱下
	hBg:AppendItemFromString("<image>path=\"ui/Image/Minimap/Minimap.UITex\" frame=135 </image>")
	hBox:AppendItemFromString("<box>w=48 h=48 eventid=525311 lockshowhide=1 </box>")
		
	local img = hBg:Lookup(hBg:GetItemCount() - 1)
	local box = hBox:Lookup(hBox:GetItemCount() - 1)
	
	img:SetName("BG_"..n)
	box:SetName("Box_"..n)
	img:Show()
	box:Show()
	img:SetRelPos(x, y)
	box:SetRelPos(x + 1, y + 2)
	x = x + 50
	n = n + 1
	]]
	
	--右括号
	hBg:AppendItemFromString("<image>path=\"ui/Image/Minimap/Minimap.UITex\" frame=143 </image>")
	local img = hBg:Lookup(hBg:GetItemCount() - 1)
	img:SetRelPos(x, y)
	
	hBg:FormatAllItemPos()
	hBox:FormatAllItemPos()
	hBg:SetSizeByAllItemSize()
	hBox:SetSizeByAllItemSize()
	handle:SetSizeByAllItemSize()
	local w, h = handle:GetAllItemSize()
	frame:SetSize(w, h)
	
	--CorrectPos
	local xPos, yPos = seEasyClothes.CurrentBox:GetAbsPos()
	if seEasyClothes.CurrentBox:GetName() == "Box_MeleeWeapon" or seEasyClothes.CurrentBox:GetName() == "Box_RangeWeapon" or seEasyClothes.CurrentBox:GetName() == "Box_AmmoPouch" or seEasyClothes.CurrentBox:GetName() == "Box_LightSword" or seEasyClothes.CurrentBox:GetName() == "Box_HeavySword" or seEasyClothes.CurrentBox:GetName() == "Box_RangeWeaponCJ" or seEasyClothes.CurrentBox:GetName() == "Box_AmmoPouchCJ" then
		frame:SetPoint(seEasyClothes.Anchor.s, 0, 0, seEasyClothes.Anchor.r, xPos - 2, yPos + 50)
	else
		frame:SetPoint(seEasyClothes.Anchor.s, 0, 0, seEasyClothes.Anchor.r, xPos + 50, yPos - 2)
	end
	frame:CorrectPos()

	--box.dwBox = dwBox
	--box.dwX = dwX
end

--显示
function seEasyClothes.ShowBarOnBox(box)
	seEasyClothes.bShow = true
	seEasyClothes.CurrentBox = box
	seEasyClothes.UpdateBar()
	local frame = Station.Lookup("Topmost/seEasyClothes")
	frame:Show()
end

--隐藏
function seEasyClothes.HideBar()
	seEasyClothes.bShow = false
	local frame = Station.Lookup("Topmost/seEasyClothes")
	frame:Hide()
	--print("Frame Hide")
end

--激发开启事件。
function PressAltOnBox(box)
	if box ~= seEasyClothes.CurrentBox or not seEasyClothes.bShow then
		se_arg0 = box
		FireEvent(ENTER_EASY_CLOTHES_MODE)
		--print(box:GetName())
	end
end

Wnd.OpenWindow("interface\\seEasyClothes\\seEasyClothes.ini", "seEasyClothes")

function StartEasyClothes(bOn)
	if bOn then
		CharacterPanel.OnItemMouseEnter = _CharacterPanel_OnItemMouseEnter
	else
		CharacterPanel.OnItemMouseEnter = _CharacterPanel_OnItemMouseEnter_Org
	end
end

function seEasyClothes.GetMenu()
	local menu = {
		szOption = "seEasyClothes 简单换装",
		{
			szOption = "开启alt换装支持",
			bCheck = true,
			bChecked = seEasyClothes.bOn,
			fnAction = function()
				seEasyClothes.bOn = not seEasyClothes.bOn
				StartEasyClothes(seEasyClothes.bOn)
			end,
		}
	}
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by 叶芷青、翼宿怜", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then StartEasyClothes(seEasyClothes.bOn) seOption.RegMenu(seEasyClothes.GetMenu) end end)
