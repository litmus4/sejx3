seBuffTimerAnchor = {
	bDragable = false,
	Anchor = { s = "CENTER", r = "CENTER", x = 200, y = 0, },
}

RegisterCustomData("seBuffTimerAnchor.Anchor")
RegisterCustomData("seBuffTimerAnchor.bDragable")

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seBuffTimer] " .. table.concat(a, "\t").. "\n" )
end

function seBuffTimerAnchor.OnFrameCreate()
	this:RegisterEvent("UI_SCALED")
end

function seBuffTimerAnchor.OnEvent(event)
	if event == "UI_SCALED" then
		seBuffTimerAnchor.UpdateAnchor(this)
		seBuffTimerAnchor.UpdateDrag()
		FireEvent("seBuffTimerAnchorChanged")
	end
end

function seBuffTimerAnchor.OnFrameDrag()

end

function seBuffTimerAnchor.UpdateDrag()
	if seBuffTimerAnchor.bDragable then
	 	Station.Lookup("Topmost/seBuffTimerAnchor"):Show()
	else
		Station.Lookup("Topmost/seBuffTimerAnchor"):Hide()
	end
end

function seBuffTimerAnchor.OnFrameDragSetPosEnd()	
	this:CorrectPos()
	seBuffTimerAnchor.Anchor = GetFrameAnchor(this)
	FireEvent("seBuffTimerAnchorChanged")
end

function seBuffTimerAnchor.OnFrameDragEnd()
	this:CorrectPos()
	seBuffTimerAnchor.Anchor = GetFrameAnchor(this)
	FireEvent("seBuffTimerAnchorChanged")
end

function seBuffTimerAnchor.UpdateAnchor(frame)
	local anchor = seBuffTimerAnchor.Anchor
	frame:SetPoint(anchor.s, 0, 0, anchor.r, anchor.x, anchor.y)
	frame:CorrectPos()
end

Wnd.OpenWindow("interface\\seEventAlert\\seBuffTimerAnchor.ini", "seBuffTimerAnchor")
