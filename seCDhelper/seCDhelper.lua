seCDhelper = {
	bOn = true,
	nDelay = 700,
	MAX_ALPHA = 192,
	CDSkills = {},
	box,
	alpha = 0,
	nEndTime = 0,
	nThreshold = 0,
}
RegisterCustomData("seCDhelper.bOn")
RegisterCustomData("seCDhelper.nDelay")
RegisterCustomData("seCDhelper.MAX_ALPHA")

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seCDhelper] " .. table.concat(a, "\t").. "\n" )
end

function seCDhelper.OnFrameCreate()
	this:RegisterEvent("CUSTOM_DATA_LOADED")
	this:RegisterEvent("UI_SCALED")
	this:RegisterEvent("seCDhelperAnchorChanged")
	seCDhelper.UpdateAnchor(this)
	local frame = Station.Lookup("Normal/seCDhelper")
	local handle = frame:Lookup("", "")
	seCDhelper.box = handle:Lookup(0)
	print(" Loaded...by 网通叶芷青、翼宿怜")
end

function seCDhelper.OnFrameRender()
	seCDhelper.alpha = (seCDhelper.nEndTime - GetTime()) * seCDhelper.MAX_ALPHA / seCDhelper.nDelay
	if seCDhelper.alpha < 0 then
		seCDhelper.alpha = 0
	end
	seCDhelper.box:SetAlpha(seCDhelper.alpha)
end

function seCDhelper.OnFrameBreathe()
	for k = 1, 4, 1 do
		if IsActionBarOpened(k) then
			local handle = GetActionBarFrame(k)
			local hBox = handle:Lookup("", "Handle_Box")
			local nCount = hBox:GetItemCount() - 1
			for i = 0, nCount, 1 do
				local box = hBox:Lookup(i)
				if not box:IsEmpty() then
					local nType = box:GetObjectType()
					if nType == UI_OBJECT_SKILL then
						local dwSkillID, dwSkillLevel = box:GetObjectData()
						local bCool, nLeft, nTotal = GetClientPlayer().GetSkillCDProgress(dwSkillID, dwSkillLevel)
						if nTotal > 24 and nTotal ~= 40 then
							seCDhelper.CDSkills[dwSkillID] = true
						end
					end
				end
			end
		end
	end
	for dwSkillID, value in pairs(seCDhelper.CDSkills) do
		local bCool, nLeft, nTotal = GetClientPlayer().GetSkillCDProgress(dwSkillID, GetClientPlayer().GetSkillLevel(dwSkillID))
		if nTotal < 25 then
			if seCDhelper.CDSkills[dwSkillID] then
				if seCDhelper.bOn then
					seCDhelper.alpha	=	seCDhelper.MAX_ALPHA
					seCDhelper.nEndTime = GetTime() + seCDhelper.nDelay
					seCDhelper.box:SetObject(UI_OBJECT_SKILL, dwSkillID, dwSkillLevel)
					seCDhelper.box:SetObjectIcon(Table_GetSkillIconID(dwSkillID, dwSkillLevel))
				end
				StartNewSparkingBox(dwSkillID, dwSkillLevel)
			end
			seCDhelper.CDSkills[dwSkillID] = false
		end
	end
end

function seCDhelper.OnEvent(event)
	if event == "UI_SCALED" then
		seCDhelper.UpdateAnchor(this)
	elseif event == "CUSTOM_DATA_LOADED" then
		seCDhelper.UpdateAnchor(this)
	elseif event == "seCDhelperAnchorChanged" then
		seCDhelper.UpdateAnchor(this)
	end
end

function seCDhelper.UpdateAnchor(frame)
	frame:SetPoint(seCDhelperAnchor.Anchor.s, 0, 0, seCDhelperAnchor.Anchor.r, seCDhelperAnchor.Anchor.x, seCDhelperAnchor.Anchor.y)
	frame:CorrectPos()
end

function seCDhelper.GetMenu()
	local menu = {
		szOption = "seCDhelper 冷却助手",
		{
			szOption = "开启中央提示",
			bCheck = true,
			bChecked = seCDhelper.bOn,
			fnAction = function()
				seCDhelper.bOn = not seCDhelper.bOn
			end,
		},
		{
			szOption = "开启动作条闪光",
			bCheck = true,
			bChecked = seSparkingBoxes.bOn,
			fnAction = function()
				seSparkingBoxes.bOn = not seSparkingBoxes.bOn
			end,
		},
		{
			bDevide = true,
		},
	}
	local menu_CCD = {
		szOption = "中央冷却设置",
		{
			szOption = "位置锁定", 
			bCheck = true, 
			bChecked = not seCDhelperAnchor.bDragable,
			fnAction = function()
				seCDhelperAnchor.bDragable = not seCDhelperAnchor.bDragable
				seCDhelperAnchor.UpdateDrag()
			end,
		},
		{
			bDevide = true,
		},
		{
			szOption = "初始透明度",
			{szOption = "Lv 1", bMCheck = true, bChecked = seCDhelper.MAX_ALPHA == 128, fnAction = function() seCDhelper.MAX_ALPHA = 128 end,},
			{szOption = "Lv 2", bMCheck = true, bChecked = seCDhelper.MAX_ALPHA == 160, fnAction = function() seCDhelper.MAX_ALPHA = 160 end,},
			{szOption = "Lv 3", bMCheck = true, bChecked = seCDhelper.MAX_ALPHA == 192, fnAction = function() seCDhelper.MAX_ALPHA = 192 end,},
			{szOption = "Lv 4", bMCheck = true, bChecked = seCDhelper.MAX_ALPHA == 224, fnAction = function() seCDhelper.MAX_ALPHA = 224 end,},
			{szOption = "Lv 5", bMCheck = true, bChecked = seCDhelper.MAX_ALPHA == 256, fnAction = function() seCDhelper.MAX_ALPHA = 256 end,},
		},
		{
			szOption = "闪烁速度",
			{szOption = "很快", bMCheck = true, bChecked = seCDhelper.nDelay == 300, fnAction = function() seCDhelper.nDelay = 300 end,},
			{szOption = "快", bMCheck = true, bChecked = seCDhelper.nDelay == 500, fnAction = function() seCDhelper.nDelay = 500 end,},
			{szOption = "一般", bMCheck = true, bChecked = seCDhelper.nDelay == 700, fnAction = function() seCDhelper.nDelay = 700 end,},
			{szOption = "慢", bMCheck = true, bChecked = seCDhelper.nDelay == 1000, fnAction = function() seCDhelper.nDelay = 800 end,},
			{szOption = "很快", bMCheck = true, bChecked = seCDhelper.nDelay == 2000, fnAction = function() seCDhelper.nDelay = 1000 end,},
		},
	}
	table.insert(menu, menu_CCD)
	local menu_ACD = {
		szOption = "动作条冷却设置",
		{
			szOption = "初始透明度",
			{szOption = "Lv 1", bMCheck = true, bChecked = seSparkingBoxes.MAX_ALPHA == 128, fnAction = function() seSparkingBoxes.MAX_ALPHA = 128 end,},
			{szOption = "Lv 2", bMCheck = true, bChecked = seSparkingBoxes.MAX_ALPHA == 160, fnAction = function() seSparkingBoxes.MAX_ALPHA = 160 end,},
			{szOption = "Lv 3", bMCheck = true, bChecked = seSparkingBoxes.MAX_ALPHA == 192, fnAction = function() seSparkingBoxes.MAX_ALPHA = 192 end,},
			{szOption = "Lv 4", bMCheck = true, bChecked = seSparkingBoxes.MAX_ALPHA == 224, fnAction = function() seSparkingBoxes.MAX_ALPHA = 224 end,},
			{szOption = "Lv 5", bMCheck = true, bChecked = seSparkingBoxes.MAX_ALPHA == 256, fnAction = function() seSparkingBoxes.MAX_ALPHA = 256 end,},
		},
		{
			szOption = "初始大小",
			{szOption = "Lv 1", bMCheck = true, bChecked = seSparkingBoxes.nBoxSize == 128, fnAction = function() seSparkingBoxes.nBoxSize = 128 end,},
			{szOption = "Lv 2", bMCheck = true, bChecked = seSparkingBoxes.nBoxSize == 192, fnAction = function() seSparkingBoxes.nBoxSize = 192 end,},
			{szOption = "Lv 3", bMCheck = true, bChecked = seSparkingBoxes.nBoxSize == 256, fnAction = function() seSparkingBoxes.nBoxSize = 256 end,},
			{szOption = "Lv 4", bMCheck = true, bChecked = seSparkingBoxes.nBoxSize == 320, fnAction = function() seSparkingBoxes.nBoxSize = 320 end,},
			{szOption = "Lv 5", bMCheck = true, bChecked = seSparkingBoxes.nBoxSize == 384, fnAction = function() seSparkingBoxes.nBoxSize = 384 end,},
		},
		{
			szOption = "闪烁速度",
			{szOption = "很快", bMCheck = true, bChecked = seSparkingBoxes.nDelay == 300, fnAction = function() seSparkingBoxes.nDelay = 300 end,},
			{szOption = "快", bMCheck = true, bChecked = seSparkingBoxes.nDelay == 500, fnAction = function() seSparkingBoxes.nDelay = 500 end,},
			{szOption = "一般", bMCheck = true, bChecked = seSparkingBoxes.nDelay == 800, fnAction = function() seSparkingBoxes.nDelay = 800 end,},
			{szOption = "慢", bMCheck = true, bChecked = seSparkingBoxes.nDelay == 1000, fnAction = function() seSparkingBoxes.nDelay = 1000 end,},
			{szOption = "很慢", bMCheck = true, bChecked = seSparkingBoxes.nDelay == 2000, fnAction = function() seSparkingBoxes.nDelay = 2000 end,},
		},
	}
	local menu_texture = {
		szOption = "材质风格",
	}
	for i, v in pairs(seSparkingBoxes.tShowTexture) do
		table.insert(menu_texture, {
			szOption = v.szName,
			bMCheck = true,
			bChecked = seSparkingBoxes.nShowType == i,
			fnAction = function()
				seSparkingBoxes.nShowType = i
			end,
		})
	end
	table.insert(menu_ACD, menu_texture)
	table.insert(menu, menu_ACD)

	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by 叶芷青、翼宿怜", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
	
end

Wnd.OpenWindow("interface\\seCDhelper\\seCDhelper.ini", "seCDhelper")
RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seCDhelper.GetMenu) end end)
