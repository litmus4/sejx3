seBuffTimer = {
	DIRECTION_RIGHT = 0,
	DIRECTION_LEFT = 1,
	DIRECTION_BOTTOM = 2,
	DIRECTION_TOP = 3,
	nWidth = 100,
	nHeight = 160,
	nDirection = 0,
	nDistance = 30,
	nMaxAlpha = 196,
	nMinAlpha = 64,
	
}
RegisterCustomData("seBuffTimer.nDirection")
RegisterCustomData("seBuffTimer.nDistance")
function seBuffTimer.OnFrameCreate()
	this:RegisterEvent("UI_SCALED")
	this:RegisterEvent("seBuffTimerAnchorChanged")
	this:Lookup("",""):Clear()
end

function seBuffTimer.OnEvent(event)
	if event == "UI_SCALED" or event == "seBuffTimerAnchorChanged" then
		this:SetPoint(seBuffTimerAnchor.Anchor.s, 0,0, seBuffTimerAnchor.Anchor.r, seBuffTimerAnchor.Anchor.x, seBuffTimerAnchor.Anchor.y)
	end
end

function seBuffTimer.OnFrameRender()
	local handle = this:Lookup("","")
	local i = 0
	while i < handle:GetItemCount() do
		local timer = handle:Lookup(i)
		local strTimeLeft = (timer.nEndTime - GetTime())/1000
		if strTimeLeft < 0 then
			handle:RemoveItem(i)
		else
			--[[
			if strTimeLeft < 1 then
				timer:Lookup("Box"):Hide()
			else
				timer:Lookup("Box"):Show()
			end
			]]
			local text_timeLeft = timer:Lookup("TimeLeft")
			if strTimeLeft < 3 then
				--[[
				--0		0
				--1		nMax
				--2		0
				--3		nMax
				--4		0
				--5		nMax
				--]]
				
				--timer:SetAlpha(seBuffTimer.nMinAlpha + (seBuffTimer.nMaxAlpha - seBuffTimer.nMinAlpha) * ( 1 - math.abs(strTimeLeft % 2 - 1) ) )
				local box_f = timer:Lookup("Box_F")
				box_f:Show()
				box_f:SetAlpha(seBuffTimer.nMaxAlpha *  (strTimeLeft % 1) / 1 )
				scale = 1.7 ^ (1 - (strTimeLeft % 1) / 1)
				box_f:SetSize( box_f.org_w * scale, box_f.org_h * scale )
				box_f:SetRelPos(box_f.org_x - box_f.org_w * (scale - 1) / 2, box_f.org_y - box_f.org_h * (scale - 1) / 2 )

				if (strTimeLeft - math.floor(strTimeLeft)) > 0.5 then
					text_timeLeft:SetFontColor(255,0,0)
				else
					text_timeLeft:SetFontColor(255,255,255)
				end
			else
				timer:Lookup("Box_F"):Hide()
			end
			if Table_BuffNeedShowTime(timer.dwBuffID, timer.dwBuffLevel) then
				text_timeLeft:SetText(math.floor(strTimeLeft))
			else
				text_timeLeft:SetText("")
			end
			if seBuffTimer.nDirection == seBuffTimer.DIRECTION_RIGHT then
				timer:SetRelPos(i * (seBuffTimer.nWidth + seBuffTimer.nDistance), 0)
			elseif seBuffTimer.nDirection == seBuffTimer.DIRECTION_LEFT then
				timer:SetRelPos(0 - i * (seBuffTimer.nWidth + seBuffTimer.nDistance), 0)
			elseif seBuffTimer.nDirection == seBuffTimer.DIRECTION_BOTTOM then
				timer:SetRelPos(0, i * (seBuffTimer.nHeight + seBuffTimer.nDistance))
			elseif seBuffTimer.nDirection == seBuffTimer.DIRECTION_TOP then
				timer:SetRelPos(0, 0 - i * (seBuffTimer.nHeight + seBuffTimer.nDistance))
			end
			i = i + 1
		end
		timer:FormatAllItemPos()
	end
	handle:FormatAllItemPos()
end

function seBuffTimer.GetTimerByBuffID(handle, dwBuffID)
	local count = handle:GetItemCount() - 1
	for i=0, count, 1 do
		local timer = handle:Lookup(i)
		if timer.dwBuffID == dwBuffID then
			return timer
		end
	end
	return nil
end

function seBuffTimer.RemoveBuffTimer(dwBuffID, dwBuffLevel, nStackNum, nEndFrame)
	local handle = Station.Lookup("Normal/seBuffTimer"):Lookup("","")
	local timer = seBuffTimer.GetTimerByBuffID(handle, dwBuffID)
	if timer then
		timer:GetParent():RemoveItem(timer)
	end
end

function seBuffTimer.StartNewBuffTimer(dwBuffID, dwBuffLevel, nStackNum, nEndFrame)
	local handle = Station.Lookup("Normal/seBuffTimer"):Lookup("","")
	local timer = seBuffTimer.GetTimerByBuffID(handle, dwBuffID)
	if not timer then
		local szIniFile = "interface\\seEventAlert\\seBuffTimer.ini"
		handle:AppendItemFromIni(szIniFile, "Hanele_Timer")
		timer = handle:Lookup(handle:GetItemCount()-1)
		timer:SetRelPos((handle:GetItemCount()-1) * seBuffTimer.nDistance, 0)
		timer:SetAlpha(seBuffTimer.nMaxAlpha)
		--timer:Lookup("TimeLeft"):SetFontColor(255,255,255)
		--timer:Lookup("BuffName"):SetFontColor(255,255,255)
		local box = timer:Lookup("Box_F")
		box.org_x, box.org_y = box:GetRelPos()
		box.org_w, box.org_h = box:GetSize()
		handle:FormatAllItemPos()
	end
	timer.dwBuffID = dwBuffID
	timer.dwBuffLevel = dwBuffLevel
	timer.nEndTime = GetTime() + (nEndFrame - GetLogicFrameCount()) * 1000 / 16
	local box = timer:Lookup("Box")
	box:SetObject(UI_OBJECT_NOT_NEED_KNOWN, dwBuffID)
	box:SetObjectIcon(Table_GetBuffIconID(dwBuffID, dwBuffLevel))
	box = timer:Lookup("Box_F")
	box:SetObject(UI_OBJECT_NOT_NEED_KNOWN, dwBuffID)
	box:SetObjectIcon(Table_GetBuffIconID(dwBuffID, dwBuffLevel))
	box:Hide()
	if nStackNum > 1 then
		timer:Lookup("BuffName"):SetText(Table_GetBuffName(dwBuffID, dwBuffLevel).." x "..nStackNum)
	else
		timer:Lookup("BuffName"):SetText(Table_GetBuffName(dwBuffID, dwBuffLevel))
	end
end

Wnd.OpenWindow("interface\\seEventAlert\\seBuffTimer.ini", "seBuffTimer")
