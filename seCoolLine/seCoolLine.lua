local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seCoolLine] " .. table.concat(a, "\t").. "\n" )
end


seCoolLine = {
	bOn = true,
	bDragable = true,
	nRemainTime = 700,
	n_BoxSize = 30,
	time_compression = 0.4,
	nTimeMax = 2 * 60 * 1000,
	nLastScale = 2.8,
	nLastTime = 10,
	
	bBoxTimer = true,
	
	Width = 800,
	Marks = {
		[1] = {
			nTime = 1 * 1000,
			sText = "1",
			szOption = "1 s",
		},
		[2] = {
			nTime = 10 * 1000,
			sText = "10",
			szOption = "10 s",
		},
		[3] = {
			nTime = 30 * 1000,
			sText = "30",
			szOption = "30 s",
		},
		[4] = {
			nTime = 60 * 1000,
			sText = "60",
			szOption = "60 s",
		},
		[5] = {
			nTime = 2 * 60 * 1000,
			sText = "2m",
			szOption = "2 m",
		},
		[6] = {
			nTime = 5 * 60 * 1000,
			sText = "5m",
			szOption = "5 m",
		},
		[7] = {
			nTime = 10 * 60 * 1000,
			sText = "10m",
			szOption = "10 m",
		},
		[8] = {
			nTime = 30 * 60 * 1000,
			sText = "30m",
			szOption = "30 m",
		},
	},
	Anchor = {
		s = "BOTTOMCENTER", 
		r = "BOTTOMCENTER", 
		x = 21, 
		y = -250,
	},
	IgnoreSkills = {
	},
}

RegisterCustomData("seCoolLine.bOn")
RegisterCustomData("seCoolLine.bDragable")
RegisterCustomData("seCoolLine.nRemainTime")
RegisterCustomData("seCoolLine.time_compression")
RegisterCustomData("seCoolLine.nTimeMax")
RegisterCustomData("seCoolLine.nLastTime")
RegisterCustomData("seCoolLine.bBoxTimer")
RegisterCustomData("seCoolLine.IgnoreSkills")
RegisterCustomData("seCoolLine.Anchor")
RegisterCustomData("seCoolLine.n_BoxSize")

function seCoolLine.OnFrameCreate()

	this:RegisterEvent("UI_SCALED")
	seCoolLine.UpdateMarkText(this)
end
function seCoolLine.OnFrameDrag()
end

function seCoolLine.OnFrameDragSetPosEnd()
end

function seCoolLine.OnFrameDragEnd()
	this:CorrectPos()
	seCoolLine.Anchor = GetFrameAnchor(this)
end

function seCoolLine.UpdateAnchor(frame)
	local anchor = seCoolLine.Anchor
	frame:SetPoint(anchor.s, 0, 0, anchor.r, anchor.x, anchor.y)
	frame:CorrectPos()
end

function seCoolLine.SetTimeMaxAndCompression(nTimeMax, time_compression)
	seCoolLine.nTimeMax = nTimeMax
	seCoolLine.time_compression = time_compression
	
	seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
end

function seCoolLine.OnEvent(event)
	if event == "UI_SCALED" then
		seCoolLine.UpdateAnchor(this)
		seCoolLine.UpdateMarkText(this)
		if seCoolLine.bOn then
			this:Show()
		else
			this:Hide()
		end
		if seCoolLine.bDragable then
			this:EnableDrag(true)
		else
			this:EnableDrag(false)
		end
	elseif event == "CUSTOM_DATA_LOADED" and arg0 == "Role" then
		if seCoolLine.bOn then
			this:Show()
		else
			this:Hide()
		end
		seCoolLine.UpdateMarkText(this)
	end
end

function seCoolLine.OnFrameBreathe()
	local player = GetClientPlayer()
	if not player then
		return
	end
	local aSchool = player.GetSchoolList()
	for _, dwSchoolID in pairs(aSchool) do
		local aKungfu = player.GetKungfuList(dwSchoolID)
		for dwKungfuID, dwKungfulevel in pairs(aKungfu) do
			if Table_IsSkillShow(dwKungfuID, dwKungfulevel) then
				local aSkill = player.GetSkillList(dwKungfuID)
				for dwSkillID, dwSkillLevel in pairs(aSkill) do
					if Table_IsSkillShow(dwSkillID, dwSkillLevel) then
						local bCool, nLeft, nTotal = player.GetSkillCDProgress(dwSkillID, dwSkillLevel)
						if nLeft > 24 and nTotal ~= 40 and nLeft < seCoolLine.nTimeMax * 16 / 1000 and seCoolLine.CheckSkill(dwSkillID) then
							seCoolLine.UpdataSkillCDProgress(dwSkillID, dwSkillLevel, nLeft)
						end
					end
				end
			end
		end
	end	
	local icons = this:Lookup("",""):Lookup("Handle_SkillIcons")
	local index = 0
	while index < icons:GetItemCount() do
		box_handle = icons:Lookup(index)
		local bCool, nLeft, nTotal = GetClientPlayer().GetSkillCDProgress(box_handle.dwSkillID, box_handle.dwSkillLevel)
		g_nEndTime = GetTime() + nLeft * 1000 / GLOBAL.GAME_FPS
		if g_nEndTime < box_handle.g_nEndTime then
			box_handle.g_nEndTime = g_nEndTime
		end
		index = index + 1
	end
end


function seCoolLine.UpdataSkillCDProgress(dwSkillID, dwSkillLevel, nLeft)
	g_nNowTime = GetTime()
	local icons = this:Lookup("",""):Lookup("Handle_SkillIcons")
	local index = 0
	while index < icons:GetItemCount() do
		if dwSkillID == icons:Lookup(index).dwSkillID then
			return
		end
		index = index + 1
	end

	seCoolLine.AppendNewSkill(dwSkillID, dwSkillLevel, g_nNowTime, g_nNowTime + nLeft * 1000 / GLOBAL.GAME_FPS )
	icons:FormatAllItemPos()
end

function seCoolLine.OnItemMouseEnter()
	if this:GetName() == "SkillBox" then
		this:SetObjectMouseOver(1)
		local x, y = this:GetAbsPos()
		local w, h = this:GetSize()
		local nType = this:GetObjectType()
		if nType == UI_OBJECT_SKILL then		
			local dwSkillID, dwSkillLevel = this:GetObjectData()
			OutputSkillTip(dwSkillID, dwSkillLevel, {x, y, w, h}, false)
		end
	end
end
function seCoolLine.OnItemMouseLeave()
	if this:GetName() == "SkillBox" then
		this:SetObjectMouseOver(0)	
	end
end

function seCoolLine.CheckSkill(dwSkillID)
	for i=1, #seCoolLine.IgnoreSkills, 1 do
		if seCoolLine.IgnoreSkills[i] == dwSkillID then
			return false
		end
	end
	return true
end

function seCoolLine.OnItemRButtonClick()
	--print(this:GetName().." clicked")
	if this:GetName() == "SkillBox" then
		local dwSkillID, dwSkillLevel = this:GetObjectData()
		table.insert(seCoolLine.IgnoreSkills, dwSkillID)
		this:GetParent():GetParent():RemoveItem(this:GetParent())
	end
end

function seCoolLine.AppendNewSkill(dwSkillID, dwSkillLevel, g_nStartTime, g_nEndTime )

	local icons = this:Lookup("",""):Lookup("Handle_SkillIcons")
	icons:AppendItemFromString("<handle>firstpostype=0 handletype=0 w="..seCoolLine.n_BoxSize.." h="..seCoolLine.n_BoxSize.." </handle>")
	
	local index = icons:GetItemCount() - 1
	
	local icon_handle = icons:Lookup(index)
	
	icon_handle:AppendItemFromString("<box>w="..seCoolLine.n_BoxSize.." h="..seCoolLine.n_BoxSize.." eventid=525311 lockshowhide=1</box>")
	icon_handle:AppendItemFromString("<text>w="..seCoolLine.n_BoxSize.." h="..seCoolLine.n_BoxSize.." halign=2 valign=2  lockshowhide=1</text>")
	

	local cd_box = icon_handle:Lookup(0)
	cd_box:SetName("SkillBox")
	cd_box:Show()
	local text = icon_handle:Lookup(1)
	text:Show()
	text:SetName("Text")
	text:SetFontScheme(15)
	
	icon_handle.dwSkillID = dwSkillID
	icon_handle.dwSkillLevel = dwSkillLevel
	icon_handle.g_nStartTime = g_nStartTime
	icon_handle.g_nEndTime = g_nEndTime
	
	while index > 0 do
		local pre_handle = icons:Lookup(index - 1)
		local post_handle = icons:Lookup(index)
		if pre_handle.g_nEndTime > post_handle.g_nEndTime then
			break
		end
		
		local g_nEndTime_t = pre_handle.g_nEndTime
		local g_nStartTime_t = pre_handle.g_nStartTime
		local dwSkillID_t = pre_handle.dwSkillID
		local dwSkillLevel_t = pre_handle.dwSkillLevel

		pre_handle.g_nEndTime = post_handle.g_nEndTime
		pre_handle.g_nStartTime = post_handle.g_nStartTime
		pre_handle.dwSkillID = post_handle.dwSkillID
		pre_handle.dwSkillLevel = post_handle.dwSkillLevel

		post_handle.g_nEndTime = g_nEndTime_t
		post_handle.g_nStartTime = g_nStartTime_t
		post_handle.dwSkillID = dwSkillID_t
		post_handle.dwSkillLevel = dwSkillLevel_t

		index = index - 1
	end
	index = icons:GetItemCount() - 1
	while index > -1 do
		icon_handle = icons:Lookup(index)
		cd_box = icon_handle:Lookup(0)
		cd_box:SetObject(UI_OBJECT_SKILL, icon_handle.dwSkillID, icon_handle.dwSkillLevel)
		cd_box:SetObjectIcon(Table_GetSkillIconID(icon_handle.dwSkillID, icon_handle.dwSkillLevel))
		--cd_box:SetObjectStaring(false)
		--cd_box:SetObjectPressed(1)
		index = index - 1
	end
end

function seCoolLine.UpdateMarkText(frame)
	local handle_text = frame:Lookup("",""):Lookup("Handle_BGText")
	while handle_text:GetItemCount() ~= 0 do
		handle_text:RemoveItem(0)
	end
	for i=1, #seCoolLine.Marks, 1 do
		if seCoolLine.Marks[i].nTime > seCoolLine.nTimeMax then
			break
		end
		--print("append")
		handle_text:AppendItemFromString("<text>w="..seCoolLine.n_BoxSize.." h="..seCoolLine.n_BoxSize.." halign=0 valign=1 lockshowhide=1</text>")
		local text = handle_text:Lookup(i-1)
		text:Show()
		text:SetName("Text_"..(i-1))
		text:SetText(seCoolLine.Marks[i].sText)
		text:SetRelPos(seCoolLine.GetPos(seCoolLine.Marks[i].nTime), 1)
		text:SetFontScheme(19)
		--text:SetFontScheme(15)
		--text:SetFontColor(0,128,0)
		--text:SetAlpha(128)
	end
	handle_text:FormatAllItemPos()
end

function seCoolLine.OnUpdateHeight(nHeight)
	seCoolLine.n_BoxSize = nHeight
	local frame = Station.Lookup("Normal/seCoolLine")
	local handle = frame:Lookup("","")
	local w, h = 0, 0
	w, h = handle:Lookup("Image_BG_L"):GetSize()
	handle:Lookup("Image_BG_L"):SetSize(w, nHeight+2)
	w, h = handle:Lookup("Image_BG_C"):GetSize()
	handle:Lookup("Image_BG_C"):SetSize(w, nHeight+2)
	w, h = handle:Lookup("Image_BG_R"):GetSize()
	handle:Lookup("Image_BG_R"):SetSize(w, nHeight+2)
	seCoolLine.UpdateMarkText(frame)
end

function seCoolLine.GetPos(rest_time)
	if rest_time < 0 then
		return 0
	end
	return (rest_time / seCoolLine.nTimeMax) ^ seCoolLine.time_compression * (seCoolLine.Width - 40)
end

function seCoolLine.GetAlpha(rest_time)
	if rest_time > 0 then
		return 255
	else
		return 255 * (seCoolLine.nRemainTime + rest_time) / seCoolLine.nRemainTime
	end
end

function seCoolLine.GetRelSize(rest_time)
	if rest_time > seCoolLine.nLastTime then
		return 1
	elseif rest_time > 0 then
		return seCoolLine.nLastScale - (seCoolLine.nLastScale - 1) * seCoolLine.GetPos(rest_time) / seCoolLine.GetPos(seCoolLine.nLastTime)
		--return 1
	else 
		return seCoolLine.nLastScale
	end
end

function seCoolLine.UpdateBoxInfo(box_handle, g_nNowTime, g_nEndTime)
	local rest_time = g_nEndTime - g_nNowTime
	local x, y, rel_size = 0, 0, 1
	x = seCoolLine.GetPos(rest_time)
	rel_size = seCoolLine.GetRelSize(rest_time)
	x = x - (rel_size - 1) * seCoolLine.n_BoxSize / 2
	y = y - (rel_size - 1) * seCoolLine.n_BoxSize / 2
	box_handle:Lookup(0):SetSize(seCoolLine.n_BoxSize * rel_size, seCoolLine.n_BoxSize * rel_size)
	box_handle:Lookup(1):SetSize(seCoolLine.n_BoxSize * rel_size, seCoolLine.n_BoxSize * rel_size)
	box_handle:SetAlpha(seCoolLine.GetAlpha(rest_time))
	box_handle:SetRelPos(x, y)
	local text = box_handle:Lookup(1)
	if seCoolLine.bBoxTimer then
		if rest_time > 10000 then
			text:SetText( string.format("%0.0f", rest_time / 1000) )
			--text:SetFontColor(255, 255, 255)
		elseif rest_time > 0 then
			text:SetText( string.format("%0.1f", rest_time/1000) )
			--text:SetFontColor(255, 0, 0)
		else
			text:SetText( "" )
		end
	else
		text:SetText( "" )
	end
end

function seCoolLine.RemoveIconAndBar(index)
	local icons = this:Lookup("",""):Lookup("Handle_SkillIcons")
	icons:RemoveItem(index)
end

function seCoolLine.OnFrameRender()
	local g_nNowTime = GetTime()
	local icons = this:Lookup("",""):Lookup("Handle_SkillIcons")
	local index = icons:GetItemCount() - 1
	while index > -1 do
		box_handle = icons:Lookup(index)
		if g_nNowTime > box_handle.g_nEndTime + seCoolLine.nRemainTime then
			seCoolLine.RemoveIconAndBar(index)
		else
			seCoolLine.UpdateBoxInfo(box_handle, g_nNowTime, box_handle.g_nEndTime)
		end
		index = index - 1
	end
	icons:FormatAllItemPos()
end

Wnd.OpenWindow("interface\\seCoolLine\\seCoolLine.ini", "seCoolLine")

function seCoolLine.GetMenu()
	local menu = {
		szOption = "seCoolLine 动感冷却条",
	}
	--开关
	local menu_bOn = {
		szOption = "开启动感冷却条",
		bCheck = true,
		bChecked = seCoolLine.bOn,
		fnAction = function()
			seCoolLine.bOn = not seCoolLine.bOn
			if seCoolLine.bOn then
				Station.Lookup("Normal/seCoolLine"):Show()
			else
				Station.Lookup("Normal/seCoolLine"):Hide()
			end
		end,
	}
	table.insert(menu, menu_bOn)
	local menu_bDragable = {
		szOption = "位置锁定",
		bCheck = true,
		bChecked = not seCoolLine.bDragable,
		fnAction = function()
			seCoolLine.bDragable = not seCoolLine.bDragable
			if seCoolLine.bDragable then
				Station.Lookup("Normal/seCoolLine"):EnableDrag(true)
			else
				Station.Lookup("Normal/seCoolLine"):EnableDrag(false)
			end
		end,
	}
	table.insert(menu, menu_bDragable)
	table.insert(menu, {bDevide = true} )
	local menu_Box = {
		szOption = "冷却图标设置",
	}
	--冷却计时
	local menu_bBoxTimer = {
		szOption = "图标计时",
		bCheck = true,
		bChecked = seCoolLine.bBoxTimer,
		fnAction = function()
			seCoolLine.bBoxTimer = not seCoolLine.bBoxTimer
		end,
	}
	table.insert(menu_Box, menu_bBoxTimer)
	--冷却前提示时间
	local menu_nLastTime = {
		szOption = "缩放渐变",
		{
			szOption = "不渐变",
			bMCheck = true,
			bChecked = seCoolLine.nLastTime == 10,
			fnAction = function()
				seCoolLine.nLastTime = 10
			end,
		},
		{
			szOption = "0.5 s",
			bMCheck = true,
			bChecked = seCoolLine.nLastTime == 500,
			fnAction = function()
				seCoolLine.nLastTime = 500
			end,
		},
		{
			szOption = "1.0 s",
			bMCheck = true,
			bChecked = seCoolLine.nLastTime == 1000,
			fnAction = function()
				seCoolLine.nLastTime = 1000
			end,
		},
		{
			szOption = "1.5 s",
			bMCheck = true,
			bChecked = seCoolLine.nLastTime == 1500,
			fnAction = function()
				seCoolLine.nLastTime = 1500
			end,
		},
	}
	table.insert(menu_Box, menu_nLastTime)
	
	--冷却后闪烁速度
	
	local menu_nRemainTime = {
		szOption = "闪烁速度",
		{
			szOption = "较快",
			bMCheck = true,
			bChecked = seCoolLine.nRemainTime == 300,
			fnAction = function()
				seCoolLine.nRemainTime = 300
			end,
		},
		{
			szOption = "一般",
			bMCheck = true,
			bChecked = seCoolLine.nRemainTime == 700,
			fnAction = function()
				seCoolLine.nRemainTime = 700
			end,
		},
		{
			szOption = "较慢",
			bMCheck = true,
			bChecked = seCoolLine.nRemainTime == 1000,
			fnAction = function()
				seCoolLine.nRemainTime = 1000
			end,
		},
	}
	table.insert(menu_Box, menu_nRemainTime)
	table.insert(menu, menu_Box)
	
	local menu_bar = {
		szOption = "冷却条设置",
	}
	--最大时间
	local menu_max_time = {
		szOption = "最大时间",
	}
	for i=1, #seCoolLine.Marks, 1 do
		local m = {
			szOption = seCoolLine.Marks[i].szOption,
			bMCheck = true,
			bChecked = seCoolLine.Marks[i].nTime == seCoolLine.nTimeMax,
			fnAction = function()
				seCoolLine.nTimeMax = seCoolLine.Marks[i].nTime
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		}
		table.insert(menu_max_time, m)
	end
	table.insert(menu_bar, menu_max_time)
	
	local menu_compression_time = {
		szOption = "时间压缩",
		{
			szOption = "不压缩", bMCheck = true, bChecked = seCoolLine.time_compression == 1, 
			fnAction = function()
				seCoolLine.time_compression = 1
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		},
		{
			szOption = "Lv 1", bMCheck = true, bChecked = seCoolLine.time_compression == 0.8, 
			fnAction = function()
				seCoolLine.time_compression = 0.8
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		},
		{
			szOption = "Lv 2", bMCheck = true, bChecked = seCoolLine.time_compression == 0.5, 
			fnAction = function()
				seCoolLine.time_compression = 0.5
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		},
		{
			szOption = "Lv 3", bMCheck = true, bChecked = seCoolLine.time_compression == 0.4, 
			fnAction = function()
				seCoolLine.time_compression = 0.4
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		},
		{
			szOption = "Lv 4", bMCheck = true, bChecked = seCoolLine.time_compression == 0.3, 
			fnAction = function()
				seCoolLine.time_compression = 0.3
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		},
		{
			szOption = "Lv 5", bMCheck = true, bChecked = seCoolLine.time_compression == 0.2, 
			fnAction = function()
				seCoolLine.time_compression = 0.2
				seCoolLine.UpdateMarkText(Station.Lookup("Normal/seCoolLine"))
			end,
		},
	}
	
	table.insert(menu_bar, menu_compression_time)
	table.insert(menu_bar, {
		szOption = "冷却条高度",
		{ szOption = "Lv 1", bMCheck = true, bChecked = seCoolLine.n_BoxSize == 30, fnAction = function() seCoolLine.OnUpdateHeight(30) end,}, 
		{ szOption = "Lv 2", bMCheck = true, bChecked = seCoolLine.n_BoxSize == 35, fnAction = function() seCoolLine.OnUpdateHeight(35) end,}, 
		{ szOption = "Lv 3", bMCheck = true, bChecked = seCoolLine.n_BoxSize == 40, fnAction = function() seCoolLine.OnUpdateHeight(40) end,}, 
		{ szOption = "Lv 4", bMCheck = true, bChecked = seCoolLine.n_BoxSize == 45, fnAction = function() seCoolLine.OnUpdateHeight(45) end,}, 
	})
	table.insert(menu, menu_bar)
	--技能忽略列表
	local menu_ignore = {
		szOption = "技能忽略列表",
	}
	local m = {
		szOption = "右键CD图标添加",
	}
	table.insert(menu_ignore, m)
	table.insert(menu_ignore, {bDevide = true})
	for i= 1, #seCoolLine.IgnoreSkills, 1 do
		local m = {
			szOption = Table_GetSkillName(seCoolLine.IgnoreSkills[i], GetClientPlayer().GetSkillLevel(seCoolLine.IgnoreSkills[i])),
			bCheck = true,
			bChecked = true,
			fnAction = function()
				table.remove(seCoolLine.IgnoreSkills, i)
				GetPopupMenu():Hide()
			end,
		}
		table.insert(menu_ignore, m)
	end
	
	table.insert(menu, menu_ignore)
	
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by 叶芷青、翼宿怜", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seCoolLine.GetMenu) end end)
