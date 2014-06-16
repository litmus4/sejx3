seSparkingBoxes = {
	bOn = true,
	tShowTexture = {
		{ szName = "技能图标" },
		{ szName = "闪光", Path = "star.UITex", },
		{ szName = "Ping", Path = "ping.UITex", },
		{ szName = "爆炸", Path = "starburst.UITex", },
		{ szName = "Wave", Path = "wave.UITex", },
	},
	nBoxSize = 320,
	nDelay = 1000,
	MAX_ALPHA = 256,
	nShowType = 2,
}
RegisterCustomData("seSparkingBoxes.bOn")
RegisterCustomData("seSparkingBoxes.nBoxSize")
RegisterCustomData("seSparkingBoxes.MAX_ALPHA")
RegisterCustomData("seSparkingBoxes.nDelay")
RegisterCustomData("seSparkingBoxes.nShowType")

function seSparkingBoxes.OnFrameCreate()
end

function seSparkingBoxes.OnFrameRender()
	local handle_boxes = this:Lookup("",""):Lookup("BoxList")
	local i = 0
	while i < handle_boxes:GetItemCount() do
		local sparking_box = handle_boxes:Lookup(i)
		if GetTime() > sparking_box.nEndTime then
			handle_boxes:RemoveItem(i)
		else
			local scale = (sparking_box.nEndTime - GetTime()) / seSparkingBoxes.nDelay
			local box = sparking_box.tBox
			local x, y = box:GetAbsPos()
			local w, h = box:GetSize()
			sparking_box:SetAlpha(seSparkingBoxes.MAX_ALPHA * scale)
			sparking_box:SetSize(seSparkingBoxes.nBoxSize * scale, seSparkingBoxes.nBoxSize * scale)
			sparking_box:SetRelPos(x + w / 2 - seSparkingBoxes.nBoxSize * scale / 2, y + h / 2 - seSparkingBoxes.nBoxSize * scale / 2)
			i = i + 1
		end
	end
	handle_boxes:FormatAllItemPos()
	this:Lookup("",""):FormatAllItemPos()
end

function seSparkingBoxes.CreateSparkingBox(dwSkillID, dwSkillLevel, box)
	local frame = Station.Lookup("Topmost/seSparkingBoxes")
	local handle_boxes = frame:Lookup("",""):Lookup("BoxList")
	local sparking_box
	if seSparkingBoxes.nShowType == 1 then
		handle_boxes:AppendItemFromString("<box>w="..seSparkingBoxes.nBoxSize.." h="..seSparkingBoxes.nBoxSize.." lockshowhide=1 </box>")
		sparking_box = handle_boxes:Lookup(handle_boxes:GetItemCount()-1)
		sparking_box:SetObject(UI_OBJECT_SKILL, dwSkillID, dwSkillLevel)
		sparking_box:SetObjectIcon(Table_GetSkillIconID(dwSkillID, dwSkillLevel))
	else
		handle_boxes:AppendItemFromString("<image>frame=0 imagetype=1 w="..seSparkingBoxes.nBoxSize.." h="..seSparkingBoxes.nBoxSize.." path=\"Interface\\seCDhelper\\"..seSparkingBoxes.tShowTexture[seSparkingBoxes.nShowType].Path.."\" </image>")
		sparking_box = handle_boxes:Lookup(handle_boxes:GetItemCount()-1)
	end
	sparking_box:Show()
	sparking_box.tBox = box
	sparking_box.nEndTime = GetTime() + seSparkingBoxes.nDelay
	sparking_box:SetAlpha(seSparkingBoxes.MAX_ALPHA)
	local x, y = box:GetAbsPos()
	local w, h = box:GetSize()
	sparking_box:SetRelPos(x + w / 2 - seSparkingBoxes.nBoxSize / 2, y + h / 2 - seSparkingBoxes.nBoxSize / 2)
	handle_boxes:FormatAllItemPos()
	frame:Lookup("",""):FormatAllItemPos()
end

function StartNewSparkingBox(dwSkillID, dwSkillLevel)
	if not seSparkingBoxes.bOn then
		return
	end
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
						local _dwSkillID, _dwSkillLevel = box:GetObjectData()
						if dwSkillID == _dwSkillID then
							seSparkingBoxes.CreateSparkingBox(dwSkillID, dwSkillLevel, box)
						end
					end
				end
			end
		end
	end
end

Wnd.OpenWindow("interface\\seCDhelper\\seSparkingBoxes.ini", "seSparkingBoxes")
